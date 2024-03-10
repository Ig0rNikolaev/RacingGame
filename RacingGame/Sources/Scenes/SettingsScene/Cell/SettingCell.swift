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
    //CGFloat
    static let cellBorderWidth: CGFloat = 1
    static let stackSpacing: CGFloat = 10

    //Constraints
    static let labelLeftOffset = 10
    static let stackRightOffset = -10
    static let stackWidth = 170
    static let stackHeight = 53
}

final class SettingCell: UITableViewCell {

    //: MARK: - Propertys

    static var identifier: String { "\(Self.self)" }
    var indexPath: IndexPath?
    var presenterCell: ISettingPresenter?

    //: MARK: - UI Elements

    private lazy var labelCell: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constant.Font.formulaRegular, size: Constant.Button.buttonFont)
        return label
    }()

    private lazy var buttonLeft: GameSceneButton = {
        let button = GameSceneButton(configurationButton: .left)
        button.addTarget(self, action: #selector(changeIndex), for: .touchUpInside)
        return button
    }()

    private lazy var buttonRight: GameSceneButton = {
        let button = GameSceneButton(configurationButton: .right)
        button.addTarget(self, action: #selector(changeIndex), for: .touchUpInside)
        return button
    }()

    var imageCell: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()

    private lazy var stackCell: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [buttonLeft, imageCell, buttonRight])
        stack.axis = .horizontal
        stack.spacing = ConstantsSettingCell.stackSpacing
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

    //: MARK: - Actions

    @objc
    func changeIndex(_ sender: UIButton) {
        switch sender {
        case buttonLeft:
            presenterCell?.changeLeft()
        case buttonRight:
            presenterCell?.changeRight(indexPath?.section ?? Constant.Default.defaultInt)
        default:
            break
        }
        presenterCell?.updateImageCell(imageCell, indexPath?.section ?? Constant.Default.defaultInt)
    }

    //: MARK: - Setups

    private func setupView() {
        layer.borderWidth = ConstantsSettingCell.cellBorderWidth
        layer.borderColor = UIColor.systemGray5.cgColor
    }

    private func setupHierarchy() {
        contentView.addViews([labelCell, stackCell])
    }

    private func setupLayout() {
        labelCell.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.left.equalTo(ConstantsSettingCell.labelLeftOffset)
        }

        stackCell.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.right.equalTo(ConstantsSettingCell.stackRightOffset)
            make.width.equalTo(ConstantsSettingCell.stackWidth)
            make.height.equalTo(ConstantsSettingCell.stackHeight)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        labelCell.text = nil
        imageCell.image = nil
    }

    func createSettingCell(_ text: String, _ image: String) {
        labelCell.text = text
        imageCell.image = UIImage(named: image)
    }
}
