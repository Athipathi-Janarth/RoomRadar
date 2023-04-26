//
//  BookingDetailViewController.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/25/23.
//

import UIKit

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
            
        // Do any additional setup after loading the view.
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
