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
//        self.zRotation = -CGFloat.pi/2
    }
        
    
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func move() {
        let endPosition = CGPoint(x: self.position.x, y: -GameManager.gameManager.gamePlayableArea!.size.height * 0.1)
        
        let moveEnemy = SKAction.move(to: endPosition, duration: 10)
        let disposeEnemy = SKAction.removeFromParent()
        let sequenceEnemy = SKAction.sequence([moveEnemy, disposeEnemy])
        self.run(sequenceEnemy)
    }
    
    func shoot(gameScene: GameScene, bulletCount: Int) {
        let bulletCount = bulletCount // Number of bullets to fire in the spiral
        let rotationIncrement = CGFloat(2) * CGFloat.pi / CGFloat(bulletCount) // Angle increment for each bullet
        let bulletDistance: CGFloat = gameScene.size.height*1.2
        print(bulletDistance)

        for i in 0..<bulletCount {
            let bullet = Bullet(textureName: "vertical-enemy-bullet",
                                position: self.position,
                                zPosition: 3,
                                scale: 1,
                                soundName: "shooting.wav")

            let rotation = CGFloat(i) * rotationIncrement
            bullet.zRotation = rotation - CGFloat.pi/2
            bullet.zPosition = 1
            bullet.setScale(6)
            bullet.name = "Bullet" // Name to gather all bullet objects to dispose later
            bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size) // physics body of bullet
            bullet.physicsBody?.affectedByGravity = false
            bullet.physicsBody?.categoryBitMask = GameScene.physicsCategories.enemyBullet
            bullet.physicsBody?.collisionBitMask = GameScene.physicsCategories.None
            bullet.physicsBody?.contactTestBitMask = GameScene.physicsCategories.Player
            gameScene.addChild(bullet)

            // Calculate the end position based on the bullet's rotation
            let endX = self.position.x + bulletDistance * cos(rotation)
            let endY = self.position.y + bulletDistance * sin(rotation)
            let endPosition = CGPoint(x: endX, y: endY)

            let bulletMove = SKAction.move(to: endPosition, duration: 10)
            let deleteBullet = SKAction.removeFromParent()
            let playSoundBullet = bullet.soundSkAction!
            let bulletSequence = SKAction.sequence([bulletMove, deleteBullet]) //TODO: add playSoundBullet to the sequence
            bullet.run(bulletSequence)
        }
    }

    
    func shootLoop(gameScene: GameScene, bulletCount: Int) {
        let shootAction = SKAction.run { [weak self] in
            self?.shoot(gameScene: gameScene, bulletCount: bulletCount)
        }
        let waitAction = SKAction.wait(forDuration: 5) // Adjust the duration as needed
        let shootSequence = SKAction.sequence([waitAction, shootAction])
        let loopAction = SKAction.repeatForever(shootSequence)
        run(loopAction)
    }
}
