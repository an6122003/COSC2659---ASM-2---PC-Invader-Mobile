//
//  HorizontalLeftMovementEnemy.swift
//  PC Invader
//
//  Created by An on 8/24/23.
//

import Foundation
import SpriteKit

class HorizontalLeftMovementEnemy: Enemy{
    init(textureName: String,
         zPosition: CGFloat,
         scale: CGFloat,
         health: Int,
         bullet: Bullet) {
        
        let startPosition = CGPoint(x: GameManager.gameManager.gamePlayableArea!.width * 1.5,
                                    y: randomFloat(min: GameManager.gameManager.gamePlayableArea!.size.height * 0.4
                                                   , max: GameManager.gameManager.gamePlayableArea!.size.height))
        
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
    
    override func move() {
        
        let endPosition = CGPoint(x: -GameManager.gameManager.gamePlayableArea!.width * 0.1, y: self.position.y)
        
        let moveEnemy = SKAction.move(to: endPosition, duration: 3)
        let disposeEnemy = SKAction.removeFromParent()
        let sequenceEnemy = SKAction.sequence([moveEnemy, disposeEnemy])
        self.run(sequenceEnemy)

    }
}
