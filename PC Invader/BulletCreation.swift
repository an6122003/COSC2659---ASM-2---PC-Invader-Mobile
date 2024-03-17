//
//  BulletCreation.swift
//  PC Invader
//
//  Created by An on 3/17/24.
//

import SpriteKit

func createBullet(textureName: String, damage: Int, position: CGPoint, zPosition: CGFloat, zRotation: CGFloat, scale: CGFloat, soundName: String) -> Bullet {
    let bullet = Bullet(textureName: textureName,
                        damage: damage,
                        position: position,
                        zPosition: zPosition,
                        scale: scale,
                        soundName: soundName)
//    bullet.zRotation = CGFloat.pi / 2 // rotate 90 degree counter clockwise
    bullet.zRotation = zRotation
    bullet.name = "Bullet" // Name to gather all bullet objects to dispose later
    bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size) // physics body of bullet
    bullet.physicsBody?.affectedByGravity = false
    bullet.physicsBody?.categoryBitMask = GameScene.physicsCategories.Bullet
    bullet.physicsBody?.collisionBitMask = GameScene.physicsCategories.None
    bullet.physicsBody?.contactTestBitMask = GameScene.physicsCategories.Enemy
    return bullet
}


