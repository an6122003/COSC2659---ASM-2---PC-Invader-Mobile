//
//  HorizontalMovementEnemy.swift
//  PC Invader
//
//  Created by An on 8/24/23.
//

import Foundation
import SpriteKit

class HorizontalMovementEnemy: Enemy{
    init(textureName: String,
         zPosition: CGFloat,
         scale: CGFloat,
         health: Int,
         bullet: Bullet) {
        
        let startPosition = CGPoint(x: GameManager.gameManager.gamePlayableArea!.width * -0.1,
                                    y: randomFloat(min: GameManager.gameManager.gamePlayableArea!.size.height * 0.4
                                                   , max: GameManager.gameManager.gamePlayableArea!.size.height))
        
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
    
    override func move() {
        let endX = randomFloat(min: GameManager.gameManager.gamePlayableArea!.minX,
                                       max: GameManager.gameManager.gamePlayableArea!.maxX)
                
        
        let endPosition = CGPoint(x: GameManager.gameManager.gamePlayableArea!.width * 1.5, y: self.position.y)
        
        let moveEnemy = SKAction.move(to: endPosition, duration: 3)
        let disposeEnemy = SKAction.removeFromParent()
        let sequenceEnemy = SKAction.sequence([moveEnemy, disposeEnemy])
        self.run(sequenceEnemy)

    }
}
