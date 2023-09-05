//
//  BossEnemy.swift
//  PC Invader
//
//  Created by An on 9/5/23.
//

import Foundation
import SpriteKit

class BossEnemy: Enemy{
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
        
        self.maxHealth = 400
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
    
    func shootToPlayer(gameScene: GameScene) {
        let bullet = Bullet(textureName: "fixed-move-enemy-bullet",
                            position: self.position,
                            zPosition: 3,
                            scale: 0.3,
                            soundName: "shooting.wav")

        bullet.zPosition = 1
        bullet.zRotation = -CGFloat.pi
//        bullet.setScale(6)
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

    
    func shootToPlayerLoop(gameScene: GameScene, fireDelay: CGFloat ) {
        let shootAction = SKAction.run { [weak self] in
            self?.shootToPlayer(gameScene: gameScene)
        }
        let waitAction = SKAction.wait(forDuration: fireDelay) // Adjust the duration for fire rate
        let shootSequence = SKAction.sequence([waitAction, shootAction])
        let loopAction = SKAction.repeatForever(shootSequence)
        run(loopAction)
    }
    
    func shootCircular(gameScene: GameScene, bulletCount: Int) {
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

    
    func shootCircularLoop(gameScene: GameScene, bulletCount: Int, fireDelay: CGFloat) {
        let shootAction = SKAction.run { [weak self] in
            self?.shootCircular(gameScene: gameScene, bulletCount: bulletCount)
        }
        let waitAction = SKAction.wait(forDuration: fireDelay) // Adjust the duration for fire rate
        let shootSequence = SKAction.sequence([waitAction, shootAction])
        let loopAction = SKAction.repeatForever(shootSequence)
        run(loopAction)
    }
    
    func shootStraight(gameScene: GameScene) {
        let bullet = Bullet(textureName: "circular-enemy-bullet",
                            position: self.position,
                            zPosition: 3,
                            scale: 0.3,
                            soundName: "shooting.wav")

        bullet.zPosition = 1
        bullet.zRotation = -CGFloat.pi * 0.75
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
        let endPosition = CGPoint(x: endX, y: endY)

        let bulletMove = SKAction.move(to: endPosition, duration: 5)
        let deleteBullet = SKAction.removeFromParent()
        let playSoundBullet = bullet.soundSkAction!
        let bulletSequence = SKAction.sequence([bulletMove, deleteBullet]) //TODO: add playSoundBullet to the sequence
        bullet.run(bulletSequence)
    }

    
    func shootStraightLoop(gameScene: GameScene, fireRate: CGFloat ) {
        let shootAction = SKAction.run { [weak self] in
            self?.shootStraight(gameScene: gameScene)
        }
        let waitAction = SKAction.wait(forDuration: fireRate) // Adjust the duration for fire rate
        let shootSequence = SKAction.sequence([waitAction, shootAction])
        let loopAction = SKAction.repeatForever(shootSequence)
        run(loopAction)
    }
}
