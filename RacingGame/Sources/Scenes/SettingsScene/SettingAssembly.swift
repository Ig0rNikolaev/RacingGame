//
//  SettingAssembly.swift
//  RacingGame
//
//  Created by Игорь Николаев on 28.02.2024.
//

import UIKit

class SettingAssembly {
    func builder() -> UIViewController {
        let settingPresenter = SettingPresenter()
        let settingController = SettingView(presenter: settingPresenter)
        settingPresenter.view = settingController
        return settingController
    }
}
