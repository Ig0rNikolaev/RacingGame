//
//  SettingCell.swift
//  RacingGame
//
//  Created by Игорь Николаев on 27.02.2024.
//

import UIKit
import SnapKit

fileprivate enum ConstantsSettingCell {
    //: MARK: - Constants
    //String
    static let identifier = "SettingCell"

    //CGFloat


    //Constraints

}

final class SettingCell: UITableViewCell {

    //: MARK: - Propertys

    static let identifier = ConstantsSettingCell.identifier

    //: MARK: - UI Elements

    private lazy var labelCell: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constant.Font.formulaRegular, size: Constant.Button.buttonFont)
        return label
    }()

    private lazy var buttonLeft: GameSceneButton = {
        let button = GameSceneButton(configurationButton: .left)
        return button
    }()

    private lazy var buttonRight: GameSceneButton = {
        let button = GameSceneButton(configurationButton: .right)
        return button
    }()

    private lazy var imageCell: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person")
        image.contentMode = .scaleAspectFill
        return image
    }()

    private lazy var stackCell: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [buttonLeft, imageCell, buttonRight])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()

    //: MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupLayout()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    //: MARK: - Setups

    private func setupView() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
    }

    private func setupHierarchy() {
        contentView.addViews([labelCell, stackCell])
    }

    private func setupLayout() {
        labelCell.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.left.equalTo(10)
        }

        stackCell.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.right.equalTo(-10)
            make.width.equalTo(170)
            make.height.equalTo(53)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

    }

    func createSettingCell(_ text: String) {
        labelCell.text = text
    }
}
