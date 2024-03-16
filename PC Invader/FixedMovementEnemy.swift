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
    
    override func shoot(gameScene: GameScene) {
        let bullet = Bullet(textureName: "fixed-move-enemy-bullet",
                            damage: 1,
                            position: self.position,
                            zPosition: 3,
                            scale: 0.3,
                            soundName: "shooting.wav")

        bullet.zPosition = 1
        bullet.zRotation = -CGFloat.pi
        bullet.name = "Bullet" // Name to gather all bullet objects to dispose later
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size) // physics body of bullet
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.categoryBitMask = GameScene.physicsCategories.enemyBullet
        bullet.physicsBody?.collisionBitMask = GameScene.physicsCategories.None
        bullet.physicsBody?.contactTestBitMask = GameScene.physicsCategories.Player
        gameScene.addChild(bullet)

        // Calculate the end position based on the bullet's rotation
        let endX = self.position.x
        let endY = -gameScene.size.height * 0.1
        let endPosition = gameScene.player.position

        let bulletMove = SKAction.move(to: endPosition, duration: 5)
        let deleteBullet = SKAction.removeFromParent()
        let playSoundBullet = bullet.soundSkAction!
        let bulletSequence = SKAction.sequence([bulletMove, deleteBullet]) //TODO: add playSoundBullet to the sequence
        bullet.run(bulletSequence)
    }

    
    func shootLoop(gameScene: GameScene, fireDelay: CGFloat ) {
        let shootAction = SKAction.run { [weak self] in
            self?.shoot(gameScene: gameScene)
        }
        let waitAction = SKAction.wait(forDuration: fireDelay) // Adjust the duration for fire rate
        let shootSequence = SKAction.sequence([waitAction, shootAction])
        let loopAction = SKAction.repeatForever(shootSequence)
        run(loopAction)
    }
}
