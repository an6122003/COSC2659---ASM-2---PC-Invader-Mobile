//
//  CircularMovementEnemy.swift
//  PC Invader
//
//  Created by An on 8/24/23.
//

import Foundation
import SpriteKit

class CircularMovementEnemy: Enemy {
    var centerPoint: CGPoint
    var radius: CGFloat
    var angle: CGFloat = 0.0

    init(textureName: String,
         zPosition: CGFloat,
         scale: CGFloat,
         health: Int,
         bullet: Bullet,
         centerPoint: CGPoint,
         radius: CGFloat) {
        
        self.centerPoint = centerPoint
        self.radius = radius
        let initialPositionX = self.centerPoint.x - self.radius
        let initialPositionY = self.centerPoint.y
        
        super.init(textureName: textureName,
                   zPosition: zPosition,
                   position: CGPoint(x: initialPositionX, y: initialPositionY),
                   scale: scale,
                   health: health,
                   bullet: bullet)
        
        self.maxHealth = 5
        healthBar?.position = CGPoint(x: -self.size.width/2 - 20, y: -self.size.height / 2.0 - 70.0)
        healthBar?.size.width += 40
        healthBar?.zPosition = 1
//        healthBar?.zRotation = -CGFloat.pi/4
        self.addChild(healthBar!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func move() {
        // Determine the initial direction based on the current position
        var clockwise: Bool = true
        let duration: TimeInterval = 8
        
        // Create a circular path
        let pathLeft = CGMutablePath()
        pathLeft.addArc(center: centerPoint, radius: radius, startAngle: 0, endAngle: CGFloat.pi, clockwise: clockwise)
        let semiCircleLeft = SKShapeNode(path: pathLeft)
        
        let semicircularMoveLeft = SKAction.follow(semiCircleLeft.path!, asOffset: false, orientToPath: true, duration: duration)
        
        let pathRight = CGMutablePath()
        pathRight.addArc(center: centerPoint, radius: radius, startAngle: CGFloat.pi, endAngle: 0, clockwise: !clockwise)
        let semiCircleRight = SKShapeNode(path: pathRight)
        
        let semicircularMoveRight = SKAction.follow(semiCircleRight.path!, asOffset: false, orientToPath: true, duration: duration)

        let sequence = SKAction.sequence([semicircularMoveLeft,semicircularMoveRight])

        let repeatAction = SKAction.repeatForever(sequence)

        // Run the action
        self.run(repeatAction)
    }
    
    override func shoot(gameScene: GameScene) {
        let bullet = Bullet(textureName: "circular-enemy-bullet",
                            position: self.position,
                            zPosition: 3,
                            scale: 0.3,
                            soundName: "shooting.wav")

        bullet.zPosition = 1
        bullet.zRotation = -CGFloat.pi * 0.75
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
        let endPosition = CGPoint(x: endX, y: endY)

        let bulletMove = SKAction.move(to: endPosition, duration: 5)
        let deleteBullet = SKAction.removeFromParent()
        let playSoundBullet = bullet.soundSkAction!
        let bulletSequence = SKAction.sequence([bulletMove, deleteBullet]) //TODO: add playSoundBullet to the sequence
        bullet.run(bulletSequence)
    }

    
    func shootLoop(gameScene: GameScene, fireRate: CGFloat ) {
        let shootAction = SKAction.run { [weak self] in
            self?.shoot(gameScene: gameScene)
        }
        let waitAction = SKAction.wait(forDuration: fireRate) // Adjust the duration as needed
        let shootSequence = SKAction.sequence([waitAction, shootAction])
        let loopAction = SKAction.repeatForever(shootSequence)
        run(loopAction)
    }
}

