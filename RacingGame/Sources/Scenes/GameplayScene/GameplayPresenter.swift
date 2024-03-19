//
//  GameplayPresenter.swift
//  RacingGame
//
//  Created by Игорь Николаев on 17.03.2024.
//

import Foundation
import UIKit

private extension CGFloat {
    static let step: CGFloat = 1
}

protocol IGameplayPresenter {
    func update(score: Int)
    func changeGameplaySetting()
    func gameControl(_ sender: UIButton,
                     _ carImage: UIImageView,
                     _ left: GameSceneButton,
                     _ right: GameSceneButton)
}

final class GameplayPresenter: IGameplayPresenter {
    //: MARK: - Properties

    private let localStorage: ILocalStorage
    weak var view: IGameplayView?

    //: MARK: - Initializers

    init(localStorage: ILocalStorage) {
        self.localStorage = localStorage
    }

    //: MARK: - Setups

    func changeGameplaySetting() {
        let user = localStorage.fetchValue(type: UserSetting.self)
        view?.transmitsGameplaySettings(from: user)
    }

    func update(score: Int) {
        var user = localStorage.fetchValue(type: UserSetting.self)
        if var records = user?.records {
            if records.count == 10 {
                records.removeLast()
            }
            records.append(score)
            user?.records = records
        } else {
            user?.records = [score]
        }
        localStorage.save(user)
    }

    func gameControl(_ sender: UIButton, 
                     _ carImage: UIImageView,
                     _ left: GameSceneButton,
                     _ right: GameSceneButton) {
        switch sender {
        case left:
            carImage.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(carImage.frame.minX - .step)
            }
        case right:
            carImage.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(carImage.frame.minX + .step)
            }
        default:
            break
        }
    }
}
