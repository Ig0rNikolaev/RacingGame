//
//  RecordController.swift
//  RacingGame
//
//  Created by Игорь Николаев on 26.02.2024.
//

import UIKit
import SnapKit

fileprivate enum ConstantsRecord {
    static let title = "Records"
    static let topOffset = 5
    static let leftOffset = 20
}

protocol IRecordView: AnyObject {
    func updateRecordTabel()
}

final class RecordController: UIViewController {
    //: MARK: - Properties

    private let presenter: IRecordPresenter

    //: MARK: - UI Elements

    private lazy var recordLabel: UILabel = {
        let label = UILabel()
        label.text = ConstantsRecord.title
        label.font = UIFont(name: Constant.Font.formulaRegular, size: Constant.Font.largeFont)
        return label
    }()

    private lazy var recordsTabel: UITableView = {
        let tabel = UITableView(frame: .zero, style: .insetGrouped)
        tabel.register(RecordCell.self, forCellReuseIdentifier: RecordCell.identifier)
        tabel.separatorColor = .systemGray6
        tabel.dataSource = self
        return tabel
    }()

    //: MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
        updateRecords()
    }

    //: MARK: - Initializers

    init(presenter: IRecordPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    //: MARK: - Setups

    private func updateRecords() {
        presenter.updateRecords()
    }

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

//: MARK: - Extension

extension RecordController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.arrayRecords().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordCell.identifier,
                                                       for: indexPath) as? RecordCell else { return UITableViewCell() }
        cell.createRecordCell("\(presenter.arrayRecords()[indexPath.row])")
        return cell
    }
}

extension RecordController: IRecordView {
    func updateRecordTabel() {
        recordsTabel.reloadData()
    }
}
