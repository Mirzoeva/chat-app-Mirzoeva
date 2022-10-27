//
//  ThemesViewController.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 16.03.2022.
//

import UIKit


protocol ThemesViewControllerDelegate: AnyObject {
    func didChooseTheme(_ theme: Theme)
}

class ThemesViewController: UIViewController {
    
    // MARK: - Properties

    weak var delegate: ThemesViewControllerDelegate?
    var themeUpdateCompletion: ((Theme) -> Void)?
    
    private let classicThemeView = ChatThemeView(with: .classic)
    private let dayThemeView = ChatThemeView(with: .day)
    private let nightThemeView = ChatThemeView(with: .night)

    private lazy var classicGestureRecognizer: UITapGestureRecognizer = .init(target: self, action: #selector(didChooseClassicTheme))
    private lazy var dayGestureRecognizer: UITapGestureRecognizer = .init(target: self, action: #selector(didChooseDayTheme))
    private lazy var nightGestureRecognizer: UITapGestureRecognizer = .init(target: self, action: #selector(didChooseNightTheme))
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViews()
        layoutConstraints()
        setupCurrentTheme()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = ThemeManager.currentTheme.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme.titleTextColor]
    }
}

// MARK: - Manage Themes

private extension ThemesViewController {
    func setupTheme(theme: Theme) {
        switch theme {
        case .classic:
            classicThemeView.isChosen = true
            dayThemeView.isChosen = false
            nightThemeView.isChosen = false
        case .day:
            dayThemeView.isChosen = true
            classicThemeView.isChosen = false
            nightThemeView.isChosen = false
        case .night:
            nightThemeView.isChosen = true
            dayThemeView.isChosen = false
            classicThemeView.isChosen = false
        }
        themeUpdateCompletion?(theme)
        viewWillLayoutSubviews()
    }
    
    func setupCurrentTheme() {
        switch ThemeManager.currentTheme {
        case .night:
            nightThemeView.isChosen = true
            break
        case .day:
            dayThemeView.isChosen = true
            break
        case .classic:
            classicThemeView.isChosen = true
        }
    }
    
    @objc func didChooseClassicTheme() {
        setupTheme(theme: .classic)
    }
    
    @objc func didChooseDayTheme() {
        setupTheme(theme: .day)
    }
    
    @objc func didChooseNightTheme() {
        setupTheme(theme: .night)
    }
    
    @objc func cancelScene() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Setup UI and Layout

private extension ThemesViewController {
    
    func layoutConstraints() {
        NSLayoutConstraint.activate(
            [
                classicThemeView.heightAnchor.constraint(equalToConstant: 100),
                classicThemeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height/5),
                classicThemeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: view.frame.width/6),
                classicThemeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -view.frame.width/6),
                
                dayThemeView.heightAnchor.constraint(equalToConstant: 100),
                dayThemeView.topAnchor.constraint(equalTo: classicThemeView.bottomAnchor, constant: 10),
                dayThemeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: view.frame.width/6),
                dayThemeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -view.frame.width/6),
                
                nightThemeView.heightAnchor.constraint(equalToConstant: 100),
                nightThemeView.topAnchor.constraint(equalTo: dayThemeView.bottomAnchor, constant: 10),
                nightThemeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: view.frame.width/6),
                nightThemeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -view.frame.width/6)
            ]
        )
    }
    
    func setupUI() {
        title = "Settings"
        let cancelButton = UIBarButtonItem(title: L10n.cancel, style: .done, target: self, action: #selector(cancelScene))
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    func setupViews() {
        [classicThemeView, dayThemeView, nightThemeView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        classicThemeView.button.addTarget(self, action: #selector(didChooseClassicTheme), for: .touchUpInside)
        dayThemeView.button.addTarget(self, action: #selector(didChooseDayTheme), for: .touchUpInside)
        nightThemeView.button.addTarget(self, action: #selector(didChooseNightTheme), for: .touchUpInside)
        
        classicThemeView.addGestureRecognizer(classicGestureRecognizer)
        dayThemeView.addGestureRecognizer(dayGestureRecognizer)
        nightThemeView.addGestureRecognizer(nightGestureRecognizer)
    }
}
