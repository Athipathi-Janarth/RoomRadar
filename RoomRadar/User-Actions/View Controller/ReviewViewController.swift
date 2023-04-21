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
    
        var roomList = RoomList()
        var user:User?
        let storageRef = Storage.storage().reference()
        let db = Firestore.firestore()
        @IBOutlet weak var tableView: UITableView!
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
