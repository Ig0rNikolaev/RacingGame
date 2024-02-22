//
//  GameplayViewConroller.swift
//  RacingGame
//
//  Created by Игорь Николаев on 20.02.2024.
//

import UIKit
import SnapKit

fileprivate enum GameConstants {
    //: MARK: - Constants

    // Numbers
    static let defaultScore = 0
    static let oneScore = 1
    static let buttonStep: CGFloat = 1
    static let blockInsert = 1
    static let obstacleInsert = 2
    static let roadInsert = 0

    // Strings
    static let placeholder = "Score: 0"
    static let road = "road"
    static let block = "block"

    // TimeIntervals
    static let controlInterval: TimeInterval = 0.003
    static let obstacleInterval: TimeInterval = 1.5
    static let roadInterval: TimeInterval = 0.4
    static let intersectsInterval: TimeInterval = 0.1

    // Animation
    static let controlDuration = 0.0
    static let controlDelay = 0.0
    static let obstacleDuration = 4.0
    static let roadDuration = 3.0
    static let backgroundDelay = 0.3

    // SnapKitConstraints
    static let scoreLeftOffset = 30
    static let widthModel: CGFloat = 50
    static let heightModel: CGFloat = 150
    static let playerLeft: CGFloat = 2
    static let playerBottomOffset = -30
    static let widthButton: CGFloat = 50
    static let heightButton: CGFloat = 50
    static let buttonLeftOffset = 30
    static let buttonRightOffset = -30

    // Frames
    static let blockIntersectX: CGFloat = 0
    static let blockIntersectY: CGFloat = 0
    static let blockWidth: CGFloat = 20
    static let blockHeight: CGFloat = 100
    static let blockY: CGFloat = -100
    static let blockX: CGFloat = 0
    static let roadX: CGFloat = 0
    static let roadY: CGFloat = -100
    static let roadHeight: CGFloat = 100
}

final class GameplayViewConroller: UIViewController {
    //: MARK: - Properties

    var timerCarPlayer: Timer?
    var timerObstacle: Timer?
    var timeRoad: Timer?
    var timeIntersects: Timer?
    var score: Int = GameConstants.defaultScore {
        didSet {
            labelScore.text = "Score: \(score)"
        }
    }

    //: MARK: - UI Elements

    private lazy var labelScore: UILabel = {
        let label = UILabel()
        label.text = GameConstants.placeholder
        label.font = UIFont(name: Constant.Font.formulaRegular, size: Constant.Button.buttonFont)
        label.alpha = Constant.Button.buttonAlpha
        return label
    }()

    private lazy var imageCarPlayer: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: Constant.Image.carOne)
        image.contentMode = .scaleAspectFill
        return image
    }()

    private lazy var buttonLeft: UIButton = {
        let button = GameSceneButton(configurationButton: .left)
        button.addTarget(self, action: #selector(buttonsControll), for: .touchDown)
        button.addTarget(self, action: #selector(stopControll), for: .touchUpInside)
        return button
    }()

    private lazy var buttonRight: UIButton = {
        let button = GameSceneButton(configurationButton: .right)
        button.addTarget(self, action: #selector(buttonsControll), for: .touchDown)
        button.addTarget(self, action: #selector(stopControll), for: .touchUpInside)
        return button
    }()

    //: MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createsObstacle()
        createsRoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        invalidatesTimers()
    }

    //: MARK: - Actions

    @objc
    func buttonsControll(_ sender: UIButton) {
        timerCarPlayer = Timer.scheduledTimer(withTimeInterval: GameConstants.controlInterval, repeats: true, block: { _ in
            UIView.animate(withDuration: GameConstants.controlDuration, delay: GameConstants.controlDelay, options: .curveLinear) {
                switch sender {
                case self.buttonLeft:
                    self.imageCarPlayer.snp.updateConstraints { make in
                        make.left.equalToSuperview().offset(self.imageCarPlayer.frame.minX - GameConstants.buttonStep)
                    }
                case self.buttonRight:
                    self.imageCarPlayer.snp.updateConstraints { make in
                        make.left.equalToSuperview().offset(self.imageCarPlayer.frame.minX + GameConstants.buttonStep)
                    }
                default:
                    break
                }
            }
        })
    }

    @objc
    func stopControll() {
        timerCarPlayer?.invalidate()
    }

    //: MARK: - Setups

    private func createsObstacle() {
        timerObstacle = Timer.scheduledTimer(withTimeInterval: GameConstants.obstacleInterval, repeats: true, block: {  _ in

            let imageObstacle = UIImageView()
            let constant = CGFloat.random(in: self.view.safeAreaInsets.left...self.view.bounds.maxX - GameConstants.widthModel)
            imageObstacle.image = UIImage(named: Constant.Image.carTwo)
            imageObstacle.contentMode = .scaleAspectFill
            imageObstacle.frame = CGRect(x: constant,
                                         y: self.view.frame.origin.y - GameConstants.heightModel,
                                         width: GameConstants.widthModel,
                                         height: GameConstants.heightModel)
            self.view.insertSubview(imageObstacle, at: GameConstants.obstacleInsert)
            self.animationBackground(imageObstacle, GameConstants.obstacleDuration, self.scoresCount)

            let leftBlock = CGRect(x: GameConstants.blockIntersectX, 
                                   y: GameConstants.blockIntersectY,
                                   width: GameConstants.blockWidth,
                                   height: self.view.bounds.height)
            let rightBlock = CGRect(x: self.view.bounds.width - leftBlock.width,
                                    y: GameConstants.blockIntersectY, width: GameConstants.blockWidth,
                                    height: self.view.bounds.height)
            self.intersects(imageObstacle, leftBlock, rightBlock)
        })
    }

    private func createsRoad() {
        timeRoad = Timer.scheduledTimer(withTimeInterval: GameConstants.roadInterval, repeats: true, block: {  _ in

            let imageRoad = UIImageView()
            imageRoad.image = UIImage(named: GameConstants.road)
            imageRoad.frame = CGRect(x: GameConstants.roadX,
                                     y: GameConstants.roadY,
                                     width: self.view.bounds.width,
                                     height: self.view.bounds.height + GameConstants.roadHeight)
            self.view.insertSubview(imageRoad, at: GameConstants.roadInsert)

            let left = self.createsBlock(GameConstants.blockX)
            let _ = self.createsBlock(self.view.bounds.width - left.frame.width)
            self.animationBackground(imageRoad, GameConstants.roadDuration, nil)
        })
    }

    private func createsBlock(_ x: CGFloat) -> UIImageView {
        let imageBlock = UIImageView()
        imageBlock.image = UIImage(named: GameConstants.block)
        imageBlock.contentMode = .scaleAspectFill
        imageBlock.clipsToBounds = true
        imageBlock.frame = CGRect(x: x, 
                                  y: GameConstants.blockY,
                                  width: GameConstants.blockWidth,
                                  height: self.view.bounds.height + GameConstants.blockHeight)
        self.view.insertSubview(imageBlock, at: GameConstants.blockInsert)
        animationBackground(imageBlock, GameConstants.roadDuration, nil)
        return imageBlock
    }

    private func animationBackground(_ imageView: UIImageView, _ duration: TimeInterval, _ score: (() -> Void)?) {
        UIView.animate(withDuration: duration, delay: GameConstants.backgroundDelay, options: .curveLinear) {
            imageView.center.y += self.view.frame.height + GameConstants.heightModel
        } completion: {  _ in
            score?()
            imageView.removeFromSuperview()
        }
    }

    private func intersects(_ imageObstacle: UIImageView, _ leftBlock: CGRect, _ rightBlock: CGRect) {
        timeIntersects = Timer.scheduledTimer(withTimeInterval: GameConstants.intersectsInterval, repeats: true) { [weak self, weak imageObstacle] _ in

            if let imagePlayer = self?.imageCarPlayer.layer.presentation()?.frame, let obstacle = imageObstacle?.layer.presentation()?.frame {
                if imagePlayer.intersects(obstacle) || imagePlayer.intersects(leftBlock) || imagePlayer.intersects(rightBlock) {
                    self?.invalidatesTimers()
                    self?.score = GameConstants.defaultScore
                    self?.view.subviews.forEach { $0.removeFromSuperview() }
                }
            }
        }
    }

    private func invalidatesTimers() {
        self.timerCarPlayer?.invalidate()
        self.timeIntersects?.invalidate()
        self.timerObstacle?.invalidate()
        self.timeRoad?.invalidate()
    }

    private func scoresCount() {
        score += GameConstants.oneScore
    }

    private func setupView() {
        view.backgroundColor = .systemGray
        navigationController?.navigationBar.tintColor = .black
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
            make.height.equalTo(GameConstants.heightButton)
            make.width.equalTo(GameConstants.widthButton)
        }

        buttonRight.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.right.equalToSuperview().offset(GameConstants.buttonRightOffset)
            make.height.equalTo(GameConstants.heightButton)
            make.width.equalTo(GameConstants.widthButton)
        }
    }

    deinit {
        print("GAME DEINIT")
    }
}
