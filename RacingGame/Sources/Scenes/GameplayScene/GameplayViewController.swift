//
//  GameplayViewController.swift
//  RacingGame
//
//  Created by Игорь Николаев on 20.02.2024.
//

import UIKit
import SnapKit

private extension String {
    static let score = "Score: "
    static let roadImage = "road"
    static let blockImage = "block"
    static let gameOver = "Game Over"
    static let obstacleImageDefault = ""
    static let carImageDefault = ""
}

private extension TimeInterval {
    static let controlInterval: TimeInterval = 0.003
    static let obstacleInterval: TimeInterval = 1.5
    static let roadInterval: TimeInterval = 0.4
    static let intersectsInterval: TimeInterval = 0.1
}

private extension Double {
    static let controlAnimation = 0.0
    static let backgroundDelay = 0.3
}

private extension Int {
    static let defaultScore = 0
    static let stepScore = 1
    static let sideBlockInsert = 1
    static let obstacleInsert = 2
    static let roadInsert = 0
}

private extension CGFloat {
    static let blockIntersect: CGFloat = 0
    static let blockWidth: CGFloat = 20
    static let blockHeight: CGFloat = 70
    static let roadHeight: CGFloat = 100
    static let coordinateY: CGFloat = -100
    static let coordinateX: CGFloat = 0
}

fileprivate enum GameConstants {
    static let playerLeft: CGFloat = 2
    static let playerBottomOffset = -30
    static let widthModel: CGFloat = 50
    static let heightModel: CGFloat = 150
    static let buttonSize = 50
    static let buttonLeftOffset = 30
    static let buttonRightOffset = -30
    static let scoreLeftOffset = 30
}

protocol IGameplayView: AnyObject {
    func transmitsGameplaySettings(_ user: UserSetting?)
    func buttonsControll(_ sender: UIButton)
}

final class GameplayViewController: UIViewController {
    //: MARK: - Properties

    let presenter: IGameplayPresenter
    private let timer = TimerCustom()
    private let gameplayCustom = GameplayCustom(roadDuration: Constant.Duration.roadDurationEasy,
                                                obstacleDuration: Constant.Duration.obstacleDurationEasy,
                                                obstacleCar: .obstacleImageDefault,
                                                score: .defaultScore)

    //: MARK: - UI Elements

    private lazy var labelScore: UILabel = {
        let label = UILabel()
        label.text = "\(String.score)\(gameplayCustom.score)"
        label.font = UIFont(name: Constant.Font.formulaRegular, size: Constant.Font.largeFont)
        label.alpha = Constant.Default.gameAlpha
        return label
    }()

    private lazy var gameOverLabel: UILabel = {
        let label = UILabel()
        label.text = .gameOver
        label.font = UIFont(name: Constant.Font.formulaRegular, size: Constant.Font.largeFont)
        return label
    }()

    private lazy var imageCarPlayer: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()

    private lazy var buttonLeft: GameSceneButton = {
        let button = GameSceneButton(configurationButton: .left)
        button.addTarget(self, action: #selector(buttonsControll), for: .touchDown)
        button.addTarget(self, action: #selector(stopButtonsControll), for: .touchUpInside)
        return button
    }()

    private lazy var buttonRight: GameSceneButton = {
        let button = GameSceneButton(configurationButton: .right)
        button.addTarget(self, action: #selector(buttonsControll), for: .touchDown)
        button.addTarget(self, action: #selector(stopButtonsControll), for: .touchUpInside)
        return button
    }()

    //: MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
        changesGameplaySettings()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createsObstacles()
        createRoadWithSideBlocks()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        invalidatesTimers()
    }

    //: MARK: - Initializers

    init(presenter: IGameplayPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    //: MARK: - Actions

    @objc
    func buttonsControll(_ sender: UIButton) {
        timer.timerCarPlayer = Timer.scheduledTimer(withTimeInterval: .controlInterval,
                                                    repeats: true,
                                                    block: { _ in
            UIView.animate(withDuration: .controlAnimation,
                           delay: .controlAnimation,
                           options: .curveLinear) {
                self.presenter.gameControl(sender,
                                           self.imageCarPlayer,
                                           self.buttonLeft,
                                           self.buttonRight)
            }
        })
    }

    @objc
    func stopButtonsControll() {
        timer.timerCarPlayer?.invalidate()
    }

    //: MARK: - Setups

    private func setupObstacleView() -> UIImageView {
        let constant = CGFloat.random(in: self.view.safeAreaInsets.left...self.view.bounds.maxX - GameConstants.widthModel)
        let imageObstacle = UIImageView()
        imageObstacle.image = UIImage(named: gameplayCustom.obstacle)
        imageObstacle.contentMode = .scaleAspectFill
        imageObstacle.frame = CGRect(x: constant,
                                     y: self.view.frame.origin.y - GameConstants.heightModel,
                                     width: GameConstants.widthModel,
                                     height: GameConstants.heightModel)
        self.view.insertSubview(imageObstacle, at: .obstacleInsert)
        return imageObstacle
    }

    private func setupsRoadView() -> UIImageView {
        let imageRoad = UIImageView()
        imageRoad.image = UIImage(named: .roadImage)
        imageRoad.frame = CGRect(x: .coordinateX,
                                 y: .coordinateY,
                                 width: self.view.bounds.width,
                                 height: self.view.bounds.height + .roadHeight)
        self.view.insertSubview(imageRoad, at: .roadInsert)
        return imageRoad
    }

    private func setupsSideBlock(_ coordinateX: CGFloat) -> UIImageView {
        let imageBlock = UIImageView()
        imageBlock.image = UIImage(named: .blockImage)
        imageBlock.contentMode = .scaleAspectFill
        imageBlock.clipsToBounds = true
        imageBlock.frame = CGRect(x: coordinateX,
                                  y: .coordinateY,
                                  width: .blockWidth,
                                  height: .blockHeight)
        self.view.insertSubview(imageBlock, at: .sideBlockInsert)
        setupGameplayAnimation(imageBlock, Constant.Duration.roadDurationEasy, nil)
        return imageBlock
    }

    func setsLocationSideBlocks() -> (leftBlock: CGRect, rightBlock: CGRect) {
        let leftBlock = CGRect(x: .blockIntersect,
                               y: .blockIntersect,
                               width: .blockWidth,
                               height: self.view.bounds.height)
        let rightBlock = CGRect(x: self.view.bounds.width - leftBlock.width,
                                y: .blockIntersect, width: .blockWidth,
                                height: self.view.bounds.height)
        return (leftBlock, rightBlock)
    }

    private func createsObstacles() {
        timer.timerObstacle = Timer.scheduledTimer(withTimeInterval: .obstacleInterval, 
                                                   repeats: true,
                                                   block: {  _ in
            let imageObstacle = self.setupObstacleView()
            let blocks = self.setsLocationSideBlocks()
            self.setupGameplayAnimation(imageObstacle, 
                                        self.gameplayCustom.obstacleDuration,
                                        self.updatesСounter)
            self.setupIntersects(imageObstacle, 
                                 blocks.leftBlock,
                                 blocks.rightBlock)
        })
    }

    private func createRoadWithSideBlocks() {
        timer.timeRoad = Timer.scheduledTimer(withTimeInterval: .roadInterval, 
                                              repeats: true,
                                              block: {  _ in
            let imageRoad = self.setupsRoadView()
            let left = self.setupsSideBlock(.coordinateX)
            let _ = self.setupsSideBlock(self.view.bounds.width - left.frame.width)
            self.setupGameplayAnimation(imageRoad, self.gameplayCustom.roadDuration, nil)
        })
    }

    private func setupGameplayAnimation(_ imageView: UIImageView, 
                                        _ duration: TimeInterval,
                                        _ score: (() -> Void)?) {
        UIView.animate(withDuration: duration, 
                       delay: .backgroundDelay,
                       options: .curveLinear) {
            imageView.center.y += self.view.frame.height + GameConstants.heightModel
        } completion: {  _ in
            score?()
            imageView.removeFromSuperview()
        }
    }

    private func setupGameOverView() {
        view.addSubview(gameOverLabel)
        gameOverLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    private func invalidatesTimers() {
        let _ = [self.timer.timerCarPlayer,
                 self.timer.timeIntersects,
                 self.timer.timerObstacle,
                 self.timer.timeRoad].map { $0?.invalidate() }
    }

    private func updatesСounter() {
        gameplayCustom.score += .stepScore
        labelScore.text = "\(String.score)\(gameplayCustom.score)"
    }

    private func updateGameScore() {
        presenter.update(score: gameplayCustom.score)
    }

    func changesGameplaySettings() {
        presenter.changeGameplaySetting()
    }

    private func setupIntersects(_ imageObstacle: UIImageView, 
                                 _ leftBlock: CGRect,
                                 _ rightBlock: CGRect) {
        timer.timeIntersects = Timer.scheduledTimer(withTimeInterval: .intersectsInterval,
                                                    repeats: true) { [weak self, weak imageObstacle] _ in
            if let imagePlayer = self?.imageCarPlayer.layer.presentation()?.frame, 
                let obstacle = imageObstacle?.layer.presentation()?.frame {
                if imagePlayer.intersects(obstacle) || imagePlayer.intersects(leftBlock) || imagePlayer.intersects(rightBlock) {
                    self?.invalidatesTimers()
                    self?.updateGameScore()
                    self?.view.subviews.forEach { $0.removeFromSuperview() }
                    self?.setupGameOverView()
                }
            }
        }
    }

    private func setupView() {
        view.backgroundColor = .systemGray6
    }

    private func setupHierarchy() {
        let views = [labelScore, buttonLeft, buttonRight, imageCarPlayer]
        view.addViews(views)
    }

    private func setupLayout() {
        labelScore.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview().offset(GameConstants.scoreLeftOffset)
        }

        imageCarPlayer.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(GameConstants.playerBottomOffset)
            make.width.equalTo(GameConstants.widthModel)
            make.height.equalTo(GameConstants.heightModel)
            make.left.equalToSuperview().offset((view.bounds.width - GameConstants.widthModel) / GameConstants.playerLeft)
        }

        buttonLeft.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalToSuperview().offset(GameConstants.buttonLeftOffset)
            make.height.equalTo(GameConstants.buttonSize)
            make.width.equalTo(GameConstants.buttonSize)
        }

        buttonRight.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.right.equalToSuperview().offset(GameConstants.buttonRightOffset)
            make.height.equalTo(GameConstants.buttonSize)
            make.width.equalTo(GameConstants.buttonSize)
        }
    }

    deinit {
        print("GAME DEINIT")
    }
}

//: MARK: - Extensions

extension GameplayViewController: IGameplayView {
    func transmitsGameplaySettings(_ user: UserSetting?) {
        gameplayCustom.roadDuration = user?.durationRoad ?? Constant.Duration.roadDurationEasy
        gameplayCustom.obstacleDuration = user?.durationObstacle ?? Constant.Duration.obstacleDurationEasy
        gameplayCustom.obstacle = user?.obstacleImage ?? .obstacleImageDefault
        imageCarPlayer.image = UIImage(named: user?.carImage ?? .carImageDefault)
    }
}
