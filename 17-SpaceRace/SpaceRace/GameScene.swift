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

    override func didMove(to view: SKView) {
        backgroundColor = .black

        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384) // right side of the screen, center
        starfield.advanceSimulationTime(10) // fill screen with stars
        addChild(starfield)
        starfield.zPosition = -1

        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size) // don't use box/circle, use actual per-pixel
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
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
   
}
