//
//  LaunchScreenController.swift
//  RacingGame
//
//  Created by Игорь Николаев on 19.02.2024.
//

import UIKit
import SnapKit

extension String {
    static let launchImage = "lauching"
}

extension Double {
    static let launchImageDuration = 1.0
    static let launchImageDelay = 0.0
}

extension CGFloat {
    static let launchImageAlpha = 0.0
}

fileprivate enum ConstantsLaunch {
    static let launchImageWidth = 300
    static let launchImageHeight = 150
}

final class LaunchScreenController: UIViewController {
    //: MARK: - UI Elements

    private lazy var launchImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: .launchImage)
        image.contentMode = .scaleAspectFit
        return image
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
        setupAnimation()
    }

    //: MARK: - Setups

    private func setupAnimation() {
        UIView.animate(withDuration: .launchImageDuration,
                       delay: .launchImageDelay,
                       options: .curveLinear) {
            self.launchImageView.alpha = .launchImageAlpha
        } completion: { _ in
            self.transitionToStartScreen()
        }
    }

    private func transitionToStartScreen() {
        if let navigationController {
            let startController = StartViewController()
            navigationController.pushViewController(startController, animated: false)
        }
    }

    private func setupView() {
        view.backgroundColor = .systemGray6
    }

    private func setupHierarchy() {
        view.addSubview(launchImageView)
    }

    private func setupLayout() {
        launchImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.width.equalTo(ConstantsLaunch.launchImageWidth)
            make.height.equalTo(ConstantsLaunch.launchImageHeight)
        }
    }
}
