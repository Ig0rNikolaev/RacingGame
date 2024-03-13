//
//  StartViewController.swift
//  RacingGame
//
//  Created by Игорь Николаев on 19.02.2024.
//

import UIKit
import SnapKit

private extension String {
    static let startImage = "start"
}

private extension CGFloat {
    static let alphaZero: CGFloat = 0
    static let alphaOne: CGFloat = 1
    static let stackSpacing: CGFloat = 10
}

private extension TimeInterval {
    static let startDuration: TimeInterval = 1.0
    static let startDelay: TimeInterval = 1
}

fileprivate enum ConstantsStart {
    static let offset = 0
    static let backgroundTop = 100
    static let logoTopOffset = 100
    static let logoWidthOffset = 50
    static let logoHeightOffset = 50
    static let stackTopOffset = 50
    static let stackInset = 20
}

final class StartViewController: UIViewController {
    //: MARK: - UI Elements

    private lazy var imageBackground: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: .startImage)
        image.alpha = .alphaZero
        image.contentMode = .scaleAspectFill
        return image
    }()

    private lazy var formulaLogo: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: Constant.Image.formulaLogo)
        image.alpha = .alphaZero
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
        stack.spacing = .stackSpacing
        stack.alpha = .alphaZero
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
            let gameplayConroller = GameplayAssembly()
            navigationFromStart(on: gameplayConroller.build())
        case settingButton:
            let settingController = SettingAssembly()
            navigationFromStart(on: settingController.builder())
        case recordButton:
            let recordConroller = RecordAssembly()
            navigationFromStart(on: recordConroller.build())
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
        UIView.animate(withDuration: .startDuration,
                       delay: .startDelay,
                       options: .curveEaseIn) {
            self.createsAnimation(from: [self.imageBackground, self.stackButtons, self.formulaLogo])
        }
    }

    private func createsAnimation(from array: [UIView]) {
        array.forEach { $0.alpha = .alphaOne }
    }

    private func setupView() {
        view.backgroundColor = .systemGray6
        navigationController?.navigationBar.tintColor = .black
    }

    private func setupHierarchy() {
        view.addViews([imageBackground, formulaLogo, stackButtons])
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
            make.right.left.equalToSuperview().inset(ConstantsStart.stackInset)
            make.bottom.equalTo(view.snp.centerY)
        }

        imageBackground.snp.makeConstraints { make in
            make.top.equalTo(view.snp.centerY).offset(ConstantsStart.backgroundTop)
            make.left.right.bottom.equalTo(ConstantsStart.offset)
        }
    }
}
