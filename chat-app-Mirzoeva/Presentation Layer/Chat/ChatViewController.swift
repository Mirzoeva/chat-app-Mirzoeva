//
//  ChatViewController.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 10.03.2022.
//

import UIKit
import FirebaseFirestore
import CoreData

class ChatViewController: UIViewController {
    
    // MARK: - Properties
    
    private var messages: [MessageModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    private let newMessageTextField = UITextField()
    private let newMessageAddButton = UIButton()
    
    private let presenter: ChatPresenter
    private var coreDataStack: CoreDataService
    
    private var channelId: String
    private let cellId = "MessageViewCellId"
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 500
        tableView.register(MessageViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, id: String, coreDataStack: CoreDataService, presenter: ChatPresenter) {
        self.presenter = presenter
        self.coreDataStack = coreDataStack
        self.channelId = id
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.loadMessages(channelId: channelId) { [weak self] data in
            guard let self = self else { return }
            self.messages = data
        }
        setup()
        setupNewMessageAddButton()
        newMessageTextField.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        tableView.backgroundColor = ThemeManager.currentTheme.backgroundColor
        view.backgroundColor = ThemeManager.currentTheme.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme.titleTextColor]    }
    
    // MARK: - Private
    
    private func setup() {
        [tableView, newMessageTextField].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        newMessageTextField.font = .systemFont(ofSize: 18, weight: .regular)
        newMessageTextField.textColor = ThemeManager.currentTheme.titleTextColor
        newMessageTextField.textAlignment = .center
        newMessageTextField.attributedPlaceholder = NSAttributedString(
            string: L10n.TextFieldPlaceholders.message,
            attributes: [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme.titleTextColor])
        newMessageTextField.backgroundColor = ThemeManager.currentTheme.secondaryColor
        newMessageTextField.layer.cornerRadius = 15
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: newMessageTextField.topAnchor, constant:  -10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            newMessageTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            newMessageTextField.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            newMessageTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            newMessageTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupNewMessageAddButton() {
        view.addSubview(newMessageAddButton)
        newMessageAddButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newMessageAddButton.heightAnchor.constraint(equalToConstant: 35),
            newMessageAddButton.widthAnchor.constraint(equalToConstant: 35),
            newMessageAddButton.leadingAnchor.constraint(equalTo: newMessageTextField.trailingAnchor, constant: 5),
            newMessageAddButton.centerYAnchor.constraint(equalTo: newMessageTextField.centerYAnchor)
        ])
        
        newMessageAddButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        newMessageAddButton.backgroundColor = ThemeManager.currentTheme.buttonColor
        newMessageAddButton.layer.cornerRadius = 15
        newMessageAddButton.addTarget(self, action: #selector(addNewMessageTapped), for: .touchUpInside)
    }
    
    @objc private func addNewMessageTapped() {
        let senderId = UserInfoManager.shared.getSenderId()
        UserInfoManager.shared.getUserInfo { [weak self] userInfo in
            guard
                let self = self,
                let content = self.newMessageTextField.text,
                let senderId = senderId
            else { return }
            var name = "unknown"
            if (userInfo.name != nil) {
                name = userInfo.name!
                self.presenter.addMessage(
                    content: content,
                    senderId: senderId,
                    senderName: name,
                    channelId: self.channelId)
                self.newMessageTextField.text = ""
            } else {
                self.addNameAlert() { text in
                    if let textUserEntered = text {
                        name = textUserEntered
                    }
                    self.presenter.addMessage(
                        content: content,
                        senderId: senderId,
                        senderName: name,
                        channelId: self.channelId)
                    self.newMessageTextField.text = ""
                }
            }
        }
    }
    
    private func addNameAlert(completion: @escaping (String?) -> Void) {
        let alert = UIAlertController(
            title: L10n.warning,
            message: L10n.Alert.addName,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: L10n.cancel, style: .cancel)
        
        alert.addTextField { (textField) in
            textField.placeholder = L10n.enterName
        }
        
        let addName = UIAlertAction(
            title: L10n.ok,
            style: .default) { _ in
                let textField = alert.textFields![0] as UITextField
                completion(textField.text)
        }
        
        alert.addAction(cancel)
        alert.addAction(addName)
        alert.preferredAction = addName

        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate


extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return textField.text?.isEmpty == false
    }
}

// MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MessageViewCell
        let channel = messages[indexPath.row]
        let message = MessageModel(
            content: channel.content,
            created: channel.created,
            senderId: channel.senderId,
            senderName: channel.senderName
        )
        cell.model = message
        cell.backgroundColor = ThemeManager.currentTheme.secondaryColor
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        return cell
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        // Добавь айди
//        presenter.deleteMessage(channelId: channelId, messageId: messages[indexPath.row])
    }
}
