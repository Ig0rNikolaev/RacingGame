//
//  BaseGameModel.swift
//  RacingGame
//
//  Created by Игорь Николаев on 14.03.2024.
//

import Foundation

final class BaseGameModel {
    var imageCar: String
    var imageObstacle: String

    init(imageCar: String, imageObstacle: String) {
        self.imageCar = imageCar
        self.imageObstacle = imageObstacle
    }
}
