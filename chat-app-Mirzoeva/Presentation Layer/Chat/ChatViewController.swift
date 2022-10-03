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
    
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
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
        initializeFetchedResultsController()
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
    
    private func initializeFetchedResultsController() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: L10n.CoreData.DBMessage)
        request.predicate = NSPredicate(format: "channel.identifier = %@", channelId)
        
        let createdSort = NSSortDescriptor(key: L10n.CoreData.created, ascending: true)
        request.sortDescriptors = [createdSort]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: coreDataStack.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
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
        guard let sections = fetchedResultsController.sections
        else {
            print("No sections in fetchedResultsController")
            return 0
        }
        return sections[section].numberOfObjects
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? MessageViewCell,
            let dbMessage = fetchedResultsController.object(at: indexPath) as? DBMessage,
            let content = dbMessage.content,
            let created = dbMessage.created,
            let senderId = dbMessage.senderId,
            let senderName = dbMessage.senderName
        else { return UITableViewCell() }
        let message = MessageModel(
            content: content,
            created: created,
            senderId: senderId,
            senderName: senderName
        )
        cell.model = message
        cell.backgroundColor = ThemeManager.currentTheme.secondaryColor
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        return cell
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ChatViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        case .delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath as IndexPath? {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath as IndexPath? {
                let message = fetchedResultsController.object(at: indexPath) as? DBMessage
                guard let cell = tableView.cellForRow(at: indexPath as IndexPath) as? MessageViewCell,
                      let content = message?.content,
                      let created = message?.created,
                      let senderId = message?.senderId,
                      let senderName = message?.senderName else { break }
                let cellMessage = MessageModel(
                    content: content,
                    created: created,
                    senderId: senderId,
                    senderName: senderName
                )
                cell.model = cellMessage
            }
        case .move:
            if let indexPath = indexPath as IndexPath? {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath as IndexPath? {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath as IndexPath? {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        @unknown default:
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
