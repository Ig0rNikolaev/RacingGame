//
//  GameplayCustom.swift
//  RacingGame
//
//  Created by Игорь Николаев on 14.03.2024.
//

import Foundation

final class GameplayCustom {
    var roadDuration: Double
    var obstacleDuration: Double
    var obstacle: String
    var score: Int

    init(roadDuration: Double, obstacleDuration: Double, obstacleCar: String, score: Int) {
        self.roadDuration = roadDuration
        self.obstacleDuration = obstacleDuration
        self.obstacle = obstacleCar
        self.score = score
    }
}
