//
//  ConversationsListViewController.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 23.02.2022.
//

import UIKit
import SFSafeSymbols
import FirebaseFirestore
import CoreData

class ChannelsViewController: UIViewController {
    
    // MARK: - Properties

    private var chatSectionsData: [ChannelModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var coreDataStack: CoreDataService
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    private var presenter: ChannelsPresenter
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 500
        tableView.register(ChannelViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private let cellId = "ConversationsCellId"
    private let addChannelButton = UIButton()
    
    // MARK: - Lifecycle

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, coreDataStack: CoreDataService, presenter: ChannelsPresenter) {
        self.coreDataStack = coreDataStack
        self.presenter = presenter
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFetchedResultsController()
        setup()
        presenter.loadChats { [weak self] data in
            guard let self = self else { return }
            self.chatSectionsData = data
        }
        setupAddChannelButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.backgroundColor = ThemeManager.currentTheme.backgroundColor
        self.view.backgroundColor = ThemeManager.currentTheme.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme.titleTextColor]
        tableView.reloadData()
        addChannelButton.backgroundColor = ThemeManager.currentTheme.buttonColor
    }
    
    // MARK: - Private
    
    private func initializeFetchedResultsController() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: L10n.CoreData.DBChannel)
        
        let createdSort = NSSortDescriptor(key: L10n.CoreData.lastActivity, ascending: true)
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
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let profileButton = UIBarButtonItem(image: UIImage(systemSymbol: .person), style: .done, target: self, action: #selector(openProfile))
        let themesButton = UIBarButtonItem(image: UIImage(systemSymbol: .gear), style: .done, target: self, action: #selector(openSettings))
        title = "Channels"
        navigationItem.rightBarButtonItem = profileButton
        navigationItem.leftBarButtonItem = themesButton
    }
    
    private func setupAddChannelButton() {
        view.addSubview(addChannelButton)
        addChannelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addChannelButton.heightAnchor.constraint(equalToConstant: 30),
            addChannelButton.widthAnchor.constraint(equalToConstant: 30),
            addChannelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addChannelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
        addChannelButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addChannelButton.backgroundColor = ThemeManager.currentTheme.buttonColor
        addChannelButton.layer.cornerRadius = 15
        addChannelButton.addTarget(self, action: #selector(addChannelTapped), for: .touchUpInside)
    }

    

    @objc private func openSettings() {
        let themesViewController = ThemesViewController()
        themesViewController.delegate = ThemeManager.shared
        themesViewController.themeUpdateCompletion = { theme in
            ThemeManager.applyTheme(theme: theme)
        }
        self.navigationController?.pushViewController(themesViewController, animated: true)
    }
    
    @objc private func openProfile() {
        let profileViewController = ProfileViewController(gcdFileManager: GCDFileManger())
        let navController = UINavigationController(rootViewController: profileViewController)
        self.navigationController?.present(navController, animated: true)
    }
    
    @objc private func addChannelTapped() {
        let alert = UIAlertController(
            title: L10n.createNewChannel,
            message: nil,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: L10n.cancel, style: .cancel)
        
        alert.addTextField { (textField) in
            textField.placeholder = L10n.enterChannelName
        }
        
        let create = UIAlertAction(
            title: L10n.create,
            style: .default) { [weak self] _ in
                let textField = alert.textFields![0] as UITextField
                self?.presenter.addChannel(channelName: textField.text)
        }
        
        alert.addAction(cancel)
        alert.addAction(create)
        alert.preferredAction = create

        present(alert, animated: true)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ChannelsViewController: NSFetchedResultsControllerDelegate {
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
                let channel = fetchedResultsController.object(at: indexPath) as? DBChannel
                guard let cell = tableView.cellForRow(at: indexPath as IndexPath) as? ChannelViewCell,
                      let identifier = channel?.identifier,
                      let name = channel?.name,
                      let lastMessage = channel?.lastMessage,
                      let lastActivity = channel?.lastActivity else { break }
                let cellChannel = ChannelModel(
                    identifier: identifier,
                    name: name,
                    lastMessage: lastMessage,
                    lastActivity: lastActivity)
                cell.model = cellChannel
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

// MARK: - UITableViewDataSource

extension ChannelsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? ChannelViewCell,
            let dbChannel = fetchedResultsController.object(at: indexPath) as? DBChannel,
            let identifier = dbChannel.identifier,
            let name = dbChannel.name,
            let lastMessage = dbChannel.lastMessage,
            let lastActivity = dbChannel.lastActivity
        else { return UITableViewCell() }
        let message = ChannelModel(
            identifier: identifier,
            name: name,
            lastMessage: lastMessage,
            lastActivity: lastActivity
        )
        cell.model = message
        return cell
    }

}

// MARK: - UITableViewDelegate

extension ChannelsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let channel = fetchedResultsController.object(at: indexPath) as? DBChannel,
            let identifier = channel.identifier,
            let name = channel.name else { return }
        let presenter = ChatPresenterImpl(coreDataStack: coreDataStack)
        let chatViewController = ChatViewController(
            nibName: nil, bundle: nil,
            id: identifier,
            coreDataStack: coreDataStack,
            presenter: presenter)
        chatViewController.title = name
        self.navigationController?.pushViewController(chatViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

