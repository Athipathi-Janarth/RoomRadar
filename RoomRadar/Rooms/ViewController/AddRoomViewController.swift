//
//  AddRoomViewController.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/15/23.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddRoomViewController: UIViewController,UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var user:User?
    var accommodation:RoomDetails?
    var isTemp=false
    var isAvail=false
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        let decoder = JSONDecoder()
        if let savedData = UserDefaults.standard.object(forKey: "userSession") as? Data,
           let loadedSession = try? decoder.decode(User.self, from: savedData) {
            self.user=loadedSession
        }
    }
    @IBOutlet weak var Address: UITextField!
    @IBOutlet weak var SpotType: UITextField!
    @IBOutlet weak var Gender: UITextField!
    @IBOutlet weak var Rooms: UITextField!
    @IBOutlet weak var Baths: UITextField!
    @IBOutlet weak var Vacancy: UITextField!
    @IBOutlet weak var Rent: UITextField!
    @IBOutlet weak var Rating: UITextField!
    @IBOutlet weak var isAvailable: UISwitch!
    @IBOutlet weak var isTemporary: UISwitch!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var RoomImage: UIImageView!
    @IBAction func addImage(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided with the following: \(info)")
        }
        
        // Use the selected image
        RoomImage.image = selectedImage
        
        // Dismiss the image picker
        dismiss(animated: true, completion: nil)
    }
    func showAlert(message: String, title:String = "Error") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    @IBAction func CreatePost(_ sender: UIButton) {
        guard let address = Address.text, !address.isEmpty,
                  let spotType = SpotType.text, !spotType.isEmpty,
                  let gender = Gender.text, !gender.isEmpty,
                  let roomsText = Rooms.text, !roomsText.isEmpty,
                  let bathsText = Baths.text, !bathsText.isEmpty,
                  let vacancyText = Vacancy.text, !vacancyText.isEmpty,
                  let rentText = Rent.text, !rentText.isEmpty,
                  let ratingText = Rating.text, !ratingText.isEmpty,
                  let roomImage = RoomImage.image else {
                showAlert(message: "All fields are required")
                return
            }
            
            // Convert the values of Rooms, Baths, Vacancy, and Rating to integers
            guard let rooms = Int(roomsText),
                  let baths = Int(bathsText),
                  let vacancy = Int(vacancyText),
                  let rating = Int(ratingText) else {
                showAlert(message: "Invalid numeric value")
                return
            }
            
            // Convert the value of Rent to a float
            guard let rent = Float(rentText) else {
                showAlert(message: "Invalid rent value")
                return
            }
            
            // Convert the startDate and endDate values to Date objects
            let startDate = self.startDate.date
            let endDate = self.endDate.date
            
           let imageName = "\(UUID().uuidString).jpg"
            // Convert the RoomImage value to a Data object
            guard let imageData = roomImage.jpegData(compressionQuality: 1.0) else {
                showAlert(message: "Failed to convert room image")
                return
            }
        let imageRef = storageRef.child("images/\(imageName)")

        // Upload the image to Firebase Storage
        let uploadTask = imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Failed to upload image: \(error.localizedDescription)")
                return
            }

            // Get the download URL of the uploaded image
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Failed to get download URL: \(error.localizedDescription)")
                    return
                }

                guard let downloadURL = url else {
                    print("Failed to get download URL.")
                    return
                }

                let imageURLString = downloadURL.absoluteString
                if let isTemporary = self.isTemporary{
                    if isTemporary.isOn{
                        self.isTemp=true
                    }
                }
                if let isAvailable = self.isAvailable{
                    if isAvailable.isOn{
                        self.isAvail=true
                    }
                }
                self.accommodation = RoomDetails(userID: self.user?.userID ?? "" ,
                                                      address: address,
                                                      no_of_Rooms: rooms,
                                                      no_of_Bath: baths,
                                                      preffered_Gender: gender,
                                                      Rent: rent,
                                                      available: self.isAvail,
                                                      startDate: startDate,
                                                      endDate: endDate,
                                                      vacant: vacancy,
                                                      spot: spotType,
                                                      description: nil,
                                                      room_Image: imageURLString,
                                                      rating: rating,
                                                      isTemporary: self.isTemp)
                let roomsCollection = self.db.collection("rooms")
                let data: [String: Any] = [
                    "Rent": rent,
                    "address": address,
                    "available": self.isAvail,
                    "description": "",
                    "endDate": endDate,
                    "no_of_Bath": baths,
                    "no_of_Rooms": rooms,
                    "preffered_Gender": gender,
                    "rating": rating,
                    "room_Image": imageURLString,
                    "spot": spotType,
                    "startDate": startDate,
                    "type": self.isTemp,
                    "userID": self.user?.userID ?? "",
                    "vacant": vacancy
                ]
                roomsCollection.addDocument(data: data) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document added successfully!")
                        self.clearFields()
                        self.navigationController?.popViewController(animated: true)
                    }
                }

            }
        }
    }
    func clearFields() {
        Address.text = ""
        SpotType.text = ""
        Gender.text = ""
        Rooms.text = ""
        Baths.text = ""
        Vacancy.text = ""
        Rent.text = ""
        Rating.text = ""
        startDate.setDate(Date(), animated: false)
        endDate.setDate(Date(), animated: false)
        RoomImage.image = nil
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
