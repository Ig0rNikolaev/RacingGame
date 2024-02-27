//
//  SettingController.swift
//  RacingGame
//
//  Created by Игорь Николаев on 26.02.2024.
//

import UIKit
import SnapKit

fileprivate enum ConstantsSetting {
    //: MARK: - Constants

}

final class SettingController: UIViewController {
    //: MARK: - Propertys

    let presenter: SettingPresenterProtocol = SettingPresenter()

    //: MARK: - UI Elements

    private lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "photo.circle.fill")
        image.contentMode = .scaleAspectFill
        image.tintColor = .systemGray3
        image.layer.borderColor = UIColor.systemGray3.cgColor
        image.layer.borderWidth = 1
        image.layer.cornerRadius = 100
        return image
    }()

    private lazy var profileNameText: UITextField = {
        let text = UITextField()
        text.placeholder = "Enter your name"
        text.font = UIFont(name: Constant.Font.formulaRegular, size: 15)
        text.borderStyle = .roundedRect
        return text
    }()

    private lazy var settingsTabel: UITableView = {
        let tabel = UITableView(frame: .zero, style: .insetGrouped)
        tabel.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
        tabel.dataSource = self
        tabel.delegate = self
        return tabel
    }()

    //: MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
        setupNavigationBar()
    }

    //: MARK: - Actions

    @objc
    func settingEdit(sender: UIBarButtonItem) {
        presenter.edit(sender: sender)
    }

    @objc
    func takePhoto() {

    }

    //: MARK: - Setups

    private func createCameraMenu() -> UIMenu {
        let barButtonMenu = UIMenu(title: "Add photo", children: [
            UIAction(title: "Take a photo", image: UIImage(systemName: "camera.viewfinder"), handler: { _ in

            }),
            UIAction(title: "Select photo", image: UIImage(systemName: "photo"), handler: { _ in

            }),
        ])
        return barButtonMenu
    }

    private func setupNavigationBar() {
        let edit = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(settingEdit))
        let camera = UIBarButtonItem(systemItem: .camera, menu: createCameraMenu())
        navigationItem.rightBarButtonItems = [edit, camera]
    }

    private func setupView() {
        view.backgroundColor = .systemGray6
    }

    private func setupHierarchy() {
        view.addViews([profileImage, profileNameText, settingsTabel])
    }

    private func setupLayout() {
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.height.equalTo(200)
            make.centerX.equalToSuperview()
        }

        profileNameText.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }

        settingsTabel.snp.makeConstraints { make in
            make.top.equalTo(profileNameText.snp.bottom).offset(5)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

//: MARK: - Extension

extension SettingController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identifier,
                                                       for: indexPath) as? SettingCell else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
            cell.createSettingCell("Level:")
            return cell
        case 1:
            cell.createSettingCell("Car:")
            return cell
        case 2:
            cell.createSettingCell("Obstacle:")
            return cell
        default:
            cell.createSettingCell("Setting")
            return cell
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
}

extension SettingController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
