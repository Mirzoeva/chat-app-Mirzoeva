//
//  ProfileViewController.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 03.03.2022.
//


import UIKit
import Combine
import Foundation
import SFSafeSymbols
import SwiftUI

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties

    private var profileImageView = UIImageView()
    private var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    private var closeButton = UIBarButtonItem()

    private let usernameTextField = UITextField()
    private let userInfoTextField = UITextField()
    private let editInfoButton = UIButton()
    private let editUserPhotoButton = UIButton()
    private let cancelEditInfoButton = UIButton()
    private let saveGCDButton = UIButton()
    private let gcdFileManager: SettingsFileManagerProtocol

    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    private lazy var longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(startTinkoffAnimation))
    
    private lazy var tinkoffCell: CAEmitterCell = {
        var tinkoffCell = CAEmitterCell()
        tinkoffCell.contents = UIImage(named: "tinkoff_logo")?.cgImage
        tinkoffCell.scale = 0.01
        tinkoffCell.scaleRange = 0.01
        tinkoffCell.emissionRange = .pi
        tinkoffCell.lifetime = 20.0
        tinkoffCell.birthRate = 20
        tinkoffCell.velocity = -30
        tinkoffCell.yAcceleration = 30
        tinkoffCell.xAcceleration = 5
        tinkoffCell.spin = -0.5
        tinkoffCell.spinRange = 1.0
        return tinkoffCell
    }()
    
    private lazy var emittedLayer: CAEmitterLayer = {
        var tinkoffLayer = CAEmitterLayer()
        tinkoffLayer.emitterSize = CGSize(width: view.bounds.width / 10, height: 0)
        tinkoffLayer.emitterShape = CAEmitterLayerEmitterShape.line
        tinkoffLayer.beginTime = CACurrentMediaTime()
        tinkoffLayer.timeOffset = CFTimeInterval(arc4random_uniform(6) + 5)
        tinkoffLayer.emitterCells = [tinkoffCell]
        return tinkoffLayer
    }()

    
    // MARK: - Lifecycle

    init(gcdFileManager: SettingsFileManagerProtocol) {
        self.gcdFileManager = gcdFileManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(longTapGesture)
        setupNavigationBar()
        setupUserInfo()
        setupEditInfoButton()
        setupEditingButtons()
        setupActivityIndicator()
        readUserInfoData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let apper = UINavigationBarAppearance()
        apper.backgroundColor = ThemeManager.currentTheme.backgroundColor
        self.view.backgroundColor = ThemeManager.currentTheme.backgroundColor
        closeButton.tintColor = ThemeManager.currentTheme.secondaryColor
        editUserPhotoButton.setTitleColor(ThemeManager.currentTheme.secondaryColor, for: .normal)
        
        [editInfoButton, cancelEditInfoButton, saveGCDButton].forEach {
            $0.backgroundColor = ThemeManager.currentTheme.buttonColor
            $0.setTitleColor(ThemeManager.currentTheme.secondaryColor, for: .normal)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.masksToBounds = true
    }
    
    // MARK: - Private
    
    @objc private func closeProfileVC() {
        dismiss(animated: true)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func readUserInfoData() {
        gcdFileManager.readData { [weak self] user in
            guard let self = self else { return }
            self.usernameTextField.text = user.name
            self.userInfoTextField.text = user.description
            guard let image = user.imageData else { return }
            self.profileImageView.image = UIImage(data: image, scale: 1.0)
        }
    }
    
    private func addActionsMenu() -> UIMenu {
        let photoAction = UIAction(
            title: L10n.Photo.takePhoto,
            image: UIImage(systemSymbol: .camera)
        ) { [weak self] _ in
            self?.openSystemCamera()
        }
        
        let albumAction = UIAction(
            title: L10n.Photo.openGallery,
            image: UIImage(systemSymbol: .photoOnRectangle)
        ) { [weak self] _ in
            self?.openGallery()
        }
        
        let menuActions = [photoAction, albumAction]
        let addNewMenu = UIMenu(children: menuActions)
        return addNewMenu
    }
    
    private func openSystemCamera() {
        didTappedEditInfoButton()
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .camera
        present(pickerController, animated: true)
    }
    
    private func openGallery() {
        didTappedEditInfoButton()
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.modalPresentationStyle = .fullScreen
        present(pickerController, animated: true)
    }
    
    private func hideSaveButtons() {
        [cancelEditInfoButton, saveGCDButton].forEach {
            $0.isHidden = true
            $0.stopShaking()
        }
        editInfoButton.isHidden = false
    }
    
    private func hideEditButton() {
        [cancelEditInfoButton, saveGCDButton].forEach {
            $0.isHidden = false
            $0.shaking()
        }
        editInfoButton.isHidden = true
    }
    
    @objc private func didTappedEditInfoButton() {
        [userInfoTextField, usernameTextField].forEach {
            $0.isUserInteractionEnabled = true
        }
        usernameTextField.becomeFirstResponder()
        hideEditButton()
        saveGCDButton.isEnabled = false
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(
            title: L10n.Alert.success,
            message: nil,
            preferredStyle: .alert
        )
        let ok = UIAlertAction(
            title: L10n.ok,
            style: .default) { [weak self] _ in
                self?.hideSaveButtons()
        }
        alert.addAction(ok)
        present(alert, animated: true)
        
    }
    
    private func showFailureAlert() {
        let alert = UIAlertController(
            title: L10n.error,
            message: L10n.Alert.failure,
            preferredStyle: .alert
        )
        let ok = UIAlertAction(
            title: L10n.ok,
            style: .default) { [weak self] _ in
                self?.hideSaveButtons()
        }
        
        let repeatSavingInfo = UIAlertAction(
            title: L10n.renew,
            style: .default) { [weak self] _ in
                self?.didTapSaveGCDButton()
        }
        alert.addAction(ok)
        alert.addAction(repeatSavingInfo)
        alert.preferredAction = repeatSavingInfo
        present(alert, animated: true)
    }
    
    @objc private func didTapCancelEditButton(){
        readUserInfoData()
        hideSaveButtons()
    }
    
    private func saveInfo(saveMethod: SettingsFileManagerProtocol) {
        activityIndicator.startAnimating()
        saveGCDButton.isEnabled = false
        let userInfoData = UserInfo(
            name: usernameTextField.text,
            description: userInfoTextField.text,
            imageData: profileImageView.image?.pngData())
        
        saveMethod.saveData(
            user: userInfoData,
            completion: { [weak self] result in
                self?.activityIndicator.stopAnimating()
                switch result {
                case true:
                    self?.showSuccessAlert()
                case false:
                    self?.showFailureAlert()
                }
            }
        )
    }
    
    @objc private func didTapSaveGCDButton() {
        saveInfo(saveMethod: gcdFileManager)
    }
    
    @objc private func showPickingOptions() {
        didTappedEditInfoButton()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photoAction = UIAlertAction(title: L10n.Photo.takePhoto, style: .default, handler: { [weak self] _ in
            self?.openSystemCamera()
        })
        let galleryAction = UIAlertAction(title: L10n.Photo.openGallery, style: .default, handler: { [weak self] _ in
            self?.openGallery()
        })
        let cancel = UIAlertAction(title: L10n.cancel, style: .cancel, handler: nil)
        [photoAction, galleryAction, cancel].forEach {
            alert.addAction($0)
        }
        present(alert, animated: true)
    }
}

// MARK: - Setup UI and Layout

private extension ProfileViewController {
    
    @objc func startTinkoffAnimation(sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .ended:
            emittedLayer.removeFromSuperlayer()
        default:
            emittedLayer.emitterPosition = sender.location(ofTouch: 0, in: view)
            view.layer.addSublayer(emittedLayer)
        }
    }
    
     func setupNavigationBar() {
        closeButton = UIBarButtonItem(title: L10n.close, style: .done, target: self, action: #selector(closeProfileVC))
        let containerLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 400))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 40))
        label.text = L10n.profileTitle
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = ThemeManager.currentTheme.titleTextColor
        containerLeftView.addSubview(label)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: containerLeftView)
        navigationItem.rightBarButtonItem = closeButton
    }

     func setupEditingButtons() {
        [cancelEditInfoButton, saveGCDButton].forEach {
            $0.isHidden = true
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.titleLabel?.font = .systemFont(ofSize: 19, weight: .regular)
            $0.layer.cornerRadius = 14
            $0.layer.masksToBounds = true
            view.addSubview($0)
        }
        
        cancelEditInfoButton.setTitle(L10n.cancel, for: .normal)
        saveGCDButton.setTitle(L10n.save, for: .normal)
        
        cancelEditInfoButton.addTarget(self, action: #selector(didTapCancelEditButton), for: .touchUpInside)
        saveGCDButton.addTarget(self, action: #selector(didTapSaveGCDButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate(
            [
                cancelEditInfoButton.heightAnchor.constraint(equalToConstant: 40),
                cancelEditInfoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
                cancelEditInfoButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 62),
                cancelEditInfoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
                
                saveGCDButton.heightAnchor.constraint(equalToConstant: 40),
                saveGCDButton.topAnchor.constraint(equalTo: cancelEditInfoButton.bottomAnchor, constant: 7),
                saveGCDButton.leadingAnchor.constraint(equalTo: cancelEditInfoButton.leadingAnchor),
                saveGCDButton.trailingAnchor.constraint(equalTo: cancelEditInfoButton.trailingAnchor)
            ]
        )
    }

     func setupEditInfoButton() {
        editInfoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(editInfoButton)
        editInfoButton.titleLabel?.font = .systemFont(ofSize: 19, weight: .regular)
        editInfoButton.setTitle(L10n.edit, for: .normal)
        editInfoButton.layer.cornerRadius = 14
        editInfoButton.layer.masksToBounds = true
        editInfoButton.addTarget(self, action: #selector(didTappedEditInfoButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate(
            [
                editInfoButton.heightAnchor.constraint(equalToConstant: 40),
                editInfoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
                editInfoButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 62),
                editInfoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            ]
        )
    }
    
     func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.color = ThemeManager.currentTheme.titleTextColor
        activityIndicator.topAnchor.constraint(equalTo: userInfoTextField.bottomAnchor, constant: 20).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
     func setupUserInfo() {
        [profileImageView, usernameTextField, userInfoTextField, editUserPhotoButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        editUserPhotoButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        editUserPhotoButton.setTitle(L10n.change, for: .normal)
        if #available(iOS 14.0, *) {
            editUserPhotoButton.menu = addActionsMenu()
            editUserPhotoButton.showsMenuAsPrimaryAction = true
        } else {
            editUserPhotoButton.addTarget(self, action: #selector(showPickingOptions), for: .touchUpInside)
        }
        
        [usernameTextField, userInfoTextField].forEach {
            $0.delegate = self
            $0.textColor = ThemeManager.currentTheme.titleTextColor
            $0.isUserInteractionEnabled = false
        }
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .systemGray6
        
        usernameTextField.font = .systemFont(ofSize: 24, weight: .regular)
        usernameTextField.autocapitalizationType = .words
        usernameTextField.textAlignment = .center
        usernameTextField.attributedPlaceholder = NSAttributedString(
            string: L10n.TextFieldPlaceholders.name,
            attributes: [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme.titleTextColor]
        )
        
        userInfoTextField.font = .systemFont(ofSize: 16, weight: .regular)
        userInfoTextField.attributedPlaceholder = NSAttributedString(
            string: L10n.TextFieldPlaceholders.status,
            attributes: [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme.titleTextColor]
        )
        setupLayoutUserInfoConstraints()
    }
    
     func setupLayoutUserInfoConstraints() {
        NSLayoutConstraint.activate(
            [
                profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
                profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                profileImageView.widthAnchor.constraint(equalToConstant: 240),
                profileImageView.heightAnchor.constraint(equalToConstant: 240),
                
                usernameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 32),
                usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                usernameTextField.widthAnchor.constraint(equalToConstant: 240),
                
                userInfoTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 32),
                userInfoTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                editUserPhotoButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -10),
                editUserPhotoButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor)
            ]
        )
    }
}


// MARK: - UITextFieldDelegate

extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveGCDButton.isEnabled = true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return textField.text?.isEmpty == false
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage
        
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        profileImageView.image = newImage
        dismiss(animated: true)
    }
}


