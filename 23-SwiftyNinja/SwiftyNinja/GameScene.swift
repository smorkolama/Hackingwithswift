//
//  GameScene.swift
//  SwiftyNinja
//
//  Created by Benjamin van den Hout on 04/05/2020.
//  Copyright © 2020 Benjamin van den Hout. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    var livesImages = [SKSpriteNode]()
    var lives = 3
    var activeSlicePoints = [CGPoint]()
    var isSwooshSoundActive = false

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)

        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85

        createScore()
        createLives()
        createSlices()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        // remove all existing points
        activeSlicePoints.removeAll(keepingCapacity: true)

        // get touch location and append to array
        let location = touch.location(in: self)
        activeSlicePoints.append(location)

        // clear slice shapes
        redrawActiveSlice()

        // remove actions currently attached to slice shapes (fading etc)
        activeSliceBG.removeAllActions()
        activeSliceFG.removeAllActions()

        // set slice shapes to have alpha 1
        activeSliceBG.alpha = 1
        activeSliceFG.alpha = 1
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        redrawActiveSlice()

        if !isSwooshSoundActive {
            playSwooshSound()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

    func createScore() {
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)

        gameScore.position = CGPoint(x: 8, y: 8)
        score = 0
    }

    func createLives() {
        for i in 0 ..< 3 {
            let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
            spriteNode.position = CGPoint(x: CGFloat(834 + (i * 70)), y: 720)
            addChild(spriteNode)
            livesImages.append(spriteNode)
        }
    }

    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!

    func createSlices() {
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2

        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 3

        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceBG.lineWidth = 9

        activeSliceFG.strokeColor = UIColor.white
        activeSliceFG.lineWidth = 5

        addChild(activeSliceBG)
        addChild(activeSliceFG)
    }

    func redrawActiveSlice() {
        // if < 2 points clear the shapes and exit
        if activeSlicePoints.count < 2 {
            activeSliceBG.path = nil
            activeSliceFG.path = nil
        }

        // if > 12 points trim the oldest ones
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
        }

        // start line at first point and add other points
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])

        for i in 1 ..< activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }

        // update slice shape path
        activeSliceBG.path = path.cgPath
        activeSliceFG.path = path.cgPath
    }

    func playSwooshSound() {
        isSwooshSoundActive = true

        let randomNumber = Int.random(in: 1...3)
        let soundName = "swoosh\(randomNumber).caf"

        let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)

        run(swooshSound) { [weak self] in
            self?.isSwooshSoundActive = false
        }
    }
}
