//
//  StartViewController.swift
//  RacingGame
//
//  Created by Игорь Николаев on 19.02.2024.
//

import UIKit
import SnapKit

fileprivate enum ConstantsStart {
    //: MARK: - Constants
    
    //String
    static let startImage = "start"

    //CGFloat
    static let alphaZero: CGFloat = 0
    static let alphaOne: CGFloat = 1
    static let stackSpacing: CGFloat = 10

    //TimeInterval
    static let startDuration: TimeInterval = 1.0
    static let startDelay: TimeInterval = 1

    //Constraints
    static let offset = 0
    static let backgroundTop = 100
    static let logoTopOffset = 100
    static let logoWidthOffset = 50
    static let logoHeightOffset = 50
    static let stackTopOffset = 50
    static let stackRightOffset = -20
    static let stackLeftOffset = 20
}

final class StartViewController: UIViewController {

    //: MARK: - UI Elements

    private lazy var imageBackground: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: ConstantsStart.startImage)
        image.alpha = ConstantsStart.alphaZero
        image.contentMode = .scaleAspectFill
        return image
    }()

    private lazy var formulaLogo: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: Constant.Image.formulaLogo)
        image.alpha = ConstantsStart.alphaZero
        image.contentMode = .scaleAspectFill
        return image
    }()

    private lazy var startButton: StartSceneButton = {
        let button = StartSceneButton(configurationButton: .start)
        button.addTarget(self, action: #selector(navigationScreen), for: .touchUpInside)
        return button
    }()

    private lazy var settingButton: StartSceneButton = {
        let button = StartSceneButton(configurationButton: .setting)
        button.addTarget(self, action: #selector(navigationScreen), for: .touchUpInside)
        return button
    }()

    private lazy var recordButton: StartSceneButton = {
        let button = StartSceneButton(configurationButton: .record)
        button.addTarget(self, action: #selector(navigationScreen), for: .touchUpInside)
        return button
    }()

    private lazy var stackButtons: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [startButton, settingButton, recordButton])
        stack.axis = .vertical
        stack.spacing = ConstantsStart.stackSpacing
        stack.alpha = ConstantsStart.alphaZero
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()

    //: MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupBackgroundImage()
    }

    //: MARK: - Actions

    @objc
    func navigationScreen(_ sender: UIButton) {
        switch sender {
        case startButton:
            let gameplayConroller = GameplayViewConroller()
            navigationFromStart(on: gameplayConroller)
        case settingButton:
            print("settingButton")
        case stackButtons:
            print("stackButtons")
        default:
            break
        }
    }

    //: MARK: - Setups

    private func navigationFromStart(on viewController: UIViewController) {
        if let navigationController {
            navigationController.pushViewController(viewController, animated: false)
        }
    }

    private func setupBackgroundImage() {
        UIView.animate(withDuration: ConstantsStart.startDuration,
                       delay: ConstantsStart.startDelay,
                       options: .curveEaseIn) {
            self.createsAnimation(from: [self.imageBackground, self.stackButtons, self.formulaLogo])
        }
    }

    private func createsAnimation(from array: [UIView]) {
        array.forEach { $0.alpha = ConstantsStart.alphaOne }
    }

    private func setupView() {
        view.backgroundColor = .systemGray6
    }

    private func setupHierarchy() {
        view.addSubview(imageBackground)
        view.addSubview(formulaLogo)
        view.addSubview(stackButtons)
    }

    private func setupLayout() {
        formulaLogo.snp.makeConstraints { make in
            make.top.equalTo(ConstantsStart.logoTopOffset)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(ConstantsStart.logoWidthOffset)
            make.height.equalTo(ConstantsStart.logoHeightOffset)
        }

        stackButtons.snp.makeConstraints { make in
            make.top.equalTo(formulaLogo.snp.bottom).offset(ConstantsStart.stackTopOffset)
            make.right.equalTo(ConstantsStart.stackRightOffset)
            make.left.equalTo(ConstantsStart.stackLeftOffset)
            make.bottom.equalTo(view.snp.centerY)
        }

        imageBackground.snp.makeConstraints { make in
            make.top.equalTo(view.snp.centerY).offset(ConstantsStart.backgroundTop)
            make.left.right.bottom.equalTo(ConstantsStart.offset)
        }
    }
}
