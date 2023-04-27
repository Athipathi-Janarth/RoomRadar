//
//  UserViewController.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/21/23.
//

import UIKit
import Firebase

class UserViewController: UIViewController {

    var user:User?
    @IBOutlet weak var WelcomeLabel: UILabel!
    @IBOutlet weak var isVeg: UISwitch!
    @IBOutlet weak var Spot: UITextField!
    @IBOutlet weak var Degree: UITextField!
    @IBOutlet weak var Ethinicity: UITextField!
    @IBOutlet weak var Gender: UITextField!
    @IBOutlet weak var Language: UITextField!
    @IBOutlet weak var isMixed: UISwitch!
    @IBAction func LogOut(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "userSession")
        self.performSegue(withIdentifier: "goToLogin1", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let decoder = JSONDecoder()
        if let savedData = UserDefaults.standard.object(forKey: "userSession") as? Data,
           let loadedSession = try? decoder.decode(User.self, from: savedData) {
            self.user=loadedSession
        }
        WelcomeLabel.text="Welcome " + (self.user?.name ?? "user");
        getUserDetails()
        // Do any additional setup after loading the view.
    }
    @IBAction func UpdateDetails(_ sender: Any) {
        guard let spot = Spot.text, !spot.isEmpty else {
            showAlert(message: "Please enter a spot")
            return
        }
        guard let degree = Degree.text, !degree.isEmpty else {
            showAlert(message: "Please enter a degree")
            return
        }
        guard let ethnicity = Ethinicity.text, !ethnicity.isEmpty else {
            showAlert(message: "Please enter an ethnicity")
            return
        }
        guard let gender = Gender.text, !gender.isEmpty else {
            showAlert(message: "Please enter a gender")
            return
        }
        guard let language = Language.text, !language.isEmpty else {
            showAlert(message: "Please enter a language")
            return
        }
        
        // All fields are valid, continue with saving data
        
        let isVegSelected = isVeg.isOn
        let isMixedSelected = isMixed.isOn
        
        let db = Firestore.firestore()
        let userRef = db.collection("userPreferences").document(self.user?.userID ?? "")
        let data: [String: Any] = [
            "Degree": degree,
            "Gender": gender,
            "IsVeg": isVegSelected,
            "KnownLanguage": language,
            "MixedGenderApt": isMixedSelected,
            "Nationality": ethnicity,
            "Spot": spot
        ]
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                userRef.updateData(data) { error in
                    if let error = error {
                        print("Error updating user details: \(error.localizedDescription)")
                        self.showAlert(message: "Failed to update user details")
                    } else {
                        print("User details updated successfully")
                        self.showAlert(title:"Success",message: "User details updated successfully")
                    }
                }
            } else {
                userRef.setData(data) { error in
                    if let error = error {
                        print("Error creating user document: \(error.localizedDescription)")
                        self.showAlert(message: "Failed to create user document")
                    } else {
                        print("User document created successfully")
                        self.showAlert(title:"Success", message: "User document created successfully")
                    }
                }
            }
        }
    }
    func getUserDetails(){
        let db = Firestore.firestore()
        let userRef = db.collection("userPreferences").document(self.user?.userID ?? "")
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Retrieve data and cast to appropriate types
                let degree = document.data()?["Degree"] as? String ?? ""
                let gender = document.data()?["Gender"] as? String ?? ""
                let isVegSelected = document.data()?["IsVeg"] as? Bool ?? false
                let language = document.data()?["KnownLanguage"] as? String ?? ""
                let isMixedSelected = document.data()?["MixedGenderApt"] as? Bool ?? false
                let ethnicity = document.data()?["Nationality"] as? String ?? ""
                let spot = document.data()?["Spot"] as? String ?? ""
                
                // Update UI with retrieved data
                DispatchQueue.main.async {
                    self.Degree.text = degree
                    self.Gender.text = gender
                    self.isVeg.isOn = isVegSelected
                    self.Language.text = language
                    self.isMixed.isOn = isMixedSelected
                    self.Ethinicity.text = ethnicity
                    self.Spot.text = spot
                }
            } else {
                print("User document does not exist")
            }
        }
    }

    func showAlert(title:String = "Error",message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
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
