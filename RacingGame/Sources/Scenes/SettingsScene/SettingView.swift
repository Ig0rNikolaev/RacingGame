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
    static let easy = "Easy"
    static let medium = "Medium"
    static let hard = "Hard"

    //CGFloat
    static let borderWidthImage: CGFloat = 1
    static let radiusImage: CGFloat = 100
    static let fontSize: CGFloat = 15
    static let stackSpacing: CGFloat = 25

    //Int
    static let segmentIndex = 0

    //Constraints
    static let profileImageSize = 200
    static let stackTop = 25
    static let stackInset = 20
    static let stackHeight = 120
    static let stackSelectHeight = 220
}

protocol ISettingView: AnyObject {
    func userInteractionEnabled(_ isBool: Bool)
    func updateImageSelect(_ image: String, _ view: SettingSelectView)
    func updateProfileName() -> (name: String?, avatar: String?)
}

final class SettingView: UIViewController {

    //: MARK: - Propertys
    
    private var imageFile: String?
    var presenter: ISettingPresenter

    //: MARK: - UI Elements

    private var camera = UIBarButtonItem()

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
        return control
    }()

    private lazy var stackSetting: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImage, profileNameText, difficultyLevelControl])
        stack.axis = .vertical
        stack.spacing = ConstantsSetting.stackSpacing
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
        stack.spacing = ConstantsSetting.stackSpacing
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
        presenter.selectCar(sender: sender, settinCar)
    }

    @objc
    private func selectObstacle(sender: GameSceneButton) {
        presenter.selectObstacle(sender: sender, settinObstacle)
    }

    @objc
    private func settingEdit(sender: UIBarButtonItem) {
        presenter.edit(sender: sender)
    }

    @objc
    private func setsDifficultyLevel(sender: UISegmentedControl) {
        presenter.selectLevel(sender: sender)
    }

    //: MARK: - Setups

    private func loadUserProfile() {
        presenter.loadUserProfile(&profileNameText.text,
                                  &difficultyLevelControl.selectedSegmentIndex,
                                  &settinCar.createImage().image,
                                  &settinObstacle.createImage().image, 
                                  &profileImage.image)
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
            make.top.equalTo(stackSetting.snp.bottom).offset(ConstantsSetting.stackTop)
            make.left.right.equalToSuperview().inset(ConstantsSetting.stackInset)
            make.height.equalTo(ConstantsSetting.stackSelectHeight)
        }
    }
}

//: MARK: - Extensions

extension SettingView: ISettingView {
    func userInteractionEnabled(_ isBool: Bool) {
        camera.isEnabled = isBool
        stackSetting.isUserInteractionEnabled = isBool
        stackSelect.isUserInteractionEnabled = isBool
    }

    func updateImageSelect(_ image: String, _ view: SettingSelectView) {
        view.createImage().image = UIImage(named: image)
    }

    func updateProfileName() -> (name: String?, avatar: String?) {
        (profileNameText.text, imageFile)
    }
}

extension SettingView: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            presenter.saveImageFile(image, &imageFile)
            profileImage.image = image
        }
        dismiss(animated: true)
    }
}
