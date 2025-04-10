//
//  UserProfileData.swift
//  Axle
//
//  Created by Rajin Gangadharan on 08/04/25.
//

import Foundation

class UserProfileData {
    
    static let shared = UserProfileData()
    
    private var mobileNumber = ""
    
    private init() {}
    
    public func setMobileNumber(phoneNumber: String) {
        self.mobileNumber = phoneNumber
    }
    
    public func reset() {
        mobileNumber = ""
    }
    
}
