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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first { // is an array, can be multiple fingers
            let location = touch.location(in: self) // self is game scene here
            let box = SKSpriteNode(color: UIColor.red, size: CGSize(width: 64, height: 64))
            box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64)) // match physics size to box size
            box.position = location
            addChild(box)
            physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        }
    }
    
    
}
