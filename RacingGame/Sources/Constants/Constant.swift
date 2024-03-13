//
//  Constant.swift
//  RacingGame
//
//  Created by Игорь Николаев on 19.02.2024.
//

import Foundation

final class Constant {
    enum Font {
        static let formulaRegular = "Formula1 Display Regular"
        static let largeFont: CGFloat = 25
        static let smallFont: CGFloat = 15
    }
    
    enum Default {
        static let gameAlpha: CGFloat = 0.7
        static let radius: CGFloat = 7
        static let borderWidth: CGFloat = 1
    }

    enum Duration {
        static let roadDurationEasy = 3.0
        static let obstacleDurationEasy = 4.0
        static let roadDurationMedium = 2.0
        static let obstacleDurationMedium = 3.0
        static let roadDurationHard = 1.0
        static let obstacleDurationHard = 2.0
        static let roadDurationZero = 0.0
        static let obstacleDurationZero = 0.0
    }

    enum Image {
        static let formulaLogo = "lauching"
        static let road = "road"
        static let carOne = "car1"
        static let carTwo = "car2"
        static let carThree = "car3"
        static let carFour = "car4"
        static let carFive = "car5"
    }
}
