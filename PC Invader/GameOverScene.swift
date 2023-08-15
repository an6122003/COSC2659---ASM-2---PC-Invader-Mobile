//
//  GameOverScene.swift
//  PC Invader
//
//  Created by An on 8/15/23.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2
                                      , y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
    }
    
    
}
