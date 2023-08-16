//
//  RandomEnemy.swift
//  PC Invader
//
//  Created by An on 8/16/23.
//

import Foundation
import SpriteKit

class RandomMovementEnemy: Enemy{
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
    }
        
    
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func move() {
        let startX = randomFloat(min: GameManager.gameManager.gamePlayableArea!.minX
                                 , max: GameManager.gameManager.gamePlayableArea!.maxX)
        
        let endX = randomFloat(min: GameManager.gameManager.gamePlayableArea!.minX
                               , max: GameManager.gameManager.gamePlayableArea!.maxX)
        
        let startPosition = position
        
        let endPosition = CGPoint(x: endX, y: -GameManager.gameManager.gamePlayableArea!.size.height*0.1) // y coordinate is negative, under the screen
        
        let rotation = atan2(endPosition.y - startPosition.y, endPosition.x - startPosition.x) // tan = opposite/adjacent = dy/dx
        
        self.zRotation = rotation
        
        let moveEnemy = SKAction.move(to: endPosition, duration: 2)
        let disposeEnemy = SKAction.removeFromParent()
        let sequenceEnemy = SKAction.sequence([moveEnemy, disposeEnemy])
        self.run(sequenceEnemy)
        print("Wrong: startPo: \(startPosition), endPo: \(endPosition), rotation: \(rotation)")
    }
}
