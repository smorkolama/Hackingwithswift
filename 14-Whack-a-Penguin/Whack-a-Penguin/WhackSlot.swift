//
//  WhackSlot.swift
//  Whack-a-Penguin
//
//  Created by Benjamin van den Hout on 11/12/2019.
//  Copyright © 2019 NGTI. All rights reserved.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {
    var charNode: SKSpriteNode!
    var isVisible = false
    var isHit = false

    func configure(at position: CGPoint) {
        self.position = position

        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)

        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15) // coordinates relative to current SKNode!
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask") // all colored parts are visible, rest is hidden

        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)

        addChild(cropNode)
    }

    func show(hideTime: Double) {
        if isVisible { return }

        charNode.xScale = 1
        charNode.yScale = 1

        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false

        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            self?.hide()
        }
    }

    func hide() {
        if !isVisible { return }

        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }

    func hit() {
        isHit = true

        let smoke = SKEmitterNode(fileNamed: "Smoke")

        let generateSmoke = SKAction.run {
            if let smoke = smoke  {
                smoke.position = self.charNode.position
                self.addChild(smoke)
            }
        }

        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run {
            self.isVisible = false
        }

        let delayRemoveSmoke = SKAction.wait(forDuration: 2.0)
        let removeSmoke = SKAction.run {
            if let smoke = smoke {
                smoke.removeFromParent()
            }
        }
        charNode.run(SKAction.sequence([generateSmoke, delay, hide, notVisible, delayRemoveSmoke, removeSmoke]))
    }
}
