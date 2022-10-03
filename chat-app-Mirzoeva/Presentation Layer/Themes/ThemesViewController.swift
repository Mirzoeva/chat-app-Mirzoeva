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

    private let stackView = UIStackView()
    private let classicThemeButton = UIButton()
    private let classicThemeLabel = UILabel()
    private let classicThemeStackView = UIStackView()
    private let dayThemeButton = UIButton()
    private let dayThemeLabel = UILabel()
    private let dayThemeStackView = UIStackView()
    private let nightThemeButton = UIButton()
    private let nightThemeLabel = UILabel()
    private let nightThemeStackView = UIStackView()

    private lazy var classicGestureRecognizer: UITapGestureRecognizer = .init(target: self, action: #selector(didChooseClassicTheme))
    private lazy var dayGestureRecognizer: UITapGestureRecognizer = .init(target: self, action: #selector(didChooseDayTheme))
    private lazy var nightGestureRecognizer: UITapGestureRecognizer = .init(target: self, action: #selector(didChooseNightTheme))
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButtons()
        layoutConstraints()
        setupCurrentTheme()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = ThemeManager.currentTheme.backgroundColor
        classicThemeLabel.textColor = ThemeManager.currentTheme.titleTextColor
        dayThemeLabel.textColor = ThemeManager.currentTheme.titleTextColor
        nightThemeLabel.textColor = ThemeManager.currentTheme.titleTextColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme.titleTextColor]
    }
}

// MARK: - Manage Themes

private extension ThemesViewController {
    
    func setupTheme(theme: Theme) {
        switch theme {
        case .classic:
            dayThemeButton.layer.borderColor = UIColor.black.cgColor
            classicThemeButton.layer.borderColor = UIColor.green.cgColor
            nightThemeButton.layer.borderColor = UIColor.black.cgColor
        case .day:
            dayThemeButton.layer.borderColor = UIColor.green.cgColor
            classicThemeButton.layer.borderColor = UIColor.black.cgColor
            nightThemeButton.layer.borderColor = UIColor.black.cgColor
        case .night:
            classicThemeButton.layer.borderColor = UIColor.black.cgColor
            dayThemeButton.layer.borderColor = UIColor.black.cgColor
            nightThemeButton.layer.borderColor = UIColor.green.cgColor
        }
        themeUpdateCompletion?(theme)
        viewWillLayoutSubviews()
    }
    
    func setupCurrentTheme() {
        switch ThemeManager.currentTheme {
        case .night:
            nightThemeButton.layer.borderColor = UIColor.green.cgColor
            break
        case .day:
            dayThemeButton.layer.borderColor = UIColor.green.cgColor
            break
        case .classic:
            classicThemeButton.layer.borderColor = UIColor.green.cgColor
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
                classicThemeButton.heightAnchor.constraint(equalToConstant: 50),
                classicThemeButton.centerXAnchor.constraint(equalTo: classicThemeStackView.centerXAnchor),
                classicThemeLabel.centerXAnchor.constraint(equalTo: classicThemeStackView.centerXAnchor),

                dayThemeButton.heightAnchor.constraint(equalToConstant: 50),
                dayThemeButton.centerXAnchor.constraint(equalTo: dayThemeStackView.centerXAnchor),
                dayThemeLabel.centerXAnchor.constraint(equalTo: dayThemeStackView.centerXAnchor),
                
                nightThemeButton.heightAnchor.constraint(equalToConstant: 50),
                nightThemeButton.centerXAnchor.constraint(equalTo: nightThemeStackView.centerXAnchor),
                nightThemeLabel.centerXAnchor.constraint(equalTo: nightThemeStackView.centerXAnchor),
                
                stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height/5),
                stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: view.frame.width/6),
                stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -view.frame.width/6)
            ]
        )
    }
    
    func setupUI() {
        title = "Settings"
        let cancelButton = UIBarButtonItem(title: L10n.cancel, style: .done, target: self, action: #selector(cancelScene))
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    func setupButtons() {
        [classicThemeButton, dayThemeButton, nightThemeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.cornerRadius = 14
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.black.cgColor
            $0.layer.masksToBounds = true
        }
        
        [classicThemeLabel, dayThemeLabel, nightThemeLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textAlignment = .center
        }
        
        classicThemeButton.backgroundColor = Colors.classicTheme.color
        classicThemeButton.addTarget(self, action: #selector(didChooseClassicTheme), for: .touchUpInside)
        classicThemeLabel.text = L10n.Themes.classic
        
        dayThemeButton.backgroundColor = Colors.dayTheme
        dayThemeButton.addTarget(self, action: #selector(didChooseDayTheme), for: .touchUpInside)
        dayThemeLabel.text = L10n.Themes.day
        
        nightThemeButton.backgroundColor = Colors.nightTheme.color
        nightThemeButton.addTarget(self, action: #selector(didChooseNightTheme), for: .touchUpInside)
        nightThemeLabel.text = L10n.Themes.night
        
        [classicThemeButton, classicThemeLabel].forEach { classicThemeStackView.addArrangedSubview($0) }
        [dayThemeButton, dayThemeLabel].forEach { dayThemeStackView.addArrangedSubview($0) }
        [nightThemeButton, nightThemeLabel].forEach { nightThemeStackView.addArrangedSubview($0) }
        [classicThemeStackView, dayThemeStackView, nightThemeStackView].forEach { stackView.addArrangedSubview($0) }
        
        [classicThemeStackView, dayThemeStackView, nightThemeStackView, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .vertical
            $0.spacing = view.frame.height / 30
        }
        
        classicThemeStackView.addGestureRecognizer(classicGestureRecognizer)
        dayThemeStackView.addGestureRecognizer(dayGestureRecognizer)
        nightThemeStackView.addGestureRecognizer(nightGestureRecognizer)

        view.addSubview(stackView)
    }
}
