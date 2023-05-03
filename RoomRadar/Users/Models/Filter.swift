//
//  Filter.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/28/23.
//

import Foundation
class Filter {
    var degree: String?
    var gender: String?
    var isVeg: Bool?
    var knownLanguage: String?
    var mixedGenderApt: Bool?
    var nationality: String?
    var spot: String?
    init(degree: String?, gender: String?, isVeg: Bool?, knownLanguage: String?, mixedGenderApt: Bool?, nationality: String?, spot: String?) {
            self.degree = degree
            self.gender = gender
            self.isVeg = isVeg
            self.knownLanguage = knownLanguage
            self.mixedGenderApt = mixedGenderApt
            self.nationality = nationality
            self.spot = spot
        }
}
class FilterManager {
    static let shared = Filter(degree: nil, gender: nil, isVeg: nil, knownLanguage: nil, mixedGenderApt: nil, nationality: nil, spot: nil)
}
