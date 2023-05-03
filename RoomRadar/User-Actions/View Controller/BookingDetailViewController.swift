//
//  BookingDetailViewController.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/25/23.
//

import UIKit
import Firebase

class BookingDetailViewController: UIViewController {

    @IBOutlet weak var RoomImage: UIImageView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var Rooms: UILabel!
    @IBOutlet weak var SpotType: UILabel!
    @IBOutlet weak var Rating: UILabel!
    @IBOutlet weak var Rent: UILabel!
    @IBOutlet weak var AccomodationType: UILabel!
    @IBOutlet weak var HostName: UILabel!
    @IBOutlet weak var Status: UILabel!
    var booking:Booking?
    var room: RoomDetails?
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var BookingID: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        room=booking?.Room
        let imageUrl = URL(string: room?.room_Image ?? "")
        let placeholderImage = UIImage(named: "launch-screen")
        RoomImage.kf.setImage(with: imageUrl, placeholder: placeholderImage)
        address.text=room?.address
        Rooms.text="\(room?.no_of_Rooms ?? 0)"
        SpotType.text=room?.spot
        AccomodationType.text=((room?.isTemporary) != false) ? "Temporary" : "Permanent"
        Rating.text="\(room?.rating ?? 0)"
        Rent.text="$\(String(describing: room?.Rent ?? 0))"
        BookingID.text = booking?.BookingID
        HostName.text = booking?.Host.name
        Status.text = booking?.Status
        
        if(booking?.Status == "Cancelled"){
            self.CancelButton.isEnabled=false
        }
            
        // Do any additional setup after loading the view.
    }
    @IBAction func OnCancel(_ sender: Any) {
        let alertController = UIAlertController(title: "Do you Want to Cancel", message: "Do you Want to Cancel this Booking?", preferredStyle: .alert)

        // Create the actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            // Handle cancel action here
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            let db = Firestore.firestore()
            let bookingRef = db.collection("bookings").document(self.booking?.BookingID ?? "")

               bookingRef.updateData(["status": "Cancelled"]) { error in
                   if let error = error {
                       // An error occurred
                       print("Error updating booking status: \(error.localizedDescription)")
                   } else {
                       // Booking status updated successfully
                       print("Booking status updated to cancel")
                       self.Status.text = "Cancelled"
                       self.CancelButton.isEnabled=false
                   }
               }
        }

        // Add the actions to the alert controller
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)

        // Present the alert controller
        present(alertController, animated: true, completion: nil)
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
