//
//  VerticalMovementEnemy.swift
//  PC Invader
//
//  Created by An on 8/16/23.
//

import Foundation
import SpriteKit

class VerticalMovementEnemy: Enemy{
    init(textureName: String,
         zPosition: CGFloat,
         scale: CGFloat,
         health: Int,
         bullet: Bullet) {
        
        let startPosition = CGPoint(x: randomFloat(min: GameManager.gameManager.gamePlayableArea!.minX,
                                                   max: GameManager.gameManager.gamePlayableArea!.maxX),
                                    y: GameManager.gameManager.gamePlayableArea!.size.height * 1.1)
        
        super.init(textureName: textureName,
                   zPosition: zPosition,
                   position: startPosition,
                   scale: scale,
                   health: health,
                   bullet: bullet)
        movementDirection = CGVector(dx: 0, dy: 10)
        self.zRotation = -CGFloat.pi/2
    }
        
    
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func move() {
        let endPosition = CGPoint(x: self.position.x, y: -GameManager.gameManager.gamePlayableArea!.size.height * 0.1)
        
        let moveEnemy = SKAction.move(to: endPosition, duration: 5)
        let disposeEnemy = SKAction.removeFromParent()
        let sequenceEnemy = SKAction.sequence([moveEnemy, disposeEnemy])
        self.run(sequenceEnemy)
    }
}
