//
//  Bullet.swift
//  PC Invader
//
//  Created by An on 8/12/23.
//

import Foundation
import SpriteKit

class Bullet: SKSpriteNode{
    var soundSkAction: SKAction?
    convenience init(textureName: String, position: CGPoint, zPosition: CGFloat, scale: CGFloat, soundName: String ) {
        self.init(imageNamed: textureName)
        self.position = position
        self.zPosition = zPosition
        self.setScale(scale)
        
        if let soundURL = Bundle.main.url(forResource: soundName, withExtension: nil){
            do {
                self.soundSkAction = SKAction.playSoundFileNamed(soundName, waitForCompletion: false)
            } catch {
                print("Error loading sound file for bullet object: \(error)")
            }
        } else {
            print("Sound file not found")
        }
        
    }
}
