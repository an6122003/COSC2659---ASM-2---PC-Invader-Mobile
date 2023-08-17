//
//  LevelNode.swift
//  PC Invader
//
//  Created by An on 8/17/23.
//

import Foundation
import SpriteKit

class LevelNode: SKSpriteNode{
    public var level: Int
    
    init(imageName: String, level: Int, positionX: CGFloat, positionY: CGFloat) {
        self.level = level
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: .clear, size: texture.size())
        self.position.x = positionX
        self.position.y = positionY
        self.setScale(1.5)
        
        let placeholder = SKSpriteNode(imageNamed: "placeholder")
        placeholder.position = CGPoint(x: 0
                                       , y: -85)
//        placeholder.position.x -= 900
//        placeholder.position.y = positionY - 50
        placeholder.zPosition = 1
        placeholder.setScale(0.5)
        self.addChild(placeholder)
        
        let label = SKLabelNode(fontNamed: "ethnocentric")
        label.text = "Level: \(String(level))"
        label.fontSize = 23
        label.position = CGPoint(x: 0, y: -90)
        label.zPosition = 2
        self.addChild(label)
        
        print("levelNode X: \(self.position.x), Y: \(self.position.y)")
        print("placeHolder X: \(placeholder.position.x), Y: \(placeholder.position.y)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
