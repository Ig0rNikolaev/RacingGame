//
//  SettingModel.swift
//  RacingGame
//
//  Created by Игорь Николаев on 28.02.2024.
//

import Foundation

protocol ISettingModel: AnyObject {
    var settings: [Setting] { get set }
}

enum SectionSetting: Int {
    case obstacle
    case car
}

struct Setting {
    var section: SectionSetting
    var array: [String]
}

final class SettingModel: ISettingModel {
    var settings: [Setting] = [Setting(section: .car, 
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
}
