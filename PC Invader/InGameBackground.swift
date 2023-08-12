//
//  InGameBackground.swift
//  PC Invader
//
//  Created by An on 8/12/23.
//

import Foundation
import SpriteKit

class InGameBackground: SKSpriteNode {
    convenience init(textureName: String, position: CGPoint, size: CGSize, zPosition: CGFloat){
//        let texture = SKTexture(imageNamed: textureName)
        self.init(imageNamed: textureName) //SKSpriteNode super constructor
        self.position = position
        self.size = size
        self.zPosition = zPosition
    }
}
