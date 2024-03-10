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
    
}

final class ModelSetting: IModelSetting {

}
