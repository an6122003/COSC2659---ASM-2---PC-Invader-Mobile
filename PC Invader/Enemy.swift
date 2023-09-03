//
//  Enemy.swift
//  PC Invader
//
//  Created by An on 8/14/23.
//

import Foundation
import SpriteKit

class Enemy: SKSpriteNode{
    var health: Int!
    var bullet: Bullet!
    var healthBar: EnemyHealthBar?
    var maxHealth: Int!
    init(textureName: String,
         zPosition: CGFloat,
         position: CGPoint,
         scale: CGFloat,
         health: Int,
         bullet: Bullet) {
        let texture = SKTexture(imageNamed: textureName)
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.zPosition = zPosition
        self.position = position
        self.setScale(scale)
        self.health = health
        self.bullet = bullet
        self.healthBar = EnemyHealthBar(width: self.size.width, height: 20)
        self.healthBar!.name = "EnemyHealthBar"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func move(){
        
    }
    
    func shoot(gameScene: GameScene){}
}
