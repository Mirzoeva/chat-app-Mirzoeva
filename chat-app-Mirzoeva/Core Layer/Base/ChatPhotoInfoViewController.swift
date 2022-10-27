//
//  ChatPhotoInfoViewController.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 09.10.2022.
//

import UIKit

class ChatPhotoInfoViewController: UIViewController {

    let photoView = ChatProfileImageView(frame: .zero)
    let editButton = ChatUpdatePhotoButton(frame: .zero)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        [photoView, editButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        if #available(iOS 14.0, *) {
            editButton.menu = addActionsMenu()
            editButton.showsMenuAsPrimaryAction = true
        } else {
            editButton.addTarget(self, action: #selector(showPickingOptions), for: .touchUpInside)
        }
        setupLayoutUserInfoConstraints()
    }

    func setupLayoutUserInfoConstraints() {
        NSLayoutConstraint.activate(
            [
                photoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                photoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                editButton.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: -10),
                editButton.trailingAnchor.constraint(equalTo: photoView.trailingAnchor)
            ]
        )
    }
    
    @objc private func showPickingOptions() {
//        didTappedEditInfoButton()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photoAction = UIAlertAction(title: L10n.Photo.takePhoto, style: .default, handler: { [weak self] _ in
            self?.openSystemCamera()
        })
        let galleryAction = UIAlertAction(title: L10n.Photo.openGallery, style: .default, handler: { [weak self] _ in
            self?.openGallery()
        })
        let deleteAction = UIAlertAction(title: L10n.Photo.deletePhoto, style: .default, handler: { [weak self] _ in
            self?.deletePhoto()
        })
        let cancel = UIAlertAction(title: L10n.cancel, style: .cancel, handler: nil)
        [photoAction, galleryAction, deleteAction, cancel].forEach {
            alert.addAction($0)
        }
        present(alert, animated: true)
    }
    
    private func addActionsMenu() -> UIMenu {
        let photoAction = UIAction(
            title: L10n.Photo.takePhoto,
            image: UIImage(systemSymbol: .camera)
        ) { [weak self] _ in
            self?.openSystemCamera()
        }
        
        let galleryAction = UIAction(
            title: L10n.Photo.openGallery,
            image: UIImage(systemSymbol: .photoOnRectangle)
        ) { [weak self] _ in
            self?.openGallery()
        }
        
        let deleteAction = UIAction(
            title: L10n.Photo.deletePhoto,
            image: UIImage(systemSymbol: .photoOnRectangle)
        ) { [weak self] _ in
            self?.deletePhoto()
        }
        
        let menuActions = [photoAction, galleryAction, deleteAction]
        let addNewMenu = UIMenu(children: menuActions)
        return addNewMenu
    }
    
    private func openSystemCamera() {
//        didTappedEditInfoButton()
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .camera
        present(pickerController, animated: true)
    }
    
    private func openGallery() {
//        didTappedEditInfoButton()
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.modalPresentationStyle = .fullScreen
        present(pickerController, animated: true)
    }
    
    private func deletePhoto() {
//        didTappedEditInfoButton()
        let alert = UIAlertController(
            title: L10n.warning,
            message: nil,
            preferredStyle: .alert
        )
        let delete = UIAlertAction(title: L10n.Photo.deletePhoto, style: .destructive) { [weak self] _ in
            self?.photoView.image = self?.photoView.placeholderImage
    }
        let cancel = UIAlertAction(title: L10n.cancel, style: .cancel)
        
        alert.addAction(delete)
        alert.addAction(cancel)

        present(alert, animated: true)
    }
}

extension ChatPhotoInfoViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage
        
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        photoView.image = newImage
        dismiss(animated: true)
    }
}
