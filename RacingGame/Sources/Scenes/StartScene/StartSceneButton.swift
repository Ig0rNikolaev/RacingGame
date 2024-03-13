//
//  StartSceneButton.swift
//  RacingGame
//
//  Created by Игорь Николаев on 19.02.2024.
//

import UIKit

private extension String {
    static let startTitle = "Start Game"
    static let settingTitle = "Setting Game"
    static let recordTitle = "Records"
}

final class StartSceneButton: UIButton {
    //: MARK: - Properties
    
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
        setTitleColor(UIColor.systemGray6, for: .normal)
        titleLabel?.font = UIFont(name: Constant.Font.formulaRegular, size: Constant.Font.largeFont)
        clipsToBounds = true
        backgroundColor = .black
        alpha = Constant.Default.gameAlpha
        layer.cornerRadius = Constant.Default.radius
        layer.borderWidth = Constant.Default.borderWidth
    }

    private func setupButton() {
        switch configurationButton {
        case .start:
            setups(title: .startTitle)
        case .setting:
            setups(title: .settingTitle)
        case .record:
            setups(title: .recordTitle)
        }
    }
}

//MARK: - Extensions

extension StartSceneButton {
    enum ButtonConfiguration {
        case start
        case setting
        case record
    }
}
