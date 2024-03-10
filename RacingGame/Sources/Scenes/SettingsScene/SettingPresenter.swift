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
    func changeLeft()
    func changeRight(_ index: Int)
    func updateImageCell(_ imageCell: UIImageView, _ index: Int)
}

final class SettingPresenter: ISettingPresenter {
    private var isEdit = false
    private var current = ConstantsSettingPresenter.currentZero
    var user: UserSetting?
    var imageStorage = ImageStorage(fileManager: .default)
    weak var view: ISettingView?

    func edit(sender: UIBarButtonItem) {
        if isEdit {
            sender.title = ConstantsSettingPresenter.editTitle
            view?.userSave()
        } else {
            sender.title = ConstantsSettingPresenter.saveTitle
        }
        isEdit.toggle()
        view?.userInteractionEnabled(isEdit)
    }

    func changeLeft() {

    }

    func changeRight(_ index: Int) {

    }

    func updateImageCell(_ imageCell: UIImageView, _ index: Int) {
        imageCell.image = UIImage(named: "car1")
    }
}
