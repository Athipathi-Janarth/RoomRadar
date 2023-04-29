//
//  FilterViewController.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/28/23.
//

import UIKit


class FilterViewController: UIViewController {

    var filter:Filter?
    @IBOutlet weak var Ethinicty: UITextField!
    @IBOutlet weak var Spot: UITextField!
    @IBOutlet weak var Language: UITextField!
    @IBOutlet weak var Degree: UITextField!
    @IBOutlet weak var Gender: UITextField!
    @IBOutlet weak var IsMixed: UISwitch!
    @IBOutlet weak var IsVeg: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let presentationController = presentationController as? UISheetPresentationController {
                presentationController.detents = [
                    .medium()
                ]
            }
        if(FilterManager.shared.degree != nil) {
            Ethinicty.text = FilterManager.shared.nationality
            Spot.text = FilterManager.shared.spot
            Language.text = FilterManager.shared.knownLanguage
            Degree.text = FilterManager.shared.degree
            Gender.text = FilterManager.shared.gender
            IsMixed.isOn = FilterManager.shared.mixedGenderApt ?? true
            IsVeg.isOn = FilterManager.shared.isVeg ?? true
        }
    }
    @IBAction func ApplyFilter(_ sender: UIButton) {
        FilterManager.shared.degree = Degree.text
        FilterManager.shared.gender = Gender.text
        FilterManager.shared.isVeg = IsVeg.isOn
        FilterManager.shared.knownLanguage = Language.text
        FilterManager.shared.mixedGenderApt = IsMixed.isOn
        FilterManager.shared.nationality = Ethinicty.text
        FilterManager.shared.spot = Spot.text

        // Dismiss the filter view controller
        // Post the notification when the filter changes
        NotificationCenter.default.post(name: Notification.Name("filterDidChange"), object: nil)
        dismiss(animated: true, completion: nil)
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
