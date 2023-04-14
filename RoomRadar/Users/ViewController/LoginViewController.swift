//
//  LoginViewController.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/13/23.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func Login(_ sender: UIButton) {
        var host : Bool
        var notHost :Bool
        var flag = true
        guard let userNameText = userName.text, !userNameText.isEmpty else {
            showAlert(message: "User name is a mandatory field")
            return
        }
        
        guard let passwordText = password.text, !passwordText.isEmpty else {
            showAlert(message: "Password is a mandatory field")
            return
        }
        host=false
        notHost=false
        Auth.auth().signIn(withEmail: userNameText, password: passwordText){
            authResult, error in
            if let error = error {
                self.showAlert(message:  error.localizedDescription)
                flag = false
                return
            }
            
            guard let authResult = authResult else {
                self.showAlert(message: "Unknown error while log in user")
                flag = false
                return
            }
            let userID = authResult.user.uid
            print(userID)
            let db = Firestore.firestore()
            let usersRef = db.collection("users")
            let query = usersRef.whereField("userID", isEqualTo: userID)

            query.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting user document: \(error)")
                } else {
                    guard let documents = querySnapshot?.documents else {
                        print("No matching documents.")
                        return
                    }
                    // Assuming that there's only one document with the given userID
                    let userDocument = documents[0]
                    let userData = userDocument.data()
                    // Retrieve the name and isHost fields from the user document
                    let name = userData["name"] as? String
                    let isHost = userData["isHost"] as? Bool
                    host=isHost ?? false
                    if(host){
                                self.performSegue(withIdentifier: "goToHost1", sender: self)
                            } else {
                                self.performSegue(withIdentifier: "goToHome", sender: self)
                            }
                }
            }
            self.clearFields()
        }
    }
    func clearFields(){
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
