//
//  ViewController.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/13/23.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var hostSwitch: UISwitch!
    @IBAction func CreateUser(_ sender: UIButton) {
        var isHost = false
        var flag = true
        guard let fullNameText = fullName.text, !fullNameText.isEmpty else {
            showAlert(message: "Full name is a mandatory field")
            return
        }

        guard let userNameText = userName.text, !userNameText.isEmpty else {
            showAlert(message: "User name is a mandatory field")
            return
        }

        guard let passwordText = password.text, !passwordText.isEmpty else {
            showAlert(message: "Password is a mandatory field")
            return
        }
        Auth.auth().createUser(withEmail: userNameText, password: passwordText){ authResult, error in
            if let error = error {
                self.showAlert(message:  error.localizedDescription)
                flag = false
                return
            }
            
            guard let authResult = authResult else {
                self.showAlert(message: "Unknown error creating user")
                flag = false
                return
            }
            if self.hostSwitch.isOn{
                isHost=true
                print(isHost)
            }
            let userID = authResult.user.uid
            let db=Firestore.firestore()
            let usersRef = db.collection("users").addDocument(data: ["userID" : userID,"name":fullNameText,"isHost":isHost])
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.user?.name = fullNameText
                appDelegate.user?.userID = userID
                appDelegate.user?.userName = userNameText
            }
            self.clearFields()
            if(isHost){
                self.performSegue(withIdentifier: "goToHost", sender: self)
            }
            else{
                self.performSegue(withIdentifier: "goToHome1", sender: self)
            }
        }
        
        
    }
    func clearFields(){
        fullName.text=""
        userName.text=""
        password.text=""
    }
    func showAlert(message: String, title:String = "Error") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hostSwitch.isOn=false
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
