//
//  SettingView.swift
//  RacingGame
//
//  Created by Игорь Николаев on 26.02.2024.
//

import UIKit
import SnapKit

fileprivate enum ConstantsSetting {
    //: MARK: - Constants
    static let levelArray = ["Easy", "Medium", "Hard"]

    //String
    static let proxyImage = "photo.circle.fill"
    static let placeholderName = "Enter your name"
    static let titleMenu = "Add photo"
    static let titleActionTake = "Take a photo"
    static let titleActionSelect = "Select photo"
    static let imageActionTake = "camera.viewfinder"
    static let imageActionSelect = "photo"
    static let titleEdit = "Edit"
    static let sectionCar = "Car: "
    static let sectionObstacle = "Obstacle: "

    //CGFloat
    static let borderWidthImage: CGFloat = 1
    static let radiusImage: CGFloat = 100
    static let fontSize: CGFloat = 15
    static let cellHeight: CGFloat = 90
    static let stackSpacing: CGFloat = 25

    //Int
    static let segmentIndex = 0
    static let numberOfSections = 2
    static let numberOfRowsInSection = 1

    //Constraints
    static let profileImageSize = 200
    static let stackTop = 20
    static let stackInset = 20
    static let stackHeight = 120
    static let tabelTop = 0
}

protocol ISettingView: AnyObject {
    func userInteractionEnabled(_ isBool: Bool)
}

final class SettingView: UIViewController {

    //: MARK: - Propertys

    var presenter: ISettingPresenter

    //: MARK: - UI Elements

    private lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: ConstantsSetting.proxyImage)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.tintColor = .systemGray4
        image.layer.borderColor = UIColor.systemGray3.cgColor
        image.layer.borderWidth = ConstantsSetting.borderWidthImage
        image.layer.cornerRadius = ConstantsSetting.radiusImage
        return image
    }()

    private lazy var profileImageLibrary: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        return picker
    }()

    private lazy var profileImageCamera: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraDevice = .front
        return picker
    }()

    private lazy var profileNameText: UITextField = {
        let text = UITextField()
        text.placeholder = ConstantsSetting.placeholderName
        text.font = UIFont(name: Constant.Font.formulaRegular, size: ConstantsSetting.fontSize)
        text.isUserInteractionEnabled = false
        text.borderStyle = .roundedRect
        return text
    }()

    private lazy var difficultyLevelControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ConstantsSetting.levelArray)
        control.selectedSegmentIndex = ConstantsSetting.segmentIndex
        control.addTarget(self, action: #selector(setsDifficultyLevel), for: .valueChanged)
        control.setTitleTextAttributes([NSAttributedString.Key.font:
                                            UIFont(name: Constant.Font.formulaRegular, size: ConstantsSetting.fontSize) ?? UIFont()],
                                       for: .normal)
        control.isUserInteractionEnabled = false
        return control
    }()

    private lazy var settingsTabel: UITableView = {
        let tabel = UITableView(frame: .zero, style: .insetGrouped)
        tabel.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
        tabel.dataSource = self
        tabel.delegate = self
        tabel.isUserInteractionEnabled = false
        return tabel
    }()

    private lazy var stackSetting: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImage, profileNameText, difficultyLevelControl, settingsTabel])
        stack.axis = .vertical
        stack.spacing = ConstantsSetting.stackSpacing
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()

    //: MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
        setupNavigationBar()
        imagePickerDelegate()
    }

    //: MARK: - Initializers

    init(presenter: ISettingPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    //: MARK: - Actions

    @objc
    private func settingEdit(sender: UIBarButtonItem) {
        presenter.edit(sender: sender)
    }

    @objc
    private func setsDifficultyLevel(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: 
            print("Zero")
        case 1: 
            print("One")
        case 2: 
            print("Two")
        default: 
            break
        }
    }

    //: MARK: - Setups

    private func createCameraMenu() -> UIMenu {
        let barButtonMenu = UIMenu(title: ConstantsSetting.titleMenu, children: [
            UIAction(title: ConstantsSetting.titleActionTake, image: UIImage(systemName: ConstantsSetting.imageActionTake), handler: { _ in
                self.present(self.profileImageCamera, animated: true)
            }),
            UIAction(title: ConstantsSetting.titleActionSelect, image: UIImage(systemName: ConstantsSetting.imageActionSelect), handler: { _ in
                self.present(self.profileImageLibrary, animated: true)
            }),
        ])
        return barButtonMenu
    }

    private func setupNavigationBar() {
        let edit = UIBarButtonItem(title: ConstantsSetting.titleEdit, style: .plain, target: self, action: #selector(settingEdit))
        let camera = UIBarButtonItem(systemItem: .camera, menu: createCameraMenu())
        navigationItem.rightBarButtonItems = [edit, camera]
    }

    private func imagePickerDelegate() {
        profileImageLibrary.delegate = self
        profileImageCamera.delegate = self
    }

    private func setupView() {
        view.backgroundColor = .systemGray6
    }

    private func setupHierarchy() {
        view.addViews([profileImage, stackSetting, settingsTabel])
    }

    private func setupLayout() {
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.height.equalTo(ConstantsSetting.profileImageSize)
            make.centerX.equalToSuperview()
        }

        stackSetting.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(ConstantsSetting.stackTop)
            make.left.right.equalToSuperview().inset(ConstantsSetting.stackInset)
            make.height.equalTo(ConstantsSetting.stackHeight)
        }

        settingsTabel.snp.makeConstraints { make in
            make.top.equalTo(difficultyLevelControl.snp.bottom).offset(ConstantsSetting.tabelTop)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

//: MARK: - Extensions

extension SettingView: ISettingView {
    func userInteractionEnabled(_ isBool: Bool) {
        profileNameText.isUserInteractionEnabled = isBool
        settingsTabel.isUserInteractionEnabled = isBool
        difficultyLevelControl.isUserInteractionEnabled = isBool
    }
}

extension SettingView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ConstantsSetting.numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identifier,
                                                       for: indexPath) as? SettingCell else { return UITableViewCell() }
        cell.presenterCell = presenter
        cell.indexPath = indexPath
        switch presenter.createModel()[indexPath.section].section {
        case .car:
            cell.createSettingCell(ConstantsSetting.sectionCar, presenter.createModel()[indexPath.section].array[indexPath.row])
            return cell
        case .obstacle:
            cell.createSettingCell(ConstantsSetting.sectionObstacle, presenter.createModel()[indexPath.section].array[indexPath.row])
            return cell
        }
    }
}

extension SettingView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ConstantsSetting.cellHeight
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        ConstantsSetting.numberOfSections
    }
}

extension SettingView: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.image = image
        }
        dismiss(animated: true)
    }
}
