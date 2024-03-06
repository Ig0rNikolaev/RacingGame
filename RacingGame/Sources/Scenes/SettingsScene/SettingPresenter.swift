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
    func createSections(_ indexPath: IndexPath) -> SectionSetting
    func createModel(_ indexPath: IndexPath) -> String?
    func changeLeft()
    func changeRight(_ indexPath: IndexPath)
    func updateImageCell(_ imageCell: UIImageView, _ indexPath: IndexPath)
}

final class SettingPresenter: ISettingPresenter {
    private var isEdit = false
    private var current = ConstantsSettingPresenter.currentZero
    var model: ISettingModel
    weak var view: ISettingView?

    init(model: ISettingModel) {
        self.model = model
    }

    func createSections(_ indexPath: IndexPath) -> SectionSetting {
        model.settings[indexPath.section].section
    }

    func edit(sender: UIBarButtonItem) {
        if isEdit {
            sender.title = ConstantsSettingPresenter.editTitle
        } else {
            sender.title = ConstantsSettingPresenter.saveTitle
        }
        isEdit.toggle()
        view?.userInteractionEnabled(isEdit)
    }

    func createModel(_ indexPath: IndexPath) -> String? {
        model.settings[indexPath.section].array[indexPath.row]
    }

    func changeLeft() {
        if current > ConstantsSettingPresenter.currentZero {
            current -= ConstantsSettingPresenter.currentStep
        }
    }

    func changeRight(_ indexPath: IndexPath) {
        if current < model.settings[indexPath.section].array.count - ConstantsSettingPresenter.currentStep {
            current += ConstantsSettingPresenter.currentStep
        }
    }

    func updateImageCell(_ imageCell: UIImageView, _ indexPath: IndexPath) {
        imageCell.image = UIImage(named: model.settings[indexPath.section].array[current])
    }
}
