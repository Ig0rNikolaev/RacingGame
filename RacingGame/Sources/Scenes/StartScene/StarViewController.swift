//
//  StarViewController.swift
//  RacingGame
//
//  Created by Игорь Николаев on 19.02.2024.
//

import UIKit
import SnapKit

final class StarViewController: UIViewController {

    //: MARK: - UI Elements

    private lazy var startButton: StartSceneButton = {
        let button = StartSceneButton(configurationButton: .start)
        return button
    }()

    private lazy var startSetting: StartSceneButton = {
        let button = StartSceneButton(configurationButton: .setting)
        return button
    }()

    private lazy var startRecord: StartSceneButton = {
        let button = StartSceneButton(configurationButton: .record)
        return button
    }()

    //: MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
    }

    //: MARK: - Actions
    
    //: MARK: - Setups

    private func setupView() {
        view.backgroundColor = .systemGray6
        navigationController?.isNavigationBarHidden = true
    }

    private func setupHierarchy() {
        view.addSubview(startButton)
    }

    private func setupLayout() {
        startButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.width.equalTo(300)
            make.height.equalTo(150)
        }
    }
}
