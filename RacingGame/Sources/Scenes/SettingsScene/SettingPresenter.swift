//
//  SettingPresenter.swift
//  RacingGame
//
//  Created by Игорь Николаев on 27.02.2024.
//

import UIKit

protocol SettingPresenterProtocol {
    func edit(sender: UIBarButtonItem)
}

final class SettingPresenter: SettingPresenterProtocol {
   private var isEdit = true

    func edit(sender: UIBarButtonItem) {
        if isEdit {
            sender.title = "Save"
        } else {
            sender.title = "Edit"
        }
        isEdit.toggle()
    }
}
