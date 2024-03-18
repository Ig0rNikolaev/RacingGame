//
//  StartAssembly.swift
//  RacingGame
//
//  Created by Игорь Николаев on 18.03.2024.
//

import UIKit

final class StartAssembly {
    func builder() -> UIViewController {
        let localStorage = LocalStorage(userDefaults: .standard)
        let presenter = StartPresenter(localStorage: localStorage)
        let view = StartViewController(presenter: presenter)
        presenter.view = view
        return view
    }
}
