//
//  UpdateRoomViewController.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/16/23.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class UpdateRoomViewController: UIViewController,UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var user:User?
    var accommodation:RoomDetails?
    var isTemp=false
    var isAvail=false
    let imagePicker = UIImagePickerController()
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        let decoder = JSONDecoder()
        if let savedData = UserDefaults.standard.object(forKey: "userSession") as? Data,
           let loadedSession = try? decoder.decode(User.self, from: savedData) {
            self.user=loadedSession
        }
        if let accommodation = self.accommodation {
            self.Address.text = accommodation.address
            self.SpotType.text = accommodation.spot
            self.Gender.text = accommodation.preffered_Gender
            self.Rooms.text = "\(accommodation.no_of_Rooms)"
            self.Baths.text = "\(accommodation.no_of_Bath)"
            self.Vacancy.text = "\(accommodation.vacant)"
            self.Rent.text = "\(accommodation.Rent)"
            self.Rating.text = "\(accommodation.rating)"
            self.isAvailable.isOn = accommodation.available
            self.isTemporary.isOn = accommodation.isTemporary
            self.startDate.date = accommodation.startDate
            self.endDate.date = accommodation.endDate
            
            // Load image using Kingfisher if imageURLString is not empty
            if !accommodation.room_Image.isEmpty {
                if let imageURL = URL(string: accommodation.room_Image) {
                    self.RoomImage.kf.setImage(with: imageURL)
                }
            }
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
    @IBAction func updateImage(_ sender: Any) {
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
    
    @IBAction func UpdatePost(_ sender: UIButton) {
        guard let address = Address.text, !address.isEmpty,
              let spot = SpotType.text, !spot.isEmpty,
              let gender = Gender.text, !gender.isEmpty,
              let noOfRoomsString = Rooms.text, !noOfRoomsString.isEmpty, let noOfRooms = Int(noOfRoomsString),
              let noOfBathsString = Baths.text, !noOfBathsString.isEmpty, let noOfBaths = Int(noOfBathsString),
              let vacancyString = Vacancy.text, !vacancyString.isEmpty, let vacancy = Int(vacancyString),
              let rentString = Rent.text, !rentString.isEmpty, let rent = Float(rentString),
              let ratingString = Rating.text, !ratingString.isEmpty, let rating = Int(ratingString),
              let roomImage = RoomImage.image
        else {
            showAlert(message: "Please fill out all required fields")
            return
        }
        guard let imageData = roomImage.jpegData(compressionQuality: 1.0) else {
            showAlert(message: "Failed to convert room image")
            return
        }
        let imageName = "\(UUID().uuidString).jpg"
        let imageRef = storageRef.child("images/\(imageName)")
        
        // Upload the image to Firebase Storage
        _ = imageRef.putData(imageData, metadata: nil) { (metadata, error) in
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
                    if self.isTemporary.isOn{
                        self.isTemp=true
                    }
                }
                if let isAvailable = self.isAvailable{
                    if self.isAvailable.isOn{
                        self.isAvail=true
                    }
                }
                let data: [String: Any] = [
                    "Rent": rent,
                    "address": address,
                    "available": self.isAvail,
                    "description": "",
                    "endDate": self.endDate.date,
                    "no_of_Bath": noOfBaths,
                    "no_of_Rooms": noOfRooms,
                    "preffered_Gender": gender,
                    "rating": rating,
                    "room_Image": imageURLString,
                    "spot": spot,
                    "startDate": self.startDate.date,
                    "type": self.isTemp,
                    "userID": self.user?.userID ?? "",
                    "vacant": vacancy
                ]
                if let accommodationID = self.accommodation?.accomodationID {
                    self.db.collection("rooms").document(accommodationID).updateData(data) { error in
                        if let error = error {
                            print("Error updating document: \(error)")
                            self.showAlert(message: "Could not update post. Please try again later.")
                        } else {
                            print("Document updated successfully")
                            self.clearFields()
                            self.navigationController?.popViewController(animated: true)
                        }
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
