//
//  CountryCode.swift
//  Axle
//
//  Created by Rajin Gangadharan on 07/04/25.
//

import Foundation

struct CountryCode: Decodable {
    let id: Int
    let name: String
    let dialcode: String
    let countrycode: String
}
