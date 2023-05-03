//
//  UserPostViewCell.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/20/23.
//

import UIKit

class UserPostViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var EndDates: UILabel!
    @IBOutlet weak var StartDates: UILabel!
    @IBOutlet weak var RoomImage: UIImageView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var Vacant: UILabel!
    @IBOutlet weak var Rooms: UILabel!
    @IBOutlet weak var SpotType: UILabel!
    @IBOutlet weak var Rating: UILabel!
    @IBOutlet weak var Rent: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
