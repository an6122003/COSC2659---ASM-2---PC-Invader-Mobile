//
//  CircularMovementEnemy.swift
//  PC Invader
//
//  Created by An on 8/24/23.
//

import Foundation
import SpriteKit

class CircularMovementEnemy: Enemy {
    let centerPoint: CGPoint
    let radius: CGFloat
    var angle: CGFloat = 0.0
    
    init(textureName: String,
         zPosition: CGFloat,
         scale: CGFloat,
         health: Int,
         bullet: Bullet,
         centerPoint: CGPoint,
         radius: CGFloat) {
        
        self.centerPoint = centerPoint
        self.radius = radius
        
        super.init(textureName: textureName,
                   zPosition: zPosition,
                   position: centerPoint,
                   scale: scale,
                   health: health,
                   bullet: bullet)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func move() {
        angle += 0.03 // Adjust the rotation speed
        
        let newX = centerPoint.x + radius * cos(angle)
        let newY = centerPoint.y + radius * sin(angle)
        let endPosition = CGPoint(x: newX, y: newY)
        
        let moveEnemy = SKAction.move(to: endPosition, duration: 5) // Adjust the duration as needed
        let disposeEnemy = SKAction.removeFromParent()
        let sequenceEnemy = SKAction.sequence([moveEnemy, disposeEnemy])
        self.run(sequenceEnemy)
    }
}

