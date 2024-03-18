//
//  GameSceneButton.swift
//  RacingGame
//
//  Created by Игорь Николаев on 20.02.2024.
//

import UIKit

fileprivate enum ConstantsButton {
    //: MARK: - Constants
    
    // String
    static let imageLeft = "arrow.left.square.fill"
    static let imageRight = "arrow.right.square.fill"
}

final class GameSceneButton: UIButton {
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

    private func setups(systemImage: String) {
        let image = UIImage(systemName: systemImage)?.withRenderingMode(.alwaysTemplate)
        setBackgroundImage(image, for: .normal)
        tintColor = .black
        contentMode = .scaleAspectFill
        alpha = Constant.Default.gameAlpha
    }

    private func setupButton() {
        switch configurationButton {
        case .left:
            self.setups(systemImage: ConstantsButton.imageLeft)
        case .right:
            self.setups(systemImage: ConstantsButton.imageRight)
        }
    }
}

//MARK: - Extension

extension GameSceneButton {

    enum ButtonConfiguration {
        case left
        case right
    }
}
