//
//  Settings.swift
//  RacingGame
//
//  Created by Игорь Николаев on 14.03.2024.
//

import Foundation

final class Settings {
    var isEdit: Bool
    var currentCar: Int
    var currentObstacle: Int
    var roadDuration: Double
    var obstacleDuration: Double

    init(roadDuration: Double, obstacleDuration: Double, isEdit: Bool, currentCar: Int, currentObstacle: Int) {
        self.roadDuration = roadDuration
        self.obstacleDuration = obstacleDuration
        self.isEdit = isEdit
        self.currentCar = currentCar
        self.currentObstacle = currentObstacle
    }
}
