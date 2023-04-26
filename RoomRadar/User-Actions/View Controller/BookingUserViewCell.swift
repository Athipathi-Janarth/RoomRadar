//
//  BookingUserViewCell.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/25/23.
//

import UIKit

class BookingUserViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var HostName: UILabel!
    @IBOutlet weak var BookingID: UILabel!
    @IBOutlet weak var RoomImage: UIImageView!
    @IBOutlet weak var address: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
