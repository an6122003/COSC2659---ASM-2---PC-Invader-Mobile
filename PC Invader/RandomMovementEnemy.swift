//
//  RandomEnemy.swift
//  PC Invader
//
//  Created by An on 8/16/23.
//

import Foundation
import SpriteKit

class RandomMovementEnemy: Enemy{
    var gameScene: GameScene
    var healthBarOffsetX: CGFloat = 45
    var healthBarOffsetY: CGFloat = 60

    init(textureName: String,
         zPosition: CGFloat,
         scale: CGFloat,
         health: Int,
         bullet: Bullet,
         gameScene: GameScene) {
        
        let startPosition = CGPoint(x: randomFloat(min: GameManager.gameManager.gamePlayableArea!.minX,
                                                   max: GameManager.gameManager.gamePlayableArea!.maxX),
                                    y: GameManager.gameManager.gamePlayableArea!.size.height * 1.1)
        
        self.gameScene = gameScene
        
        super.init(textureName: textureName,
                   zPosition: zPosition,
                   position: startPosition,
                   scale: scale,
                   health: health,
                   bullet: bullet)
        
        self.maxHealth = 10

        healthBar?.position = startPosition
        healthBar?.position.x -= healthBarOffsetX
        healthBar?.position.y -= healthBarOffsetY
        healthBar?.zPosition = 3
        gameScene.addChild(healthBar!)
    }
        
    
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func move() {
        let endX = randomFloat(min: GameManager.gameManager.gamePlayableArea!.minX
                               , max: GameManager.gameManager.gamePlayableArea!.maxX)
        
        let startPosition = position
        
        let endPosition = CGPoint(x: endX, y: -GameManager.gameManager.gamePlayableArea!.size.height*0.1) // y coordinate is negative, under the screen
        
        let rotation = atan2(endPosition.y - startPosition.y, endPosition.x - startPosition.x) // tan = opposite/adjacent = dy/dx
        
        self.zRotation = rotation
        
        let moveEnemy = SKAction.move(to: endPosition, duration: 5)
        let disposeEnemy = SKAction.removeFromParent()
        let sequenceEnemy = SKAction.sequence([moveEnemy, disposeEnemy])
        
        var endPositionHealthBar = endPosition
        endPositionHealthBar.x -= healthBarOffsetX
        endPositionHealthBar.y -= healthBarOffsetY
        
        let moveHealthBar = SKAction.move(to: endPositionHealthBar, duration: 5)
        let disposeHealthBar = SKAction.removeFromParent()
        let sequenceHealthBar = SKAction.sequence([moveHealthBar, disposeHealthBar])
        
        print("endPosition: \(endPosition)")
        print("endPositionHealthBar: \(endPositionHealthBar)")

        
        self.run(sequenceEnemy)
        healthBar?.run(sequenceHealthBar)

    }
}
