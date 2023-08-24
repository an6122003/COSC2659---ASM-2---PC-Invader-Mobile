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
        
        super.init(textureName: textureName,
                   zPosition: zPosition,
                   position: startPosition,
                   scale: scale,
                   health: health,
                   bullet: bullet)
    }
        
    
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(positionPercentage: CGFloat) {
        let endPosition = CGPoint(x: self.position.x, y: GameManager.gameManager.gamePlayableArea!.size.height * positionPercentage)
        
        let moveEnemy = SKAction.move(to: endPosition, duration: 8)
//        let disposeEnemy = SKAction.removeFromParent()
        let sequenceEnemy = SKAction.sequence([moveEnemy])
        self.run(sequenceEnemy)
    }
}
