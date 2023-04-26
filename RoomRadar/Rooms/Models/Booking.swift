//
//  Booking.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/25/23.
//

import Foundation
class Booking{
    var BookingID: String
    var AccomodationID: String
    var HostID: String
    var UserID: String
    var Status:String
    var Room:RoomDetails
    var Host:User
    init(BookingID:String, AccomodationID: String, HostID: String, UserID: String, Status: String, Room: RoomDetails,Host: User) {
        self.BookingID=BookingID
        self.AccomodationID = AccomodationID
        self.HostID = HostID
        self.UserID = UserID
        self.Status = Status
        self.Room = Room
        self.Host = Host
    }
    
}
class BookingList{
    var BookingLists:[Booking] = []
    func getBookings()->[Booking]{
        return BookingLists
    }
    func add(booking: Booking){
        BookingLists.append(booking)
    }
}

