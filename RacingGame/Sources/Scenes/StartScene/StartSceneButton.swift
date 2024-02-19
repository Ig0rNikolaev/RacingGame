//
//  StartSceneButton.swift
//  RacingGame
//
//  Created by Игорь Николаев on 19.02.2024.
//

import UIKit

fileprivate enum Constants {
    // String
    static let startTitle = "Start Game"
    static let settingTitle = "Setting Game"
    static let recordTitle = "Records"

    // Setting
    static let border: CGFloat = 10
    static let radius: CGFloat = 70
}

final class StartSceneButton: UIButton {

    private var configurationButton: ButtonConfig

    //MARK: - Initializers

    init(configurationButton: ButtonConfig) {
        self.configurationButton = configurationButton
        super.init(frame: .zero)
        setupButton()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    //MARK: - Setups

    private func setups(title: String) {
        setTitle(title, for: .normal)
        setTitleColor(UIColor.systemRed, for: .normal)
        layer.borderColor = UIColor.systemRed.cgColor
        layer.borderWidth = Constants.border
        layer.cornerRadius = Constants.radius
    }

    private func setupButton() {
        switch configurationButton {
        case .start:
            setups(title: Constants.startTitle)
        case .setting:
            setups(title: Constants.settingTitle)
        case .record:
            setups(title: Constants.recordTitle)
        }
    }
}

//MARK: - Extension

extension StartSceneButton {

    enum ButtonConfig {
        case start
        case setting
        case record
    }
}
