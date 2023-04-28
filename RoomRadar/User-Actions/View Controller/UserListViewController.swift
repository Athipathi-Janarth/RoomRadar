//
//  UserListViewController.swift
//  RoomRadar
//
//  Created by AthiPathi on 4/28/23.
//

import UIKit

class UserListViewController: UIViewController, UIViewControllerTransitioningDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
