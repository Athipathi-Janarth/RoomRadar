//
//  UserListViewController.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/28/23.
//

import UIKit
import Firebase
extension Notification.Name {
    static let filterDidChange = Notification.Name("filterDidChange")
}
class UserListViewController: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
    var user:User?
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var userList:[UserPreferences] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 75.0
        SearchBar.delegate = self
        let decoder = JSONDecoder()
        if let savedData = UserDefaults.standard.object(forKey: "userSession") as? Data,
           let loadedSession = try? decoder.decode(User.self, from: savedData) {
            self.user=loadedSession
        }
        NotificationCenter.default.addObserver(self, selector: #selector(filterDidChange), name: .filterDidChange, object: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(userList.count)
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserViewCell
        if userList[indexPath.row].username == user?.name {
            cell.UserName.text=userList[indexPath.row].username+" (Me)"
        }
        else{
            cell.UserName.text=userList[indexPath.row].username
        }
        return cell
    }
    func getUsers(){
        self.userList=[]
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")
        let userPreferencesCollection = db.collection("userPreferences")
        
        usersCollection.whereField("isHost", isEqualTo: false)
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print("Error getting users: \(error.localizedDescription)")
                } else {
                    for document in querySnapshot!.documents {
                        let userData = document.data()
                        let userID = userData["userID"] as! String
                        
                        // Retrieve user preferences
                        userPreferencesCollection.document(userID).getDocument() { (snapshot, error) in
                            if let error = error {
                                print("Error getting user preferences for user \(userID): \(error.localizedDescription)")
                            } else {
                                let userPreferencesData = snapshot!.data()
                                let degree = userPreferencesData?["Degree"] as! String 
                                let gender = userPreferencesData?["Gender"] as! String
                                let isVeg = userPreferencesData?["IsVeg"] as! Bool
                                let knownLanguage = userPreferencesData?["KnownLanguage"] as! String
                                let mixedGenderApt = userPreferencesData?["MixedGenderApt"] as! Bool
                                let nationality = userPreferencesData?["Nationality"] as! String
                                let spot = userPreferencesData?["Spot"] as! String
                                let username = userData["name"] as! String
                                
                                // Create UserPreferences object
                                let userPreferences = UserPreferences(degree: degree, gender: gender, isVeg: isVeg, knownLanguage: knownLanguage, mixedGenderApt: mixedGenderApt, nationality: nationality, spot: spot, username: username, userID: userID)
                                
                                self.userList.append(userPreferences)
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
    }
    @IBAction func showFilters(_ sender: UIButton) {
        guard let filterViewController = storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController else {
            return
        }
        let presentationController = UISheetPresentationController(presentedViewController: filterViewController, presenting: self)
        presentationController.detents = [.medium()]
        presentationController.prefersScrollingExpandsWhenScrolledToEdge = false
        presentationController.largestUndimmedDetentIdentifier = .medium
        
        // Present the filter view controller
        present(filterViewController, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(FilterManager.shared.degree==nil)
        {
            getUsers()
            
        }
        else{
            searchUsers()
        }
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination =  segue.destination as? UserDetailViewController{
            destination.userPreferences = userList[tableView.indexPathForSelectedRow?.row ?? 0]
        }
    }
    
    func searchUsers(){
        let filter = FilterManager.shared
        self.userList=[]
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")
        let userPreferencesCollection = db.collection("userPreferences")
        
        var query = userPreferencesCollection.whereField("IsVeg", isEqualTo: filter.isVeg ?? true)
        
        if let degree = filter.degree  {
            if degree != ""{
                query = query.whereField("Degree", isEqualTo: degree)
            }
            
        }
        if let gender = filter.gender {
            if gender != ""{
                query = query.whereField("Gender", isEqualTo: gender)
            }
        }
        if let knownLanguage = filter.knownLanguage {
            if knownLanguage != "" {
                query = query.whereField("KnownLanguage", isEqualTo: knownLanguage)
            }
        }
        if let mixedGenderApt = filter.mixedGenderApt {
            query = query.whereField("MixedGenderApt", isEqualTo: mixedGenderApt)
        }
        if let nationality = filter.nationality {
            if nationality != "" {
                query = query.whereField("Nationality", isEqualTo: nationality)
            }
        }
        if let spot = filter.spot {
            if spot != "" {
                query = query.whereField("Spot", isEqualTo: spot)
            }
        }
        
        query.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting users: \(error.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let degree = data["Degree"] as! String
                    let gender = data["Gender"] as! String
                    let isVeg = data["IsVeg"] as! Bool
                    let knownLanguage = data["KnownLanguage"] as! String
                    let mixedGenderApt = data["MixedGenderApt"] as! Bool
                    let nationality = data["Nationality"] as! String
                    let spot = data["Spot"] as! String
                    usersCollection.whereField("userID", isEqualTo: document.documentID)
                        .getDocuments() { (querySnapshot, error) in
                            if let error = error {
                                print("Error getting users: \(error.localizedDescription)")
                            } else {
                                for document in querySnapshot!.documents {
                                    let userData = document.data()
                                    let userID = userData["userID"] as! String
                                    let username = userData["name"] as! String
                                    let userPreferences = UserPreferences(degree: degree, gender: gender, isVeg: isVeg, knownLanguage: knownLanguage, mixedGenderApt: mixedGenderApt, nationality: nationality, spot: spot, username: username, userID: userID)
                                    self.userList.append(userPreferences)
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    // Access the user data here and do something with it
                }
            }
        }
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.userList = self.userList.filter { user in
                return user.username.contains(searchText)
            }
        self.tableView.reloadData()
    }
    @objc func filterDidChange() {
        if(FilterManager.shared.degree == nil) {
            getUsers()
        } else {
            searchUsers()
        }
        tableView.reloadData()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
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
