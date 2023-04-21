//
//  RoomDetails.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/14/23.
//

import Foundation
class RoomDetails{
    var accomodationID: String
    var address: String
    var no_of_Rooms: Int
    var no_of_Bath: Int
    var preffered_Gender : String
    var Rent: Float
    var available :Bool
    var startDate: Date
    var endDate: Date
    var vacant: Int
    var spot: String?
    var description: String?
    var room_Image: String
    var rating:Int
    var isTemporary: Bool
    var userID: String
   
    init(accomodationID:String? = nil ,userID: String, address: String, no_of_Rooms: Int, no_of_Bath: Int, preffered_Gender: String, Rent: Float, available: Bool, startDate: Date, endDate: Date, vacant: Int, spot: String? = nil, description: String? = nil, room_Image: String, rating: Int, isTemporary: Bool) {
        self.accomodationID = accomodationID ?? ""
        self.address = address
        self.no_of_Rooms = no_of_Rooms
        self.no_of_Bath = no_of_Bath
        self.preffered_Gender = preffered_Gender
        self.Rent = Rent
        self.available = available
        self.startDate = startDate
        self.endDate = endDate
        self.vacant = vacant
        self.spot = spot
        self.description = description
        self.room_Image = room_Image
        self.rating = rating
        self.isTemporary = isTemporary
        self.userID = userID
    }
}
class RoomList{
    var roomLists:[RoomDetails] = []
    func getRooms()->[RoomDetails]{
        return roomLists
    }
    func add(room: RoomDetails){
        roomLists.append(room)
    }
}
