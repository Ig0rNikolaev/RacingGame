//
//  SettingAssembly.swift
//  RacingGame
//
//  Created by Игорь Николаев on 28.02.2024.
//

import UIKit

class SettingAssembly {
    func builder() -> UIViewController {
        let model = ModelSetting()
        let localStorage = LocalStorage(userDefaults: .standard)
        let imageStorage = ImageStorage(fileManager: .default)
        let settingPresenter = SettingPresenter(model: model, localStorage: localStorage, imageStorage: imageStorage)
        let settingController = SettingViewController(presenter: settingPresenter)
        settingPresenter.view = settingController
        return settingController
    }
}
