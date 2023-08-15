//
//  Player.swift
//  PC Invader
//
//  Created by An on 8/12/23.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode{
    var trailEmitter: SKEmitterNode!
    var health: Int!
    convenience init(textureName: String, zPosition: CGFloat, position: CGPoint, scale: CGFloat, trailEmitterName: String, health: Int) { // convenience keyword is call the designated constructor of the SKSpriteNode class
        let texture = SKTexture(imageNamed: textureName)
        self.init(texture: texture, color: .clear, size: texture.size()) // pass parameter in the constructor of SKSpriteNode
        self.zPosition = zPosition
        self.position = position
        self.setScale(scale)
        self.trailEmitter = SKEmitterNode(fileNamed: trailEmitterName)
        self.trailEmitter.position.x = self.position.x + 5
        self.trailEmitter.position.y = self.position.y + 5
        self.health = health
    }
}
