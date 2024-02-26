//
//  RecordController.swift
//  RacingGame
//
//  Created by Игорь Николаев on 26.02.2024.
//

import UIKit
import SnapKit

fileprivate enum ConstantsRecord {
    //: MARK: - Constants
    //String
    static let title = "Records"

    //Constraints
    static let topOffset = 5
    static let leftOffset = 20
}

class RecordController: UIViewController {
    //: MARK: - UI Elements

    private lazy var recordLabel: UILabel = {
        let label = UILabel()
        label.text = ConstantsRecord.title
        label.font = UIFont(name: Constant.Font.formulaRegular, size: Constant.Button.buttonFont)
        return label
    }()

    private lazy var recordsTabel: UITableView = {
        let tabel = UITableView(frame: .zero, style: .insetGrouped)
        tabel.register(RecordCell.self, forCellReuseIdentifier: RecordCell.identifier)
        tabel.dataSource = self
        return tabel
    }()

    //: MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
    }

    //: MARK: - Setups

    private func setupView() {
        view.backgroundColor = .systemGray6
    }

    private func setupHierarchy() {
        view.addViews([recordsTabel, recordLabel])
    }

    private func setupLayout() {
        recordsTabel.snp.makeConstraints { make in
            make.top.equalTo(recordLabel.snp.bottom).offset(ConstantsRecord.topOffset)
            make.right.bottom.left.equalToSuperview()
        }

        recordLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(ConstantsRecord.topOffset)
            make.left.equalTo(view.snp.left).offset(ConstantsRecord.leftOffset)
        }
    }
}

extension RecordController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordCell.identifier,
                                                       for: indexPath) as? RecordCell else { return UITableViewCell() }
        cell.createRecordCell(ConstantsRecord.title)
        return cell
    }
}
