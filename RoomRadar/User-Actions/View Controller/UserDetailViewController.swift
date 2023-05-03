//
//  UserDetailViewController.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/28/23.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    var userPreferences:UserPreferences?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        WelcomeLabel.text=userPreferences?.username
        Degree.text=userPreferences?.degree
        Spot.text=userPreferences?.spot
        Ethinicity.text=userPreferences?.nationality
        Language.text=userPreferences?.knownLanguage
        Gender.text=userPreferences?.gender
        IsVeg.isOn=((userPreferences?.isVeg) ?? false)
        IsMixed.isOn=((userPreferences?.mixedGenderApt) ?? false)
    }
    @IBOutlet weak var WelcomeLabel: UILabel!
    
    @IBOutlet weak var Degree: UILabel!
    
    @IBOutlet weak var Spot: UILabel!
    @IBOutlet weak var Ethinicity: UILabel!
    @IBOutlet weak var IsMixed: UISwitch!
    @IBOutlet weak var Language: UILabel!
    @IBOutlet weak var IsVeg: UISwitch!
    @IBOutlet weak var Gender: UILabel!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
