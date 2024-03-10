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
    static let easy = "Easy"
    static let medium = "Medium"
    static let hard = "Hard"

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
    func userSave()
}

final class SettingView: UIViewController {

    //: MARK: - Propertys

    var presenter: ISettingPresenter
    var camera = UIBarButtonItem()
    var user = UserSetting()
    let localUser = LocalStorage(userDefaults: .standard)
    let imageLocal = ImageStorage(fileManager: .default)
    var durationRoad: Double = 0
    var durationObstacle: Double = 0
    var level = 0

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
        picker.delegate = self
        return picker
    }()

    private lazy var profileImageCamera: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraDevice = .front
        picker.delegate = self
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
        let control = UISegmentedControl(items: [ConstantsSetting.easy,
                                                 ConstantsSetting.medium,
                                                 ConstantsSetting.hard])
        control.selectedSegmentIndex = ConstantsSetting.segmentIndex
        control.addTarget(self, action: #selector(setsDifficultyLevel), for: .valueChanged)
        control.setTitleTextAttributes([NSAttributedString.Key.font:
                                            UIFont(name: Constant.Font.formulaRegular,
                                                   size: ConstantsSetting.fontSize) ?? UIFont()], for: .normal)
        control.isUserInteractionEnabled = false
        return control
    }()

    private lazy var stackSetting: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImage, profileNameText, difficultyLevelControl])
        stack.axis = .vertical
        stack.spacing = ConstantsSetting.stackSpacing
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var settinCar: SettingSelectView = {
        let view = SettingSelectView(.car)
        return view
    }()

    private lazy var settinObstacle: SettingSelectView = {
        let view = SettingSelectView(.obstacle)
        return view
    }()

    private lazy var stackSelect: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [settinCar, settinObstacle])
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
        loadUserProfile()
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
            durationRoad = 3.0
            durationObstacle = 4.0
            level = 0
        case 1:
            durationRoad = 2.0
            durationObstacle = 3.0
            level = 1
        case 2:
            durationRoad = 1.0
            durationObstacle = 2.0
            level = 2
        default:
            break
        }
        user.durationObstacle = durationObstacle
        user.durationRoad = durationRoad
        user.segmentLevel = level
    }

    //: MARK: - Setups

    private func loadUserProfile() {
        if let data = UserDefaults.standard.data(forKey: "user") {
            let userData = try? JSONDecoder().decode(UserSetting.self, from: data)
            let avatar = imageLocal.loadImage(by: userData?.avatar ?? "")
            profileNameText.text = userData?.name ?? ""
            profileImage.image = avatar
            difficultyLevelControl.selectedSegmentIndex = userData?.segmentLevel ?? 0
        }
    }

    func userSave() {
        user.name = profileNameText.text
        let data = try? JSONEncoder().encode(user)
        localUser.save(data, for: "user")
    }

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

    func createCameraMenus(_ isBool: Bool) -> UIMenu {
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
        camera = UIBarButtonItem(systemItem: .camera, menu: createCameraMenu())
        camera.isEnabled = false
        navigationItem.rightBarButtonItems = [edit, camera]
    }

    private func setupView() {
        view.backgroundColor = .systemGray6
    }

    private func setupHierarchy() {
        view.addViews([profileImage, stackSetting, stackSelect])
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

        stackSelect.snp.makeConstraints { make in
            make.top.equalTo(stackSetting.snp.bottom).offset(25)
            make.left.right.equalToSuperview().inset(ConstantsSetting.stackInset)
            make.height.equalTo(220)
        }
    }
}

//: MARK: - Extensions

extension SettingView: ISettingView {
    func userInteractionEnabled(_ isBool: Bool) {
        profileNameText.isUserInteractionEnabled = isBool
        difficultyLevelControl.isUserInteractionEnabled = isBool
        camera.isEnabled = isBool
    }
}

extension SettingView: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imageFile = try? imageLocal.saveImage(image: image)
            user.avatar = imageFile
            profileImage.image = image
        }
        dismiss(animated: true)
    }
}
