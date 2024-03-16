//
//  Player.swift
//  PC Invader
//
//  Created by An on 8/12/23.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode{
    var trailEmitter: SKEmitterNode!
    var health: Int!
    convenience init(textureName: String, zPosition: CGFloat, position: CGPoint, scale: CGFloat, trailEmitterName: String, health: Int) { // convenience keyword is call the designated constructor of the SKSpriteNode class
        let texture = SKTexture(imageNamed: textureName)
        self.init(texture: texture, color: .clear, size: texture.size()) // pass parameter in the constructor of SKSpriteNode
        self.zPosition = zPosition
        self.position = position
        self.setScale(scale)
        self.trailEmitter = SKEmitterNode(fileNamed: trailEmitterName)
        self.trailEmitter.position.x = self.position.x + 5
        self.trailEmitter.position.y = self.position.y + 5
        self.health = health
    }
    
//    func shootBullet(){
//        if let playerPosition = player?.position{
//            if currentGameState == gameState.inGame{
//                let bullet = Bullet(textureName: "bullet 1"
//                                    , damage: 1
//                                    , position: CGPoint(x: playerPosition.x - 20, y: playerPosition.y)
//                                    , zPosition: 1
//                                    , scale: 10
//                                    , soundName: "shooting.wav")
//                bullet.zRotation = CGFloat.pi / 2 // rotate 90 degree counter clockwise
//                bullet.setScale(10)
//                bullet.name = "Bullet" // Name to gather all bullet objects to dispose later
//                bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size) // physics body of bullet
//                bullet.physicsBody?.affectedByGravity = false
//                bullet.physicsBody?.categoryBitMask = physicsCategories.Bullet
//                bullet.physicsBody?.collisionBitMask = physicsCategories.None
//                bullet.physicsBody?.contactTestBitMask = physicsCategories.Enemy
//                
//                let bullet2 = Bullet(textureName: "bullet 1"
//                                    , damage: 1
//                                    , position: CGPoint(x: playerPosition.x + 20, y: playerPosition.y)
//                                    , zPosition: 1
//                                    , scale: 10
//                                    , soundName: "shooting.wav")
//                bullet2.zRotation = CGFloat.pi / 2 // rotate 90 degree counter clockwise
//                bullet2.setScale(10)
//                bullet2.name = "Bullet" // Name to gather all bullet objects to dispose later
//                bullet2.physicsBody = SKPhysicsBody(rectangleOf: bullet2.size) // physics body of bullet
//                bullet2.physicsBody?.affectedByGravity = false
//                bullet2.physicsBody?.categoryBitMask = physicsCategories.Bullet
//                bullet2.physicsBody?.collisionBitMask = physicsCategories.None
//                bullet2.physicsBody?.contactTestBitMask = physicsCategories.Enemy
//                
//                self.addChild(bullet)
//                self.addChild(bullet2)
//
//                
//                let bulletMove = SKAction.moveTo(y: self.size.height, duration: 1)
//                let deleteBullet = SKAction.removeFromParent()
//                let playSoundBullet = bullet.soundSkAction!
//                let bulletSequence = SKAction.sequence([ bulletMove, deleteBullet]) //TODO: add playSoundBullet to the sequence
//                bullet.run(bulletSequence)
//                bullet2.run(bulletSequence)
//                GameManager.gameManager.playBulletSoundEffect(fileName: "shooting", type: ".wav")
//            }
//        }
//    }
}
