//
//  EnemyHealthBar.swift
//  PC Invader
//
//  Created by An on 9/3/23.
//

import Foundation
import SpriteKit

class EnemyHealthBar: SKSpriteNode {
    let initialWidth: CGFloat
    init(width: CGFloat, height: CGFloat) {
        self.initialWidth = width
        let texture = SKTexture(imageNamed: "enemy-health-bar")
        super.init(texture: texture, color: .clear, size: CGSize(width: width, height: height))
        anchorPoint = CGPoint(x: 0.0, y: 0.5) // Anchor the health bar to the left
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateHealthBar(currentHealth: CGFloat, maxHealth: CGFloat) {
        let newWidth = initialWidth * (currentHealth / maxHealth)
        self.size.width = newWidth // Ensure the health bar doesn't have a negative width
    }
}
