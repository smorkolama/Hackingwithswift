//
//  GameScene.swift
//  FireworksNight
//
//  Created by Benjamin van den Hout on 19/12/2019.
//  Copyright © 2019 NGTI. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    var scoreLabel: SKLabelNode!

    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)

        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }

    @objc func launchFireworks() {
        let movementAmount: CGFloat = 1800

        switch Int.random(in: 0...3) {
        case 0: // five, straight up
            print("straight up")
            createFireworks(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFireworks(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFireworks(xMovement: 0, x: 512, y: bottomEdge)
            createFireworks(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFireworks(xMovement: 0, x: 512 + 200, y: bottomEdge)
        case 1: // five, fan
            print("fan")
            createFireworks(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFireworks(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFireworks(xMovement: 0, x: 512, y: bottomEdge)
            createFireworks(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFireworks(xMovement: 200, x: 512 + 200, y: bottomEdge)
        case 2: // five from left to right
            print("left to right")
            createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
        case 3: // five from right to left
            print("right to left")
            createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
        default:
            break
        }
    }

    func createFireworks(xMovement: CGFloat, x: Int, y: Int) {
        // create fireworks container
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)

        // create rocket sprite node, color blend it and add to container
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1 // use new color exclusively
        firework.name = "firework"
        node.addChild(firework)

        // color firework sprite node to random color
        switch Int.random(in: 0...2) {
        case 0: firework.color = .cyan
        case 1: firework.color = .green
        case 2: firework.color = .red
        default: break
        }

        // create UIBezierPath that represents movement of firework
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))

        // tell container node to follow path, turning as needed
        // asOffset=true: coordinates in path are adjusted to take into account node's position
        // orientToPath=true: automatically rotate so it's always facing down the path
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)

        // create particles behind rocket to make it seem it is lit
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22) // relative to container!
            node.addChild(emitter)
        }

        // add firework to fireworks array and scene
        fireworks.append(node)
        addChild(node)
    }

    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }

        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)

        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }

            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }

            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
}
