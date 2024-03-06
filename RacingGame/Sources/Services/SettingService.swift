//
//  SettingService.swift
//  RacingGame
//
//  Created by Игорь Николаев on 06.03.2024.
//

import Foundation

protocol ISettingService: AnyObject {
    func createSettingServiceModel() ->[Setting]
}

enum SectionSetting: Int {
    case obstacle
    case car
}

struct Setting {
    var section: SectionSetting
    var array: [String]
}

final class SettingService: ISettingService {
   private var settings: [Setting] = [Setting(section: .car,
                                       array: [Constant.Image.carOne,
                                               Constant.Image.carTwo,
                                               Constant.Image.carThree,
                                               Constant.Image.carFour,
                                               Constant.Image.carFive]),
                               Setting(section: .obstacle,
                                       array: [Constant.Image.carOne,
                                               Constant.Image.carTwo,
                                               Constant.Image.carThree])
    ]

    func createSettingServiceModel() ->[Setting] {
        settings
    }
}
