//
//  SettingModel.swift
//  RacingGame
//
//  Created by Игорь Николаев on 28.02.2024.
//

import Foundation

struct UserSetting: Codable {
   var name: String?
   var avatar: String?
   var obstacleImage: String?
   var carImage: String?
   var durationRoad: Double?
   var durationObstacle: Double?
   var segmentLevel: Int?
   var records: [Int]?
}

protocol IModelSetting {
    func createCarsModel() -> [String]
    func createObstaclesModel() -> [String]
    var user: UserSetting { get set }
}

final class ModelSetting: IModelSetting {
    private let cars = ["car1", "car2", "car3", "car4", "car5"]
    private let obstacles = ["car5", "car3", "car1"]
    var user = UserSetting()

    func createCarsModel() -> [String] {
        cars
    }
    
    func createObstaclesModel() -> [String] {
        obstacles
    }
}
