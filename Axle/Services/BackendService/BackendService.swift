//
//  BackendService.swift
//  Axle
//
//  Created by Rajin Gangadharan on 07/04/25.
//

import Foundation
import FirebaseRemoteConfig

class BackendService {
    
    static let shared = BackendService() //Singleton object
    
    private init() {} //Initializer
    
    private let remoteConfig = RemoteConfig.remoteConfig() //RemoteConfig Object
    private var graphqlURL: URL = URL(string: "http://localhost:4000")! //GraphQL URL
    private var isURLFetchComplete: Bool = false //Fetch status
    
    //Configure Remote Config
    func configureRemoteConfig() {
        let settings = RemoteConfigSettings()
        remoteConfig.configSettings = settings
    }
    
    //Fetch GraphQL URL from Remote Config
    func fetchGraphQLURL(completion: @escaping (URL) -> Void) {
        configureRemoteConfig() //Remote Config Configuration
        
        //Fetch graphql url
        remoteConfig.fetchAndActivate { [weak self] (status, error) in
            if error == nil {
                let urlString = self?.remoteConfig.configValue(forKey: "graphql_url").stringValue ?? "http://localhost:4000" //Graphql URL
                self?.graphqlURL = URL(string: urlString)!
            } else {
                print("Error fetching Remote Config: \(error?.localizedDescription ?? "Unknown error")")
            }
            self?.isURLFetchComplete = true
            completion(self?.graphqlURL ?? URL(string: "http://localhost:4000")!)
        }
    }
    
    //Check Backend Status
    func checkBackendStatus(completion: @escaping (Bool) -> Void) {
        //Graphql URL
        guard let url = URL(string: graphqlURL.absoluteString) else {
            completion(false)
            return;
        }
        
        //API Request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            //Error in backend
            if let error = error {
                print("Backend Status Check Error: \(error)")
                completion(false)
                return
            }
            
            //Response Status not success
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Backend Status Check: Invalid HTTP Status Code")
                completion(false)
                return
            }
            
            //Nil Data
            guard let data = data else {
                print("Backend Status Check: No Data Received")
                completion(false)
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(BackendStatusResponse.self, from: data) //Parse Data
                if decodedResponse.success {
                    completion(true)
                } else {
                    print("Backend Status Check: Success false, Message: \(decodedResponse.message ?? "Unknown")")
                    completion(false)
                }
            } catch {
                print("Backend Status Check: JSON Decoding Error: \(error)")
                completion(false)
            }
        }.resume()
    }
    
    //Perform GraphQL Request
    func performGraphQLRequest<T: Decodable>(query: String, completion: @escaping (Result<T, Error>) -> Void) {
        //GraphQL URL
        guard let url = URL(string: "\(graphqlURL.absoluteString)/graphql") else {
            completion(.failure(NSError(domain: "URLError", code: -1000, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        //API Request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["query": query])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(GraphQLResponse<T>.self, from: data)
                if let errors = decodedResponse.errors {
                    let error = NSError(domain: "GraphQL", code: 0, userInfo: [NSLocalizedDescriptionKey: errors.map { $0.message }.joined(separator: ", ")])
                    completion(.failure(error))
                } else if let data = decodedResponse.data {
                    completion(.success(data))
                } else {
                    completion(.failure(NSError(domain: "GraphQL", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data or errors"])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
