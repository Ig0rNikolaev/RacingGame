//
//  LauncScreenController.swift
//  RacingGame
//
//  Created by Игорь Николаев on 19.02.2024.
//

import UIKit
import SnapKit

fileprivate enum Constants {
    // Images
    static let launchImage = "lauching"

    // Layouts
    static let launchImageWidth = 300
    static let launchImageHeight = 150

    // Animations
    static let launchImageDuration = 1.0
    static let launchImageDelay = 0.0
    static let launchImageAlpha = 0.0
}

final class LauncScreenController: UIViewController {

    //: MARK: - UI Elements

    private lazy var launchImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: Constants.launchImage)
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
        UIView.animate(withDuration: Constants.launchImageDuration,
                       delay: Constants.launchImageDelay,
                       options: .curveLinear) {
            self.launchImageView.alpha = Constants.launchImageAlpha
        } completion: { _ in
            self.transitionToStartScreen()
        }
    }

    private func animatesTransition() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        return transition
    }

    private func transitionToStartScreen() {
        if let navigationController {
            let startController = StarViewController()
            navigationController.view.layer.add(animatesTransition(), forKey: "transition")
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
            make.width.equalTo(Constants.launchImageWidth)
            make.height.equalTo(Constants.launchImageHeight)
        }
    }
}
