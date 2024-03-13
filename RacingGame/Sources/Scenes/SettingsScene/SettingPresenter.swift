//
//  SettingPresenter.swift
//  RacingGame
//
//  Created by Игорь Николаев on 27.02.2024.
//

import UIKit

private extension Int {
    static let currentStep = 1
    static let currentZero = 0
}

private extension String {
    static let editTitle = "Edit"
    static let saveTitle = "Save"
    static let defaultAvatar = ""
}

protocol ISettingPresenter {
    func loadUserProfile()
    func edit(sender: UIBarButtonItem, _ edit: Settings)
    func setsDifficultyLevel(sender: UISegmentedControl, _ duration: Settings)
    func selectCar(sender: GameSceneButton,
                   _ view: SettingSelectView,
                   _ current: Settings)
    func selectObstacle(sender: GameSceneButton,
                        _ view: SettingSelectView,
                        _ current: Settings)
}

final class SettingPresenter: ISettingPresenter {
    //: MARK: - Propertys
    
    weak var view: ISettingView?
    private var model: IModelSetting
    private var imageStorage: ImageStorage 
    private var localStorage: ILocalStorage

    //: MARK: - Initializers

    init(model: IModelSetting, localStorage: ILocalStorage, imageStorage: ImageStorage) {
        self.model = model
        self.localStorage = localStorage
        self.imageStorage = imageStorage
    }

    //: MARK: - Setups

    func selectCar(sender: GameSceneButton, 
                   _ view: SettingSelectView,
                   _ current: Settings) {
        selectModels(sender: sender, view, &current.currentCar, model.createCarsModel())
    }

    func selectObstacle(sender: GameSceneButton, 
                        _ view: SettingSelectView,
                        _ current: Settings) {
        selectModels(sender: sender, view, &current.currentObstacle, model.createObstaclesModel())
    }

    func edit(sender: UIBarButtonItem, _ edit: Settings) {
        if edit.isEdit {
            sender.title = .editTitle
            saveUser()
        } else {
            sender.title = .saveTitle
        }
        edit.isEdit.toggle()
        view?.userInteractionEnabled(edit.isEdit)
    }

    func saveUser() {
        var user = UserSetting()
        let records = localStorage.fetchValue(type: UserSetting.self)?.records
        view?.updateSettings(&user, imageStorage, records)
        localStorage.save(user)
    }

    func loadUserProfile() {
        guard let user = localStorage.fetchValue(type: UserSetting.self) else { return }
        let avatar = imageStorage.loadImage(by: user.avatar ?? .defaultAvatar) ?? UIImage()
        view?.loadUserProfile(user, avatar)
    }

    func setsDifficultyLevel(sender: UISegmentedControl, _ duration: Settings) {
       switch sender.selectedSegmentIndex {
       case 0:
           createSegment(Constant.Duration.roadDurationEasy, 
                         Constant.Duration.obstacleDurationEasy, duration)
       case 1:
           createSegment(Constant.Duration.roadDurationMedium, 
                         Constant.Duration.obstacleDurationMedium, duration)
       case 2:
           createSegment(Constant.Duration.roadDurationHard, 
                         Constant.Duration.obstacleDurationHard, duration)
       default:
           break
       }
   }

    private func selectModels(sender: GameSceneButton, 
                              _ view: SettingSelectView,
                              _ current: inout Int,
                              _ model: [String]) {
        switch sender {
        case view.createRightButton():
            if current != model.count - .currentStep  {
                current += .currentStep
            }
        case view.createLeftButton():
            if current > .currentZero {
                current -= .currentStep
            }
        default:
            break
        }
        self.view?.updateImageSelect(model[current], view)
    }

    private func createSegment(_ road: Double, _ obstacle: Double, _ duration: Settings) {
        duration.roadDuration = road
        duration.obstacleDuration = obstacle
    }
}
