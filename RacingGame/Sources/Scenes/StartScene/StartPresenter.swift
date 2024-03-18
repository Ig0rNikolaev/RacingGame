//
//  StartPresenter.swift
//  RacingGame
//
//  Created by Игорь Николаев on 18.03.2024.
//

import Foundation

protocol IStartPresenter {
    func userAuthentication() -> Bool
}

final class StartPresenter: IStartPresenter {
    //: MARK: - Propertys
    
    weak var view: IStartView?
    private var localStorage: ILocalStorage

    //: MARK: - Initializers

    init(localStorage: ILocalStorage) {
        self.localStorage = localStorage
    }

    //: MARK: - Setups

    func userAuthentication() -> Bool {
        let isAuth = false
        let user = localStorage.fetchValue(type: UserSetting.self)
        if user?.name == nil {
            view?.showAlert()
        }
        return isAuth
    }
}
