//
//  CommentViewController.swift
//  SecurityGalleryApp
//
//  Created by alexKoro on 6/27/21.
//

import UIKit

class CommentViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    let photoController = PhotoController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageView.image = photoController.images[photoController.currentIndex]
        createTapGesture(to: contentView)
        createNotificationObserver()
        createTextViewStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.frame.size.height = view.frame.height / 3
        textView.frame.size.height = imageView.frame.height
        okButton.frame.size.height = view.frame.height / 4
        textView.text = photoController.photos[photoController.currentIndex].comment
    }
    
    func createTapGesture(to view: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(tapGestrue:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func createTextViewStyle() {
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.cornerRadius = 5
    }
    
    func createNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandler(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandler(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func tapGestureHandler(tapGestrue: UITapGestureRecognizer) {
        guard textView.isFirstResponder else { return }

        textView.resignFirstResponder()
    }
    
    @objc func keyboardWillHideHandler(sender: Notification) {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @objc func keyboardWillShowHandler(sender: Notification) {
        let userInfo = sender.userInfo
        let frame = userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect
        guard let cgRect = frame else { return }
        scrollView.contentInset.bottom = cgRect.height
        print(cgRect.height)
    }
    
    
    @IBAction func okButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        photoController.photos[photoController.currentIndex].comment = textView.text
        photoController.savePhotos()
    }
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
