//
//  StartSceneButton.swift
//  RacingGame
//
//  Created by Игорь Николаев on 19.02.2024.
//

import UIKit

fileprivate enum ConstantsButton {
    // String
    static let startTitle = "Start Game"
    static let settingTitle = "Setting Game"
    static let recordTitle = "Records"

    // CGFloat
    static let border: CGFloat = 3
    static let radius: CGFloat = 7
    static let fontSize: CGFloat = 25
}

final class StartSceneButton: UIButton {

    private var configurationButton: ButtonConfiguration

    //MARK: - Initializers

    init(configurationButton: ButtonConfiguration) {
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
        setTitleColor(UIColor.black, for: .normal)
        titleLabel?.font = UIFont(name: Constant.Font.formulaRegular, size: ConstantsButton.fontSize)
        clipsToBounds = true
        layer.borderColor = UIColor.red.cgColor
        layer.cornerRadius = ConstantsButton.radius
        layer.borderWidth = ConstantsButton.border
    }

    private func setupButton() {
        switch configurationButton {
        case .start:
            setups(title: ConstantsButton.startTitle)
        case .setting:
            setups(title: ConstantsButton.settingTitle)
        case .record:
            setups(title: ConstantsButton.recordTitle)
        }
    }
}

//MARK: - Extension

extension StartSceneButton {

    enum ButtonConfiguration {
        case start
        case setting
        case record
    }
}
