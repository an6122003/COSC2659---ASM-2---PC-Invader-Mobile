//
//  LevelNode.swift
//  PC Invader
//
//  Created by An on 8/17/23.
//

import Foundation
import SpriteKit

class LevelNode: SKSpriteNode{
    var level: Int
    
    init(imageName: String, level: Int, positionX: CGFloat, positionY: CGFloat) {
        self.level = level
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: .clear, size: texture.size())
        self.position.x = positionX
        self.position.y = positionY
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
