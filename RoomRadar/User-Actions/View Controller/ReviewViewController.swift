//
//  ReviewViewController.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/21/23.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class ReviewViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
        var room:RoomDetails?
        var user:User?
        let storageRef = Storage.storage().reference()
        let db = Firestore.firestore()
        @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var RoomImage: UIImageView!
        @IBOutlet weak var address: UILabel!
        @IBOutlet weak var Rooms: UILabel!
        @IBOutlet weak var SpotType: UILabel!
        @IBOutlet weak var Rating: UILabel!
        @IBOutlet weak var Rent: UILabel!
        @IBOutlet weak var AccomodationType: UILabel!
    @IBOutlet weak var ReviewScore: UITextField!
    @IBOutlet weak var ReviewComment: UITextView!
    @IBAction func AddReview(_ sender: Any) {
        guard let reviewScore = ReviewScore.text, !reviewScore.isEmpty,
                 let score = Float(reviewScore), score >= 1, score <= 5 else {
               showAlert(message: "Please enter a valid review score between 1 and 5.")
               return
           }

           guard let reviewComment = ReviewComment.text, !reviewComment.isEmpty else {
               showAlert(message: "Please enter a review comment.")
               return
           }
        let review = Review(Comment: reviewComment, User: user?.name ?? "", accomodationID: room?.accomodationID ?? "", rating: score)
        
        let reviewCollections = self.db.collection("reviews")
        let data: [String: Any] = [
            "Comment": review.Comment,
               "User": review.User,
               "accomodationID": review.accomodationID,
               "rating": review.rating
        ]
        reviewCollections.addDocument(data: data) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully!")
                //self.clearFields()
                //self.navigationController?.popViewController(animated: true)
            }
        }
    }
    func showAlert(message: String, title:String = "Error") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
            super.viewDidLoad()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = 125.0
            let decoder = JSONDecoder()
            if let savedData = UserDefaults.standard.object(forKey: "userSession") as? Data,
               let loadedSession = try? decoder.decode(User.self, from: savedData) {
                self.user=loadedSession
            }
        address.text=room?.address
        Rooms.text="\(room?.no_of_Rooms ?? 0)"
        SpotType.text=room?.spot
        AccomodationType.text=((room?.isTemporary) != false) ? "Temporary" : "Permanent"
        Rating.text="\(room?.rating ?? 0)"
        Rent.text="$\(String(describing: room?.Rent ?? 0))"
            // Do any additional setup after loading the view.
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as!ReviewViewCell
//        let imageUrl = URL(string: roomList.getRooms()[indexPath.row].room_Image)
//        let placeholderImage = UIImage(named: "launch-screen")
//        cell.RoomImage.kf.setImage(with: imageUrl, placeholder: placeholderImage)
//        cell.address.text=roomList.getRooms()[indexPath.row].address
//        cell.Vacant.text="\(roomList.getRooms()[indexPath.row].vacant)"
//        cell.Rooms.text="\(roomList.getRooms()[indexPath.row].no_of_Rooms)"
//        cell.AccomodationType.text=(roomList.getRooms()[indexPath.row].isTemporary) ? "Temporary" : "Permanent"
//        cell.SpotType.text=roomList.getRooms()[indexPath.row].spot
//        cell.Rating.text="\(roomList.getRooms()[indexPath.row].rating)"
//        cell.Rent.text="\(String(describing: roomList.getRooms()[indexPath.row].Rent))/Day"
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
