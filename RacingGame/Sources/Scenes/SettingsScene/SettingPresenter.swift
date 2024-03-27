//
//  SettingPresenter.swift
//  RacingGame
//
//  Created by Игорь Николаев on 27.02.2024.
//

import UIKit

private extension Int {
    static let currentStep = 1
}

private extension String {
    static let editTitle = "Edit"
    static let saveTitle = "Save"
    static let defaultAvatar = ""
}

protocol ISettingPresenter {
    func loadUserProfile()
    func controlsEditing(by access: Settings, _ sender: UIBarButtonItem)
    func setsDifficultyLevel(sender: UISegmentedControl, _ duration: Settings)
    func selectCar(by current: Settings,
                   _ sender: GameSceneButton,
                   _ view: SettingSelectView)
    func selectObstacle(by current: Settings,
                        _ sender: GameSceneButton,
                        _ view: SettingSelectView)
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

    func selectCar(by current: Settings,
                   _ sender: GameSceneButton,
                   _ view: SettingSelectView) {
        selectModels(from: model.createCarsModel(),
                     by: &current.currentCar, sender, view)
    }

    func selectObstacle(by current: Settings,
                        _ sender: GameSceneButton,
                        _ view: SettingSelectView) {
        selectModels(from: model.createObstaclesModel(),
                     by: &current.currentObstacle, sender, view)
    }

    func controlsEditing(by access: Settings, _ sender: UIBarButtonItem) {
        if access.isEdit {
            sender.title = .editTitle
            saveUserProfile()
        } else {
            sender.title = .saveTitle
        }
        access.isEdit.toggle()
        view?.userInteractionEnabled(access.isEdit)
    }

    func loadUserProfile() {
        guard let user = localStorage.fetchValue(type: UserSetting.self) else { return }
        let avatar = imageStorage.loadImage(by: user.avatar ?? .defaultAvatar) ?? UIImage()
        view?.preparesLoad(user: user, avatar)
    }

    func setsDifficultyLevel(sender: UISegmentedControl, _ duration: Settings) {
        switch sender.selectedSegmentIndex {
        case 0:
            sets(duration: duration,
                 for: Constant.Duration.roadDurationEasy,
                 and: Constant.Duration.obstacleDurationEasy)
        case 1:
            sets(duration: duration,
                 for: Constant.Duration.roadDurationMedium,
                 and: Constant.Duration.obstacleDurationMedium)
        case 2:
            sets(duration: duration,
                 for: Constant.Duration.roadDurationHard,
                 and: Constant.Duration.obstacleDurationHard)
        default:
            break
        }
    }

    private func sets(duration: Settings, for road: Double, and obstacle: Double) {
        duration.roadDuration = road
        duration.obstacleDuration = obstacle
    }

    private func saveUserProfile() {
        var user = UserSetting()
        let records = localStorage.fetchValue(type: UserSetting.self)?.records
        view?.preparesSave(user: &user, imageStorage, records)
        localStorage.save(user)
    }

    private func selectModels(from model: [String],
                              by current: inout Int,
                              _ sender: GameSceneButton,
                              _ view: SettingSelectView) {
        switch sender {
        case view.createRightButton():
            current = (current + .currentStep) % model.count
        case view.createLeftButton():
            current = (current - .currentStep + model.count) % model.count
        default:
            break
        }
        if let value = model.getsObject(by: current) {
            self.view?.updateImageSelect(value, view)
        }
    }
}
