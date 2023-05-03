//
//  ReviewViewCell.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/21/23.
//

import UIKit

class ReviewViewCell: UITableViewCell {

    @IBOutlet weak var Rating: UILabel!
    @IBOutlet weak var User: UILabel!
    @IBOutlet weak var Comment: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
