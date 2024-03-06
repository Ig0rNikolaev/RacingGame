//
//  RecordCell.swift
//  RacingGame
//
//  Created by Игорь Николаев on 26.02.2024.
//

import UIKit
import SnapKit

fileprivate enum ConstantsRecordCell {
    //: MARK: - Constants
    //CGFloat
    static let fontSize: CGFloat = 15

    //Constraints
    static let leftOffset = 20
}

final class RecordCell: UITableViewCell {

    //: MARK: - Propertys

    static var identifier: String { "\(Self.self)" }

    //: MARK: - UI Elements

    private lazy var recordLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray6
        label.font = UIFont(name: Constant.Font.formulaRegular, size: ConstantsRecordCell.fontSize)
        return label
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
        contentView.backgroundColor = .black
        contentView.alpha = Constant.Button.buttonAlpha
    }

    private func setupHierarchy() {
        contentView.addSubview(recordLabel)
    }

    private func setupLayout() {
        recordLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(contentView.snp.left).offset(ConstantsRecordCell.leftOffset)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        recordLabel.text = nil
    }

    func createRecordCell(_ text: String) {
         recordLabel.text = text
    }
}
