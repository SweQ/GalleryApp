//
//  ViewController.swift
//  SecurityGalleryApp
//
//  Created by alexKoro on 6/22/21.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var topActionView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomActionViewConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var topActionViewConstraintTop: NSLayoutConstraint!
    
    var images: [UIImage] = []
    var isVisibleActionsViews = false
    
    var cellSize: CGSize {
        var minimumLineSpacing: CGFloat = 0
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            minimumLineSpacing = flowLayout.minimumLineSpacing
        }
        let width = (collectionView.frame.width - minimumLineSpacing) / 2
        return CGSize(width: width, height: width)
    }
    
    var currentImg = 0 {
        didSet {
           // imageView.image = photoController.images[currentImg]
            
        } willSet {
            photoController.currentIndex = newValue
        }
    }
    
    var selectedIndexPath: IndexPath? = nil
    var preCurrentImage: Int = 0 //предыдущий индекс
    
    let photoController = PhotoController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoController.loadPhotos()
        images = photoController.images
        self.navigationController?.isNavigationBarHidden = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if images.count == 0 {
            showActionsView(is: true)
        } else {
            showActionsView(is: false)
        }
            
    }
    
    private func showActionsView(is show: Bool) {
        isVisibleActionsViews = show
        
        if show {
            bottomActionViewConstraintBottom.constant = 0
            topActionViewConstraintTop.constant = 0
        } else {
            bottomActionViewConstraintBottom.constant = -actionView.frame.height
            topActionViewConstraintTop.constant = -topActionView.frame.height
        }
    }
    
    private func showPhotoPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        showPhotoPicker()
    }
    
    @IBAction func changePasswordButtonTapped(_ sender: UIButton) {
        let changePasswordStoryboard = UIStoryboard.init(name: String(describing: ChangePasswordViewController.self), bundle: nil)
        let changePasswordVC = changePasswordStoryboard.instantiateViewController(withIdentifier: String(describing: ChangePasswordViewController.self))
        navigationController?.pushViewController(changePasswordVC, animated: false)
    }
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        currentImg = 0
        preCurrentImage = 0
        selectedIndexPath = nil
        images = []
        collectionView.reloadData()
        
        
        FileManagerController.shared.clearDirectory(.photo)
        UserDefaultsController.shared.clearPhotos(.photo)
        photoController.photos = []
        photoController.images = []
        
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        guard images.count > 0 else { return }
        
        photoController.photos[currentImg].isLike = !photoController.photos[currentImg].isLike
        photoController.savePhotos()
        let imgLike = photoController.photos[currentImg].isLike ? UIImage(systemName: "heart.fill")! : UIImage(systemName: "heart")!
            likeButton.setImage(imgLike, for: .normal)
    }
    
    @IBAction func commentButtonTapped(_ sender: UIButton) {
        guard images.count > 0 else { return }
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CommentViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        selectedIndexPath = nil
        showActionsView(is: false)
        collectionView.reloadData()
        setScrollDirection(scrollDirection: .vertical)
    }
    
    
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: false, completion: nil)
        
        let img = info[.originalImage] as? UIImage ?? UIImage()
        
        let photo = Photo(name: "\(Date().timeIntervalSince1970).png", isLike: false, comment: "", image: img, orientation: img.imageOrientation.rawValue)
        
        photoController.photos.append(photo)
        photoController.images.append(img)
        images = photoController.images
        
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        currentImg = photoController.photos.count - 1
        
        UserDefaultsController.shared.saveClass(object: photoController.photos, key: .photo)
        
        collectionView.reloadData()
    }
}


extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(images.count)
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.image.image = images[indexPath.item]
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if selectedIndexPath == nil {
            return cellSize
        } else {
            return collectionView.frame.size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if selectedIndexPath == nil {
            return 5
        } else {
            return 0
        }
        
    }
}

extension MainViewController: UICollectionViewDelegate {
    
    func setScrollDirection(scrollDirection: UICollectionView.ScrollDirection ) {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = scrollDirection
        }
        
        if scrollDirection == .horizontal {
            collectionView.isPagingEnabled = true
        } else {
            collectionView.isPagingEnabled = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndexPath == nil {
            selectedIndexPath = indexPath
            collectionView.reloadData()
            setScrollDirection(scrollDirection: .horizontal)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        } else {
            showActionsView(is: !isVisibleActionsViews)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard selectedIndexPath != nil else { return }
        preCurrentImage = currentImg
        currentImg = indexPath.item
        
        
        let imgLike = photoController.photos[currentImg].isLike ? UIImage(systemName: "heart.fill")! : UIImage(systemName: "heart")!
        likeButton.setImage(imgLike, for: .normal)
        print("Will \(indexPath)")
    }
    //!!!!DidEndDecelerating попробуй вместо этой функции
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //Обрабатываем баг, когда коллекция была перелистана неполностью и данные полуоткрытой картинки подтянулись на открытую картинку
        if currentImg == indexPath.item {
            currentImg = preCurrentImage
            let imgLike = photoController.photos[currentImg].isLike ? UIImage(systemName: "heart.fill")! : UIImage(systemName: "heart")!
            likeButton.setImage(imgLike, for: .normal)
            
        }
    }
    
    
    
}
