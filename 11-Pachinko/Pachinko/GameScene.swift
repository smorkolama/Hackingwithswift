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
        
//        let bouncer = SKSpriteNode(imageNamed: "bouncer")
//        bouncer.position = CGPoint(x: 512, y: 384) // middle X axis, bottom of screen
//        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
//        bouncer.physicsBody?.isDynamic = false // can't be moved, if set to true it falls below the screen :)
//        addChild(bouncer)
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)

        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first { // is an array, can be multiple fingers
            let location = touch.location(in: self) // self is game scene here

//            let box = SKSpriteNode(color: UIColor.red, size: CGSize(width: 64, height: 64))
//            box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64)) // match physics size to box size
//            box.position = location
//            addChild(box)
//            physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
            
            let ball = SKSpriteNode(imageNamed: "ballRed")
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            ball.physicsBody?.restitution = 0.4 // bounciness
            ball.position = location
            addChild(ball)
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false // can't be moved, if set to true it falls below the screen :)
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode

        if (isGood) {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
        }
        
        slotBase.position = position
        slotGlow.position = position
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10) // rotate by 180 degrees in 10 secs
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
}
