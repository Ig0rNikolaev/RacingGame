//
//  GameplayAssembly.swift
//  RacingGame
//
//  Created by Игорь Николаев on 17.03.2024.
//

import UIKit

final class GameplayAssembly {
    func build() -> UIViewController {
        let localStorage = LocalStorage(userDefaults: .standard)
        let presenter = GameplayPresenter(localStorage: localStorage)
        let view = GameplayViewController(presenter: presenter)
        presenter.view = view
        return view
    }
}
