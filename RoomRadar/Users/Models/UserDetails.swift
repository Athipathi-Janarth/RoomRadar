//
//  UserDetails.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/28/23.
//

import Foundation

class UserPreferences {
    var degree: String
    var gender: String
    var isVeg: Bool
    var knownLanguage: String
    var mixedGenderApt: Bool
    var nationality: String
    var spot: String
    var username: String
    var userID: String
    
    init(degree: String, gender: String, isVeg: Bool, knownLanguage: String, mixedGenderApt: Bool, nationality: String, spot: String, username: String, userID: String) {
        self.degree = degree
        self.gender = gender
        self.isVeg = isVeg
        self.knownLanguage = knownLanguage
        self.mixedGenderApt = mixedGenderApt
        self.nationality = nationality
        self.spot = spot
        self.username = username
        self.userID = userID
    }
}
