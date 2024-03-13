//
//  RecordAssembly.swift
//  RacingGame
//
//  Created by Игорь Николаев on 17.03.2024.
//

import UIKit

final class RecordAssembly {
    func build() -> UIViewController {
        let localStorage = LocalStorage(userDefaults: .standard)
        let presenter = RecordPresenter(localStorage: localStorage)
        let view = RecordController(presenter: presenter)
        return view
    }
}
