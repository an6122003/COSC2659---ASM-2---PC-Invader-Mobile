//
//  Enemy.swift
//  PC Invader
//
//  Created by An on 8/14/23.
//

import Foundation
import SpriteKit

class Enemy: SKSpriteNode{
    var trailEmitter: SKEmitterNode!
    convenience init(textureName: String, zPosition: CGFloat, position: CGPoint, scale: CGFloat, trailEmitterName: String) { // convenience keyword is call the designated constructor of the SKSpriteNode class
        let texture = SKTexture(imageNamed: textureName)
        self.init(texture: texture, color: .clear, size: texture.size()) // pass parameter in the constructor of SKSpriteNode
        self.zPosition = zPosition
        self.position = position
        self.setScale(scale)
        self.trailEmitter = SKEmitterNode(fileNamed: trailEmitterName)
        self.trailEmitter.position.x = self.position.x + 5
        self.trailEmitter.position.y = self.position.y + 5
    }
}
