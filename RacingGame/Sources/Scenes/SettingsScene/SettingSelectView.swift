//
//  SettingSelectView.swift
//  RacingGame
//
//  Created by Игорь Николаев on 10.03.2024.
//

import UIKit
import SnapKit

fileprivate enum ConstantsSettingSelect {
    //: MARK: - Constants
    //String
    static let carPlaceholder = "Car: "
    static let obstaclePlaceholder = "Obstacle: "
    
    //CGFloat
    static let cellBorderWidth: CGFloat = 1
    static let stackSpacing: CGFloat = 10
    static let radius: CGFloat = 10
    
    //Constraints
    static let labelLeftOffset = 10
    static let stackRightOffset = -10
    static let stackWidth = 170
    static let stackHeight = 53
}

class SettingSelectView: UIView {
    
    //: MARK: - Properties
    
    private var configuration: SettingConfiguration
    
    //: MARK: - UI Elements
    
    private lazy var settingName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constant.Font.formulaRegular,
                            size: Constant.Button.buttonFont)
        return label
    }()
    
    private lazy var buttonLeft: GameSceneButton = {
        let button = GameSceneButton(configurationButton: .left)
        return button
    }()
    
    private lazy var buttonRight: GameSceneButton = {
        let button = GameSceneButton(configurationButton: .right)
        return button
    }()
    
    private lazy var imageSetting: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var changeSettingStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [buttonLeft, imageSetting, buttonRight])
        stack.spacing = ConstantsSettingSelect.stackSpacing
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    
    //MARK: - Initializers
    
    init(_ configuration: SettingConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //: MARK: - Setups

    func createButtonAction(action: Selector, event: UIControl.Event) {
        buttonLeft.addTarget(nil, action: action, for: event)
        buttonRight.addTarget(nil, action: action, for: event)
    }

    func createLeftButton() -> GameSceneButton {
        buttonLeft
    }

    func createRightButton() -> GameSceneButton {
        buttonRight
    }

    func createImage() -> UIImageView {
        imageSetting
    }

    private func setupView() {
        backgroundColor = .white
        layer.borderWidth = ConstantsSettingSelect.cellBorderWidth
        layer.cornerRadius = ConstantsSettingSelect.radius
        layer.borderColor = UIColor.systemGray5.cgColor
        
        switch configuration {
        case .car:
            settingName.text = ConstantsSettingSelect.carPlaceholder
        case .obstacle:
            settingName.text = ConstantsSettingSelect.obstaclePlaceholder
        }
    }
    
    private func setupHierarchy() {
        let views = [settingName, changeSettingStack]
        addViews(views)
    }
    
    private func setupLayout() {
        settingName.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(ConstantsSettingSelect.labelLeftOffset)
        }
        changeSettingStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(ConstantsSettingSelect.stackRightOffset)
            make.width.equalTo(ConstantsSettingSelect.stackWidth)
            make.height.equalTo(ConstantsSettingSelect.stackHeight)
        }
    }
}

extension SettingSelectView {
    enum SettingConfiguration {
        case car
        case obstacle
    }
}
