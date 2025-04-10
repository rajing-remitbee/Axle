//
//  GraphQLResponse.swift
//  Axle
//
//  Created by Rajin Gangadharan on 07/04/25.
//

struct GraphQLResponse<T: Decodable>: Decodable {
    let data: T?
    let errors: [GraphQLError]?
}
