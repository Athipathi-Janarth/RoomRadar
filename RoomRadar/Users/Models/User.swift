//
//  User.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/13/23.
//

import Foundation
class User:Codable{
    var userID: String
    var name: String
    var userName: String
    var isHost: Bool
    init(userID: String, name: String, userName: String,isHost: Bool) {
        self.userID = userID
        self.name = name
        self.userName = userName
        self.isHost = isHost
    }
}
