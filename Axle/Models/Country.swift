//
//  Country.swift
//  Axle
//
//  Created by Rajin Gangadharan on 28/03/25.
//

import Foundation

struct Country {
    let code: String
    let name: String
    let phoneCode: String
    var flag: String {
        return countryCodeToFlag(code) ?? "🏳️"
    }
}

func countryCodeToFlag(_ countryCode: String) -> String? {
    let base: UInt32 = 127397
    var scalarView = String.UnicodeScalarView()
    for i in countryCode.uppercased().unicodeScalars {
        if let val = UnicodeScalar(base + i.value) {
            scalarView.append(val)
        } else {
            return nil
        }
    }
    return String(scalarView)
}

var countries: [Country] = []
