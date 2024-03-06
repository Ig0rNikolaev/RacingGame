//
//  SettingModel.swift
//  RacingGame
//
//  Created by Игорь Николаев on 28.02.2024.
//

import Foundation

protocol IModelSetting {
    func createSettingModel() -> [Setting]
}

final class ModelSetting: IModelSetting {
  private var settingService: ISettingService

    init(settingService: ISettingService) {
        self.settingService = settingService
    }

    func createSettingModel() -> [Setting] {
        settingService.createSettingServiceModel()
    }
}
