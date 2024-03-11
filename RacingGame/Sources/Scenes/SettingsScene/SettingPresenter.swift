//
//  SettingPresenter.swift
//  RacingGame
//
//  Created by Игорь Николаев on 27.02.2024.
//

import UIKit

fileprivate enum ConstantsSettingPresenter {
    //: MARK: - Constants
    //String
    static let editTitle = "Edit"
    static let saveTitle = "Save"

    //Int
    static let currentStep = 1
    static let currentZero = 0
}

protocol ISettingPresenter {
    func edit(sender: UIBarButtonItem)
    func selectLevel(sender: UISegmentedControl)
    func saveImageFile(_ image: UIImage, _ file: inout String?)
    func selectCar(sender: GameSceneButton, _ view: SettingSelectView)
    func selectObstacle(sender: GameSceneButton, _ view: SettingSelectView)
    func loadUserProfile(_ name: inout String?,
                         _ segment: inout Int,
                         _ car: inout UIImage?,
                         _ obstacle: inout UIImage?,
                         _ profileImage: inout UIImage?)
}

final class SettingPresenter: ISettingPresenter {
    private var isEdit = false
    private var currentCar = 0
    private var currentObstacle = 0
    private var durationRoad: Double = 0
    private var durationObstacle: Double = 0
    private var level = 0
    private var localStorage: ILocalStorage
    private var imageStorage: ImageStorage 
    private var model: IModelSetting
    weak var view: ISettingView?

    init(model: IModelSetting, localStorage: ILocalStorage, imageStorage: ImageStorage) {
        self.model = model
        self.localStorage = localStorage
        self.imageStorage = imageStorage
    }

    func selectCar(sender: GameSceneButton, _ view: SettingSelectView) {
        selectModels(sender: sender, view, &currentCar, model.createCarsModel())
    }

    func selectObstacle(sender: GameSceneButton, _ view: SettingSelectView) {
        selectModels(sender: sender, view, &currentObstacle, model.createObstaclesModel())
    }

    func edit(sender: UIBarButtonItem) {
        if isEdit {
            sender.title = ConstantsSettingPresenter.editTitle
            saveUser()
        } else {
            sender.title = ConstantsSettingPresenter.saveTitle
        }
        isEdit.toggle()
        view?.userInteractionEnabled(isEdit)
    }

    func selectLevel(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            createSegment(3.0, 4.0, 0)
        case 1:
            createSegment(2.0, 3.0, 1)
        case 2:
            createSegment(1.0, 2.0, 2)
        default:
            break
        }
    }

    func saveUser() {
        var user = model.user
        user.durationObstacle = durationObstacle
        user.durationRoad = durationRoad
        user.segmentLevel = level
        user.carImage = model.createCarsModel()[currentCar]
        user.obstacleImage = model.createObstaclesModel()[currentObstacle]
        user.name = view?.updateProfileName().name
        user.avatar = view?.updateProfileName().avatar

        let data = try? JSONEncoder().encode(user)
        localStorage.save(data, for: "user")
    }

    func loadUserProfile(_ name: inout String?, 
                         _ segment: inout Int,
                         _ car: inout UIImage?,
                         _ obstacle: inout UIImage?,
                         _ profileImage: inout UIImage?) {
        let user = localStorage.fetchValue(type: UserSetting.self, for: "user")
        name = user?.name ?? ""
        segment = user?.segmentLevel ?? 0
        car = UIImage(named: user?.carImage ?? "")
        obstacle = UIImage(named: user?.obstacleImage ?? "")
        profileImage = imageStorage.loadImage(by: user?.avatar ?? "")
    }

    func saveImageFile(_ image: UIImage, _ file: inout String?) {
        file = try? imageStorage.saveImage(image: image)
    }

    private func createSegment(_ road: Double, _ obstacle: Double, _ levelNumber: Int ) {
        durationRoad = road
        durationObstacle = obstacle
        level = levelNumber
    }

    private func selectModels(sender: GameSceneButton, _ view: SettingSelectView, _ current: inout Int, _ model: [String]) {
        switch sender {
        case view.createRightButton():
            if current != model.count - 1  {
                current += 1
            }
        case view.createLeftButton():
            if current > 0 {
                current -= 1
            }
        default:
            break
        }
        self.view?.updateImageSelect(model[current], view)
    }
}
