//
//  HostProfileViewController.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/14/23.
//

import UIKit

class HostProfileViewController: UIViewController {
    
    
    var user:User?
    @IBOutlet weak var WelcomeLabel: UILabel!
    @IBAction func LogOut(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "userSession")
        self.performSegue(withIdentifier: "goToLogin", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let decoder = JSONDecoder()
        if let savedData = UserDefaults.standard.object(forKey: "userSession") as? Data,
           let loadedSession = try? decoder.decode(User.self, from: savedData) {
            self.user=loadedSession
        }
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
