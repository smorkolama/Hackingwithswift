//
//  GameScene.swift
//  SpaceRace
//
//  Created by Benjamin van den Hout on 18/12/2019.
//  Copyright © 2019 NGTI. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!

    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    let possibleEnemies = ["ball", "hammer", "tv"]
    var isGameOver = false
    var gameTimer: Timer?

    override func didMove(to view: SKView) {
        backgroundColor = .black

        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384) // right side of the screen, center
        starfield.advanceSimulationTime(10) // fill screen with stars
        addChild(starfield)
        starfield.zPosition = -1

        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size) // don't use box/circle, use per-pixel collision
        player.physicsBody?.contactTestBitMask = 1 // will match space debris test mask
        addChild(player)

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)

        score = 0

        // disable gravity
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self

        // create enemy timer
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        var location = touch.location(in: self)

        // clamp position to not overlap score label and be symmetric on both sides of the screen
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }

        player.position = location;
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        player.removeFromParent()
        isGameOver = true
    }

    @objc func createEnemy() {
        guard let enemy = possibleEnemies.randomElement() else { return }

        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736)) // create off-screen
        addChild(sprite)

        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size) // match to per-pixel image
        sprite.physicsBody?.categoryBitMask = 1 // same as space ship
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0) // move to the left
        sprite.physicsBody?.angularVelocity = 5 // rotating, curve
        sprite.physicsBody?.linearDamping = 0 // deacceleration, disable
        sprite.physicsBody?.angularDamping = 0 // same but for angle, disable
    }

    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                // off screen on left hand side, clean up
                node.removeFromParent()
            }
        }

        if !isGameOver {
            score += 1
        }
    }
    
}
