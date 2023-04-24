//
//  UserRoomListViewController.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/20/23.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class UserRoomListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var roomList = RoomList()
    var user:User?
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 250.0
        let decoder = JSONDecoder()
        if let savedData = UserDefaults.standard.object(forKey: "userSession") as? Data,
           let loadedSession = try? decoder.decode(User.self, from: savedData) {
            self.user=loadedSession
        }
        getRooms()
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomList.getRooms().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostViewCell", for: indexPath) as! UserPostViewCell
        let imageUrl = URL(string: roomList.getRooms()[indexPath.row].room_Image)
        let placeholderImage = UIImage(named: "launch-screen")
        cell.RoomImage.kf.setImage(with: imageUrl, placeholder: placeholderImage)
        cell.address.text=roomList.getRooms()[indexPath.row].address
        cell.Vacant.text="\(roomList.getRooms()[indexPath.row].vacant)"
        cell.Rooms.text="\(roomList.getRooms()[indexPath.row].no_of_Rooms)"
        cell.SpotType.text=roomList.getRooms()[indexPath.row].spot
        cell.Rating.text="\(roomList.getRooms()[indexPath.row].rating)"
        cell.StartDates.text="Start: \(roomList.getRooms()[indexPath.row].startDate)"
        cell.EndDates.text="End: \(roomList.getRooms()[indexPath.row].endDate)"
        cell.Rent.text="$\(String(describing: roomList.getRooms()[indexPath.row].Rent))/Day"
        return cell
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
        let query = collectionRef.whereField("available", isEqualTo: true)
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
            self.tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRooms()
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination =  segue.destination as? ReviewViewController{
            destination.room = roomList.getRooms()[tableView.indexPathForSelectedRow?.row ?? 0]
        }
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
