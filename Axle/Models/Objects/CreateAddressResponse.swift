//
//  VerifyOTPResponse.swift
//  Axle
//
//  Created by Rajin Gangadharan on 09/04/25.
//

import Foundation

struct CreateAddressResponse: Decodable {
    let createUserAddress: AddressResponse
}

struct AddressResponse: Decodable {
    let user_id: Int
    let label: String
    let latitude: Float
    let longitude: Float
}
