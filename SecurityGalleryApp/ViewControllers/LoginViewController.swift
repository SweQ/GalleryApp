//
//  LoginViewController.swift
//  SecurityGalleryApp
//
//  Created by alexKoro on 6/27/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        guard Password.shared.password != nil else {
        let passwordChangeVC = UIStoryboard.init(name: String(describing: ChangePasswordViewController.self), bundle: nil).instantiateViewController(withIdentifier: "ChangePasswordViewController")
            navigationController?.pushViewController(passwordChangeVC, animated: false)
            return
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createNotificationObservers()
        createTapGesture()
    }
    
    
    private func createTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(sender:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func createNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(enterSymbolHandler(sender:)), name: UITextField.textDidChangeNotification, object: self.textField)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShowHandler(sender:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    @objc func tapGestureHandler(sender: UITapGestureRecognizer) {
        scrollView.contentInset = UIEdgeInsets.zero
        textField.resignFirstResponder()
    }
    
    @objc func keyboardDidShowHandler(sender: Notification) {
        let userInfoFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        guard let frame = userInfoFrame else { return }
        scrollView.contentInset.bottom = frame.height
    }
    
    @objc func enterSymbolHandler(sender: Notification) {
        guard let password = Password.shared.password else { return }
        guard let enterPassword = textField.text else { return }
        if enterPassword == password {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController")
            textField.text = ""
            navigationController?.pushViewController(mainVC, animated: true)
        }
    }
}
