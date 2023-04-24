//
//  Review.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/22/23.
//

import Foundation
class Review{
    var ReviewID:String
    var Comment:String
    var User:String
    var accomodationID:String
    var rating:Float
    
    init(Comment: String, User: String, accomodationID: String, rating: Float) {
        self.ReviewID = ""
        self.Comment = Comment
        self.User = User
        self.accomodationID = accomodationID
        self.rating = rating
    }
}
class ReviewList{
    var ReviewLists:[Review] = []
    func getReview()->[Review]{
        return ReviewLists
    }
    func add(review: Review){
        ReviewLists.append(review)
    }
}
