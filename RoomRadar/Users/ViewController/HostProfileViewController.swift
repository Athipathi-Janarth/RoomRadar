//
//  HostProfileViewController.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/14/23.
//

import UIKit

class HostProfileViewController: UIViewController {

    @IBAction func LogOut(_ sender: UIButton) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.user? = User(userID: "", name: "", userName: "", isHost:false)
        }
        self.performSegue(withIdentifier: "goToLogin", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
