//
//  SettingModel.swift
//  RacingGame
//
//  Created by Игорь Николаев on 28.02.2024.
//

import Foundation

protocol IModelSetting {
    func createCarsModel() -> [String]
    func createObstaclesModel() -> [String]
}

final class ModelSetting: IModelSetting {
    //: MARK: - Propertys

    private let carsModels = [Constant.Image.carOne,
                              Constant.Image.carTwo,
                              Constant.Image.carThree,
                              Constant.Image.carFour,
                              Constant.Image.carFive]
    private let obstaclesModels = [Constant.Image.carFive,
                                   Constant.Image.carThree,
                                   Constant.Image.carOne]
    //: MARK: - Setups

    func createCarsModel() -> [String] {
        carsModels
    }

    func createObstaclesModel() -> [String] {
        obstaclesModels
    }
}
