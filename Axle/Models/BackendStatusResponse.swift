//
//  BackendStatusResponse.swift
//  Axle
//
//  Created by Rajin Gangadharan on 07/04/25.
//

import Foundation

struct BackendStatusResponse: Decodable {
    let success: Bool
    let message: String?
}
