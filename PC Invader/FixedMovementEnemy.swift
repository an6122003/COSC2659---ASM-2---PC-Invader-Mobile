//
//  DiagonalMovementEnemy.swift
//  PC Invader
//
//  Created by An on 8/24/23.
//

import Foundation
import SpriteKit

class FixedMovementEnemy: Enemy{
    init(textureName: String,
         zPosition: CGFloat,
         scale: CGFloat,
         health: Int,
         bullet: Bullet,
         startX: CGFloat) {
        
        let startPosition = CGPoint(x: startX,
                                    y: GameManager.gameManager.gamePlayableArea!.size.height * 1.1)
        let texture = SKTexture(imageNamed: textureName)
        
        super.init(textureName: textureName,
                   zPosition: zPosition,
                   position: startPosition,
                   scale: scale,
                   health: health,
                   bullet: bullet)
        
        self.maxHealth = 5
        healthBar?.position = CGPoint(x: -self.size.width/2 - 20, y: -self.size.height / 2.0 - 70.0)
        healthBar?.size.width += 40
        healthBar?.zPosition = 1
        self.addChild(healthBar!)
        
    }
        
    
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(positionPercentage: CGFloat) {
        let endPosition = CGPoint(x: self.position.x, y: GameManager.gameManager.gamePlayableArea!.size.height * positionPercentage)
        
        let moveEnemyToEndPosition = SKAction.move(to: endPosition, duration: 5)
        let moveEnemyLeft = SKAction.moveTo(x: self.position.x - 60, duration: 2)
        let moveEnemyRight = SKAction.moveTo(x: self.position.x + 60, duration: 2)
        let moveDownSequence = SKAction.sequence([moveEnemyToEndPosition])
        let moveLeftRightSequence = SKAction.repeatForever(SKAction.sequence([moveEnemyLeft, moveEnemyRight]))
        self.run(moveDownSequence)
        self.run(moveLeftRightSequence)
    }
}
