//
//  RequestListViewController.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/18/23.
//

import UIKit
import Firebase
import FirebaseStorage

class RequestListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var roomList = RoomList()
    var bookingList = BookingList()
    var user:User?
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let decoder = JSONDecoder()
        if let savedData = UserDefaults.standard.object(forKey: "userSession") as? Data,
           let loadedSession = try? decoder.decode(User.self, from: savedData) {
            self.user=loadedSession
        }
        //getBookings(forUserID: user?.userID ?? "")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 200.0

      
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.bookingList.getBookings().count)
        return self.bookingList.getBookings().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingViewCell", for: indexPath) as! BookingViewCell
        let imageUrl = URL(string: bookingList.getBookings()[indexPath.row].Room.room_Image)
        let placeholderImage = UIImage(named: "launch-screen")
          cell.RoomImage.kf.setImage(with: imageUrl, placeholder: placeholderImage)
        cell.address.text=bookingList.getBookings()[indexPath.row].Room.address
          cell.BookingID.text = bookingList.getBookings()[indexPath.row].BookingID
        cell.UserName.text = bookingList.getBookings()[indexPath.row].Host.name
        cell.Status.text = bookingList.getBookings()[indexPath.row].Status
        return cell
    }
    func showAlert(message: String, title:String = "Error") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    func getBookings(forUserID userID: String){
        bookingList = BookingList()
        let db = Firestore.firestore()
        let bookingsRef = db.collection("bookings")
        
        // Construct a query that retrieves all bookings for the given userID
        let query = bookingsRef.whereField("HostID", isEqualTo: userID)
        
        // Execute the query
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                // An error occurred
                return
            }
            
            
            // Parse the query snapshot into an array of Booking objects
            for document in querySnapshot!.documents {
                let bookingID=document.documentID
                let data = document.data()
                let usersRef = db.collection("users")
                let hostid = data["UserID"] as? String ?? ""
                let hostquery = usersRef.whereField("userID", isEqualTo: hostid)
                var host:User?
                var hostname: String = ""
                hostquery.getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting user document: \(error)")
                    } else {
                        guard let hostdocuments = querySnapshot?.documents else {
                            print("No matching documents.")
                            return
                        }
                        // Assuming that there's only one document with the given userID
                        let userDocument = hostdocuments[0]
                        let userData = userDocument.data()
                        // Retrieve the name and isHost fields from the user document
                        hostname = userData["name"] as? String ?? ""
                        print(hostname)
                        host?.name = userData["name"] as? String ?? ""
                        host?.isHost = userData["isHost"] as? Bool ?? true
                        let collectionRef = db.collection("rooms").document(data["AccomodationID"] as? String ?? "")
                        
                        collectionRef.getDocument { (document, error) in
                            if let roomdocument = document, ((document?.exists) != nil) {
                                // Document exists, extract data
                                let roomdata = roomdocument.data()
                                
                                let accommodationID = roomdocument.documentID
                                let address =  roomdata?["address"] as? String ?? ""
                                let no_of_Rooms = roomdata?["no_of_Rooms"] as? Int ?? 0
                                let no_of_Bath = roomdata?["no_of_Bath"] as? Int ?? 0
                                let preffered_Gender = roomdata?["preffered_Gender"] as? String ?? ""
                                let Rent = roomdata?["Rent"] as? Float ?? 0.0
                                let available = roomdata?["available"] as? Bool ?? true
                                let startDate = (roomdata?["startDate"] as? Timestamp)?.dateValue() ?? Date()
                                let endDate = (roomdata?["endDate"] as? Timestamp)?.dateValue() ?? Date()
                                let vacant = roomdata?["vacant"] as? Int ?? 0
                                let spot = roomdata?["spot"] as? String ?? ""
                                let description = roomdata?["description"] as? String ?? ""
                                let room_Image = roomdata?["room_Image"] as? String ?? ""
                                let rating = roomdata?["rating"] as? Int ?? 0
                                let isTemporary = roomdata?["type"] as? Bool ?? false
                                
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
                                print(bookingID)
                                let booking = Booking(
                                    BookingID:bookingID,
                                    AccomodationID: data["AccomodationID"] as? String ?? "",
                                    HostID: data["HostID"] as? String ?? "",
                                    UserID: data["UserID"] as? String ?? "",
                                    Status: data["status"] as? String ?? "",
                                    Room:room,
                                    Host: host ?? User.init(userID: "", name: hostname, userName: "", isHost: false)
                                )
                                self.bookingList.add(booking: booking)
                                print(self.bookingList.getBookings().count)
                                self.tableView.reloadData()
                            }
                        }
                    }
                    
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBookings(forUserID: user?.userID ?? "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination =  segue.destination as? RequestDetailViewController{
            destination.booking = bookingList.getBookings()[tableView.indexPathForSelectedRow?.row ?? 0]
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
