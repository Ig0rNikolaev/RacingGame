//
//  RecordCell.swift
//  RacingGame
//
//  Created by Игорь Николаев on 26.02.2024.
//

import UIKit
import SnapKit

fileprivate enum ConstantsCell {
    static let leftOffset = 20
    static let identifier = "\(Self.self)"
}

final class RecordCell: UITableViewCell {
    //: MARK: - Propertys

    static var identifier: String { ConstantsCell.identifier }

    //: MARK: - UI Elements

    private lazy var recordLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray6
        label.font = UIFont(name: Constant.Font.formulaRegular, size: Constant.Font.smallFont)
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

    override func prepareForReuse() {
        super.prepareForReuse()
        recordLabel.text = nil
    }

    func createRecordCell(_ text: String) {
        recordLabel.text = text
    }

    private func setupView() {
        contentView.backgroundColor = .black
        contentView.alpha = Constant.Default.gameAlpha
    }

    private func setupHierarchy() {
        contentView.addSubview(recordLabel)
    }

    private func setupLayout() {
        recordLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(contentView.snp.left).offset(ConstantsCell.leftOffset)
        }
    }
}
