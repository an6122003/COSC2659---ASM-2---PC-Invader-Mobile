//
//  HowToPlayScene.swift
//  PC Invader
//
//  Created by An on 9/5/23.
//

import Foundation
import SpriteKit

class HowToPlayScene: SKScene{
    var backButton: SKSpriteNode!
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        
        background.position = CGPoint(x: self.size.width/2
                                      , y: self.size.height/2)
        background.zPosition = 0
        var nodePosition = background.position
        nodePosition.y -= 600
        
        let headerLogo = SKSpriteNode(imageNamed: "main-menu-header")
        headerLogo.zPosition = 1
        headerLogo.setScale(0.6)
        headerLogo.position = background.position
        headerLogo.position.y += 750
        
        let headerText = SKLabelNode(fontNamed: "ethnocentric")
        headerText.zPosition = 1
        headerText.text = "How to play"
        headerText.position = headerLogo.position
        headerText.position.y -= 250
        headerText.fontSize = 80
        
        backButton = SKSpriteNode(imageNamed: "map-back-button")
        backButton.position = CGPoint(x: self.size.width * 0.25, y: self.size.height * 0.95)
        backButton.zPosition = 5
        backButton.setScale(0.5)
        
        self.addChild(background)
        self.addChild(headerLogo)
        self.addChild(headerText)
        self.addChild(backButton)
        
//        5. How To Play View:
//
//        Provides clear and concise instructions on how to play the game.
//        Includes helpful visual aids to aid understanding.
    }
}
