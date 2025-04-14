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
    private var emailAddress = ""
    private var firstName = ""
    private var lastName = ""
    private var termsAndConditions = false
    private var currentLocation = ""
    private var currentLatitude = ""
    private var currentLongitude = ""
    
    private init() {}
    
    public func setMobileNumber(phoneNumber: String) {
        self.mobileNumber = phoneNumber
    }
    
    public func setEmailAddress(emailAddress: String) {
        self.emailAddress = emailAddress
    }
    
    public func setFirstName(firstName: String) {
        self.firstName = firstName
    }
    
    public func setLastName(lastName: String) {
        self.lastName = lastName
    }
    
    public func setTermsAndConditions(choice: Bool) {
        self.termsAndConditions = choice
    }
    
    public func setCurrentLocation(location: String) {
        self.currentLocation = location
    }
    
    public func getCurrentLocation() -> String {
        return self.currentLocation
    }
    
    public func setCurrentLatitude(latitude: String) {
        self.currentLatitude = latitude
    }
    
    public func setCurrentLongitude(longitude: String) {
        self.currentLongitude = longitude
    }
    
    public func reset() {
        mobileNumber = ""
        emailAddress = ""
        firstName = ""
        lastName = ""
        termsAndConditions = false
        currentLocation = ""
        currentLatitude = ""
        currentLongitude = ""
    }
    
}
