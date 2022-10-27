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

    private let photoInfoVC = ChatPhotoInfoViewController()
    private let profileInfo = ChatProfileInfoView(frame: .zero)
    private let headerView = UIView()

    private var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    private var closeButton = UIBarButtonItem()

    private let editInfoButton = ChatActionButton()
    private let cancelEditInfoButton = ChatActionButton()
    private let saveGCDButton = ChatActionButton()
    private let gcdFileManager: SettingsFileManagerProtocol

    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    private lazy var longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(startTinkoffAnimation))
    
    private lazy var tinkoffCell = ChatEmitterCell()
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
        photoInfoVC.editButton.setTitleColor(ThemeManager.currentTheme.secondaryColor, for: .normal)
        
        [editInfoButton, cancelEditInfoButton, saveGCDButton].forEach {
            $0.backgroundColor = ThemeManager.currentTheme.buttonColor
            $0.setTitleColor(ThemeManager.currentTheme.secondaryColor, for: .normal)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Private
    
    @objc private func closeProfileVC() {
        dismiss(animated: true)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
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
        profileInfo.isEditing = true
        hideEditButton()
        saveGCDButton.isEnabled = false
    }
    
    private func showSuccessAlert() {
        presentGFAlertOnMainThread(title: "", message: L10n.Alert.success, buttonTitle: L10n.ok)
        hideSaveButtons()
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
    
    @objc private func didTapSaveGCDButton() {
        saveInfo(saveMethod: gcdFileManager)
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
    
    private func setupNavigationBar() {
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

    private func setupEditingButtons() {
        [cancelEditInfoButton, saveGCDButton].forEach {
            $0.isHidden = true
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

    private func setupEditInfoButton() {
        view.addSubview(editInfoButton)
        editInfoButton.setTitle(L10n.edit, for: .normal)
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
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.color = ThemeManager.currentTheme.titleTextColor
        activityIndicator.topAnchor.constraint(equalTo: profileInfo.bottomAnchor, constant: 20).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
     private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
     private func setupUserInfo() {
         [headerView, profileInfo].forEach {
             view.addSubview($0)
             $0.translatesAutoresizingMaskIntoConstraints = false
         }
         self.add(childVC: photoInfoVC, to: self.headerView)
         
         [profileInfo.usernameTextField, profileInfo.userInfoTextField].forEach {
             $0.delegate = self
         }
        setupLayoutUserInfoConstraints()
    }
    
    private func setupLayoutUserInfoConstraints() {
        NSLayoutConstraint.activate(
            [
                headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
                headerView.heightAnchor.constraint(equalToConstant: 300),
                
                profileInfo.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 32),
                profileInfo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                profileInfo.widthAnchor.constraint(equalToConstant: 240),
                profileInfo.heightAnchor.constraint(equalToConstant: 150)
            ]
        )
    }
}

// MARK: - Data

extension ProfileViewController {
    
    private func readUserInfoData() {
        gcdFileManager.readData { [weak self] user in
            guard let self = self else { return }
            self.profileInfo.usernameTextField.text = user.name
            self.profileInfo.userInfoTextField.text = user.description
            guard let image = user.imageData else { return }
            self.photoInfoVC.photoView.image = UIImage(data: image, scale: 1.0)
        }
    }
    
    private func saveInfo(saveMethod: SettingsFileManagerProtocol) {
        activityIndicator.startAnimating()
        saveGCDButton.isEnabled = false
        let userInfoData = UserInfo(
            name: profileInfo.usernameTextField.text,
            description: profileInfo.userInfoTextField.text,
            imageData: photoInfoVC.photoView.image?.pngData())
        
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

