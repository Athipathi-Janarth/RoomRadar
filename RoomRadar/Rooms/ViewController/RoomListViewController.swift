//
//  RoomListViewController.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/14/23.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import Kingfisher

class RoomListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var roomList = RoomList()
    var user:User?
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 200.0
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            user = appDelegate.user
        }
        getRooms()
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomList.getRooms().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostViewCell
        let imageUrl = URL(string: roomList.getRooms()[indexPath.row].room_Image)
        let placeholderImage = UIImage(named: "launch-screen")
        cell.RoomImage.kf.setImage(with: imageUrl, placeholder: placeholderImage)
        cell.address.text=roomList.getRooms()[indexPath.row].address
        cell.Vacant.text="\(roomList.getRooms()[indexPath.row].vacant)"
        cell.Rooms.text="\(roomList.getRooms()[indexPath.row].no_of_Rooms)"
        cell.AccomodationType.text=(roomList.getRooms()[indexPath.row].isTemporary) ? "Temporary" : "Permanent"
        cell.SpotType.text=roomList.getRooms()[indexPath.row].spot
        cell.Rating.text="\(roomList.getRooms()[indexPath.row].rating)"
        cell.Rent.text="\(String(describing: roomList.getRooms()[indexPath.row].Rent))/Day"
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               // Remove the item from the data source
               let documentID = roomList.getRooms()[indexPath.row].accomodationID
               let documentRef = self.db.collection("rooms").document(documentID)
               documentRef.delete() { error in
                   if let error = error {
                       print("Error deleting document: \(error)")
                       self.showAlert(message: "Could not delete post. Please try again later.")
                   } else {
                       print("Document deleted successfully")
                       // Show success message or navigate to a different view controller
                   }
               }
               getRooms()
               tableView.deleteRows(at: [indexPath], with: .fade)
           }
       }
    func showAlert(message: String, title:String = "Error") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    func getRooms() {
        roomList = RoomList()
        let collectionRef = db.collection("rooms")
        let query = collectionRef.whereField("userID", isEqualTo: user?.userID ?? "")
        query.getDocuments{(querySnapshot, error) in
            if let error = error {
                print("Error retrieving documents: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found.")
                return
            }
            
            for document in documents {
                let data = document.data()
                
                let accommodationID = document.documentID
                let address = data["address"] as? String ?? ""
                let no_of_Rooms = data["no_of_Rooms"] as? Int ?? 0
                let no_of_Bath = data["no_of_Bath"] as? Int ?? 0
                let preffered_Gender = data["preffered_Gender"] as? String ?? ""
                let Rent = data["Rent"] as? Float ?? 0.0
                let available = data["available"] as? Bool ?? true
                let startDate = (data["startDate"] as? Timestamp)?.dateValue() ?? Date()
                let endDate = (data["endDate"] as? Timestamp)?.dateValue() ?? Date()
                let vacant = data["vacant"] as? Int ?? 0
                let spot = data["spot"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let room_Image = data["room_Image"] as? String ?? ""
                let rating = data["rating"] as? Int ?? 0
                let isTemporary = data["type"] as? Bool ?? false
                
                let room = RoomDetails(accomodationID: accommodationID,
                                       userID: "",
                                       address: address,
                                       no_of_Rooms: no_of_Rooms,
                                       no_of_Bath: no_of_Bath,
                                       preffered_Gender: preffered_Gender,
                                       Rent: Rent,
                                       available: available,
                                       startDate: startDate,
                                       endDate: endDate,
                                       vacant: vacant,
                                       spot: spot,
                                       description: description,
                                       room_Image: room_Image,
                                       rating: rating,
                                       isTemporary: isTemporary)
                
                self.roomList.add(room: room)
            }
            /*
             // MARK: - Navigation
             
             // In a storyboard-based application, you will often want to do a little preparation before navigation
             override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             // Get the new view controller using segue.destination.
             // Pass the selected object to the new view controller.
             }
             */
            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "updatePost", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination =  segue.destination as? UpdateRoomViewController{
            destination.accommodation = roomList.getRooms()[tableView.indexPathForSelectedRow?.row ?? 0]
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRooms()
        tableView.reloadData()
    }
}
