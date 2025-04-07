//
//  GraphQLResponse.swift
//  Axle
//
//  Created by Rajin Gangadharan on 07/04/25.
//

import Foundation

struct GraphQLResponse<T: Decodable>: Decodable {
    let data: T?
    let errors: [GraphQLError]?
}
