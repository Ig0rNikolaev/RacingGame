//
//  StarViewController.swift
//  RacingGame
//
//  Created by Игорь Николаев on 19.02.2024.
//

import UIKit
import SnapKit

class StarViewController: UIViewController {

    //: MARK: - UI Elements

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
        view.backgroundColor = .blue
        navigationController?.isNavigationBarHidden = true
    }

    private func setupHierarchy() {

    }

    private func setupLayout() {

    }
}
