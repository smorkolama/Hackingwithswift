//
//  GameScene.swift
//  Pachinko
//
//  Created by Benjamin van den Hout on 28/11/2019.
//  Copyright © 2019 Benjamin van den Hout. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var scoreLabel: SKLabelNode!
    var editLabel: SKLabelNode!

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        
        // y=10 ^
        //      |
        //      |
        // y=0  *------>
        //      x=0    x=10
        background.position = CGPoint(x: 512, y: 384) // position is center of image, screen is 1024*768 so this fills the whole screen
        background.blendMode = .replace // just draw, ignoring alpha values
        background.zPosition = -1
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)

        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        // set up score
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right // align text to right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        // set up edit label
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        // add some music
        let music = SKAudioNode(fileNamed: "orbital.mp3")
        music.autoplayLooped = true
        addChild(music)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first { // is an array, can be multiple fingers
            let location = touch.location(in: self) // self is game scene here

            let objects = nodes(at: location)
            
            if objects.contains(editLabel) {
                editingMode.toggle()
            } else {
                if editingMode {
                    // create a box
                    let size = CGSize(width: Int.random(in: 64...192), height: 16)
                    let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                    box.zRotation = CGFloat.random(in: 0...3) // rotate around its axis
                    box.position = location
                    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                    box.physicsBody?.isDynamic = false
                    addChild(box)
                } else {
                    // create a ball
                    let ball = SKSpriteNode(imageNamed: "ballRed")
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    ball.physicsBody?.restitution = 0.4 // bounciness
                    
                    // shortcut to tell about any collision
                    // contactTestBitMask = "which collisions do you want to know about", default set to nothing
                    // collisionBitMask =  "which nodes should I bump into", default set to everything
                    ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                    
//                    ball.position = location
                    ball.position = CGPoint(x: location.x, y: 768) // allways drop ball from the top
                    ball.name = "ball"
                    addChild(ball)
                }
            }
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false // can't be moved, if set to true it falls below the screen :)
        bouncer.name = "bouncer"
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode

        if (isGood) {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position

        // Add rectangle physics to slots, should not move when hit
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size) // set physics size to size of image
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10) // rotate by 180 degrees in 10 secs
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            print("Destroy good ball")
            destroy(ball: ball)
            let soundEffect = SKAction.playSoundFileNamed("magic.mp3", waitForCompletion: false)
            run(soundEffect)
            score += 1
        } else if object.name == "bad" {
            print("Destroy bad ball")
            destroy(ball: ball)
            let soundEffect = SKAction.playSoundFileNamed("boing.mp3", waitForCompletion: false)
            run(soundEffect)
            score -= 1
        }
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
//            addChild(fireParticles)
        }

        ball.removeFromParent()
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        print("Contact between \(String(describing: nodeA.name))) and \(String(describing: nodeB.name))")
        if contact.bodyA.node?.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if contact.bodyB.node?.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
}
