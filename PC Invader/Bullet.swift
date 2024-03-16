//
//  Bullet.swift
//  PC Invader
//
//  Created by An on 8/12/23.
//

import Foundation
import SpriteKit

class Bullet: SKSpriteNode {
    var soundSkAction: SKAction?
    var damage: Int // Change it to non-optional
    
    // Designated initializer
    init(textureName: String, damage: Int, position: CGPoint, zPosition: CGFloat, scale: CGFloat, soundName: String ) {
        let texture = SKTexture(imageNamed: textureName)
        self.damage = damage
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.position = position
        self.zPosition = zPosition
        self.setScale(scale)
        
        if let soundURL = Bundle.main.url(forResource: soundName, withExtension: nil) {
            do {
                self.soundSkAction = SKAction.playSoundFileNamed(soundName, waitForCompletion: false)
            } catch {
                print("Error loading sound file for bullet object: \(error)")
            }
        } else {
            print("Sound file not found")
        }
    }
    
    // Required initializer
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

