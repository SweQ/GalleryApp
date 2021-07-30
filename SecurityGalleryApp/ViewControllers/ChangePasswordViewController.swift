//
//  ChangePasswordViewController.swift
//  SecurityGalleryApp
//
//  Created by alexKoro on 6/27/21.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var newPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShowNotificationHandler(sender:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
    }
    
    @objc func keyboardDidShowNotificationHandler(sender: Notification) {
        let frame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        guard let keyboardHight = frame?.height else {
            return
        }
        
        scrollView.contentInset.bottom = keyboardHight
    }
    
    @IBAction func okButtonTapped(_ sender: UIButton) {
        guard let newPassword = newPasswordField.text else { return }
        Password.shared.password = newPassword
        Password.shared.refresh()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let mainVC = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: String(describing: MainViewController.self)))
        navigationController?.popToRootViewController(animated: false)
    }
    

}
