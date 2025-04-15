//
//  UserProfileData.swift
//  Axle
//
//  Created by Rajin Gangadharan on 08/04/25.
//

import Foundation

class UserProfileData {
    
    static let shared = UserProfileData()
    
    private var userId = -1
    
    private var mobileNumber = ""
    private var emailAddress = ""
    private var firstName = ""
    private var lastName = ""
    private var termsAndConditions = false
    
    private var currentLocation = ""
    private var currentLatitude = ""
    private var currentLongitude = ""
    
    private var apt_name = ""
    private var building_name = ""
    private var pickUpType = ""
    private var label = ""
    
    private init() {}
    
    public func getUserId() -> Int {
        return userId
    }
    
    public func setUserId(userId: Int) {
        self.userId = userId
    }
    
    public func getMobileNumber() -> String {
        return mobileNumber
    }
    
    
    public func setMobileNumber(phoneNumber: String) {
        self.mobileNumber = phoneNumber
    }
    
    public func getEmailAddress() -> String {
        return emailAddress
    }
    
    public func setEmailAddress(emailAddress: String) {
        self.emailAddress = emailAddress
    }
    
    public func getFirstName() -> String{
        return firstName
    }
    
    public func setFirstName(firstName: String) {
        self.firstName = firstName
    }
    
    public func getLastName() -> String {
        return lastName
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
    
    public func getCurrentLatitude() -> String {
        return currentLatitude
    }
    
    public func setCurrentLongitude(longitude: String) {
        self.currentLongitude = longitude
    }
    
    public func getCurrentLongitude() -> String {
        return currentLongitude
    }
    
    public func getAptName() -> String {
        return apt_name
    }
    
    public func setAptName(aptName: String) {
        self.apt_name = aptName
    }
    
    public func getBuildingName() -> String {
        return building_name
    }
    
    public func setBuildingName(buildName: String) {
        self.building_name = buildName
    }
    
    public func getPickupType() -> String {
        return pickUpType
    }
    
    public func setPickupType(pickupType: String) {
        self.pickUpType = pickupType
    }
    
    public func getPickupLabel() -> String {
        return label
    }
    
    public func setPickupLabel(label: String) {
        self.label = label
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
        apt_name = ""
        building_name = ""
        pickUpType = ""
        label = ""
    }
    
}
