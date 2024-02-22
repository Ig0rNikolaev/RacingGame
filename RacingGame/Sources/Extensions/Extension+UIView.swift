//
//  Extension+UIView.swift
//  RacingGame
//
//  Created by Игорь Николаев on 20.02.2024.
//

import UIKit

extension UIView {
    func addViews(_ array: [UIView]) {
        array.forEach { addSubview($0) }
    }
}
