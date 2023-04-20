//
//  HostProfileViewController.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/14/23.
//

import UIKit

class HostProfileViewController: UIViewController {
    
    
    var user:User?
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    @IBOutlet weak var WelcomeLabel: UILabel!
    @IBAction func LogOut(_ sender: UIButton) {
        self.appDelegate?.user? = User(userID: "", name: "", userName: "", isHost:false)
        self.performSegue(withIdentifier: "goToLogin", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = self.appDelegate?.user
        WelcomeLabel.text="Welcome " + (self.user?.name ?? "user");
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
