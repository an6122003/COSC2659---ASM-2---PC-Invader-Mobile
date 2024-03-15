//
//  SKTextureAndPhysicsBodyExt.swift
//  PC Invader
//
//  Created by An on 3/16/24.
//

import Foundation
import SpriteKit

// This extension file give additional func to the SKTexture class
// This function generate the PhysicsBody, for hitbox, based on the actual image content (generated from the alpha channel of PNG image)
extension SKTexture {
    func generatePhysicsBody() -> SKPhysicsBody {
        let textureSize = CGSize(width: self.size().width, height: self.size().height)
        return SKPhysicsBody(texture: self, size: textureSize)
    }
}
