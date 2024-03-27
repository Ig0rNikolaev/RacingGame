//
//  Extansion+Array.swift
//  RacingGame
//
//  Created by Игорь Николаев on 19.03.2024.
//

import Foundation

extension Array {
    func getsObject(by index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
