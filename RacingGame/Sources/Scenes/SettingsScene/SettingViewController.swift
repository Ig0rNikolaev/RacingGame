//
//  SettingView.swift
//  RacingGame
//
//  Created by Игорь Николаев on 26.02.2024.
//

import UIKit
import SnapKit

private extension Int {
    static let segmentIndex = 0
    static let currentCarDefault = 0
    static let currentObstacleDefault = 0
}

private extension CGFloat {
    static let radiusImage: CGFloat = 100
    static let stackSpacing: CGFloat = 25
}

private extension String {
    static let userNameDefault = ""
    static let easy = "Easy"
    static let hard = "Hard"
    static let medium = "Medium"
    static let titleEdit = "Edit"
    static let titleMenu = "Add photo"
    static let imageActionSelect = "photo"
    static let titleActionTake = "Take a photo"
    static let proxyImage = "photo.circle.fill"
    static let titleActionSelect = "Select photo"
    static let placeholderName = "Enter your name"
    static let imageActionTake = "camera.viewfinder"
}

fileprivate enum ConstantsSetting {
    static let stackTop = 25
    static let stackInset = 20
    static let stackHeight = 120
    static let stackSelectHeight = 220
    static let profileImageSize = 200
}

protocol ISettingView: AnyObject {
    func userInteractionEnabled(_ isEnabled: Bool)
    func preparesLoad(user: UserSetting, _ image: UIImage)
    func updateImageSelect(_ image: String, _ view: SettingSelectView)
    func preparesSave(user: inout UserSetting,
                      _ imageStorage: IImageStorage,
                      _ records: [Int]?)
}

final class SettingViewController: UIViewController {
    //: MARK: - Propertys

    private var presenter: ISettingPresenter
    var setting = Settings(roadDuration: Constant.Duration.roadDurationEasy,
                           obstacleDuration: Constant.Duration.obstacleDurationEasy,
                           isEdit: false,
                           currentCar: .currentCarDefault,
                           currentObstacle: .currentObstacleDefault)

    //: MARK: - UI Elements

    private var camera = UIBarButtonItem()

    private lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "proxy")
        image.tintColor = .systemGray4
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.borderColor = UIColor.systemGray3.cgColor
        image.layer.borderWidth = Constant.Default.borderWidth
        image.layer.cornerRadius = .radiusImage
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
        text.placeholder = .placeholderName
        text.font = UIFont(name: Constant.Font.formulaRegular, size: Constant.Font.smallFont)
        text.borderStyle = .roundedRect
        return text
    }()

    private lazy var difficultyLevelControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [String.easy, .medium, .hard])
        control.selectedSegmentIndex = .segmentIndex
        control.addTarget(self, action: #selector(setsDifficultyLevel), for: .valueChanged)
        control.setTitleTextAttributes([NSAttributedString.Key.font:
                                            UIFont(name: Constant.Font.formulaRegular,
                                                   size: Constant.Font.smallFont) ?? UIFont()], for: .normal)
        return control
    }()

    private lazy var stackSetting: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImage, profileNameText, difficultyLevelControl])
        stack.axis = .vertical
        stack.spacing = .stackSpacing
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.isUserInteractionEnabled = false
        return stack
    }()

    private lazy var settinCar: SettingSelectView = {
        let view = SettingSelectView(.car)
        view.createButtonAction(action: #selector(selectCar), event: .touchUpInside)
        return view
    }()

    private lazy var settinObstacle: SettingSelectView = {
        let view = SettingSelectView(.obstacle)
        view.createButtonAction(action: #selector(selectObstacle), event: .touchUpInside)
        return view
    }()

    private lazy var stackSelect: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [settinCar, settinObstacle])
        stack.axis = .vertical
        stack.spacing = .stackSpacing
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.isUserInteractionEnabled = false
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
    private func selectCar(sender: GameSceneButton) {
        presenter.selectCar(by: setting, sender, settinCar)
    }

    @objc
    private func selectObstacle(sender: GameSceneButton) {
        presenter.selectObstacle(by: setting, sender, settinObstacle)
    }

    @objc
    private func settingEdit(sender: UIBarButtonItem) {
        presenter.controlsEditing(by: setting, sender)
    }

    @objc
    private func setsDifficultyLevel(sender: UISegmentedControl) {
        presenter.setsDifficultyLevel(sender: sender, setting)
    }

    //: MARK: - Setups

    private func loadUserProfile() {
        presenter.loadUserProfile()
    }

    private func createCameraMenu() -> UIMenu {
        let barButtonMenu = UIMenu(title: .titleMenu, children: [
            UIAction(title: .titleActionTake,
                     image: UIImage(systemName: .imageActionTake),
                     handler: { [weak self] _ in
                         self?.present(self?.profileImageCamera ?? UIImagePickerController(), animated: true)
                     }),
            UIAction(title: .titleActionSelect,
                     image: UIImage(systemName: .imageActionSelect),
                     handler: { [weak self] _ in
                         self?.present(self?.profileImageLibrary ?? UIImagePickerController(), animated: true)
                     }),
        ])
        return barButtonMenu
    }

    private func setupNavigationBar() {
        let edit = UIBarButtonItem(title: .titleEdit,
                                   style: .plain,
                                   target: self,
                                   action: #selector(settingEdit))
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
            make.top.equalTo(stackSetting.snp.bottom).offset(ConstantsSetting.stackTop)
            make.left.right.equalToSuperview().inset(ConstantsSetting.stackInset)
            make.height.equalTo(ConstantsSetting.stackSelectHeight)
        }
    }
}

//: MARK: - Extensions

extension SettingViewController: ISettingView {
    func userInteractionEnabled(_ isEnabled: Bool) {
        camera.isEnabled = isEnabled
        self.navigationItem.hidesBackButton = isEnabled
        stackSelect.isUserInteractionEnabled = isEnabled
        stackSetting.isUserInteractionEnabled = isEnabled
    }

    func preparesSave(user: inout UserSetting,
                      _ imageStorage: IImageStorage,
                      _ records: [Int]?) {
        user.name = profileNameText.text
        user.durationRoad = setting.roadDuration
        user.carImage = settinCar.baseModel.imageCar
        user.durationObstacle = setting.obstacleDuration
        user.obstacleImage = settinObstacle.baseModel.imageObstacle
        user.segmentLevel = difficultyLevelControl.selectedSegmentIndex
        user.avatar = try? imageStorage.saveImage(image: profileImage.image ?? UIImage())
        if let recordUpdate = records {
            user.records = recordUpdate
        }
    }

    func preparesLoad(user: UserSetting, _ image: UIImage) {
        profileNameText.text = user.name ?? .userNameDefault
        setting.roadDuration = user.durationRoad ?? Constant.Duration.roadDurationZero
        setting.obstacleDuration = user.durationObstacle ?? Constant.Duration.obstacleDurationZero
        settinCar.baseModel.imageCar = user.carImage ?? Constant.Image.carOne
        settinObstacle.baseModel.imageObstacle = user.obstacleImage ?? Constant.Image.carTwo
        difficultyLevelControl.selectedSegmentIndex = user.segmentLevel ?? .segmentIndex
        settinCar.imageSetting.image = UIImage(named: settinCar.baseModel.imageCar)
        settinObstacle.imageSetting.image = UIImage(named: settinObstacle.baseModel.imageObstacle)
        profileImage.image = image
    }

    func updateImageSelect(_ image: String, _ view: SettingSelectView) {
        view.imageSetting.image = UIImage(named: image)
        view.baseModel.imageCar = image
        view.baseModel.imageObstacle = image
    }
}

extension SettingViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.image = image
        }
        dismiss(animated: true)
    }
}
