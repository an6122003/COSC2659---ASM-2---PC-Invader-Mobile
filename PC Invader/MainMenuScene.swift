//
//  MainMenuScene.swift
//  PC Invader
//
//  Created by An on 8/17/23.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene{
    let startButton = SKSpriteNode(imageNamed: "start-btn")
    let mapButton = SKSpriteNode(imageNamed: "map-btn")
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2
                                      , y: self.size.height/2)
        background.zPosition = 0
        
        let headerLogo = SKSpriteNode(imageNamed: "main-menu-header")
        headerLogo.zPosition = 1
        headerLogo.setScale(0.8)
        headerLogo.position = background.position
        headerLogo.position.y += 400
        
        startButton.position = background.position
        startButton.position.x += 0
        startButton.position.y -= 0
        startButton.zPosition = 1
        startButton.setScale(0.8)
        
        mapButton.position = background.position
        mapButton.position.x += 0
        mapButton.position.y -= 150
        mapButton.zPosition = 1
        mapButton.setScale(0.8)
        
        self.addChild(background)
        self.addChild(headerLogo)
        self.addChild(startButton)
        self.addChild(mapButton)
    }
    
    func changeScene(sceneToMove: SKScene){
        sceneToMove.size = self.size
        sceneToMove.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 1)
        self.view?.presentScene(sceneToMove, transition: transition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if startButton.contains(location) {
                // The replay button was clicked, perform your function here
                changeScene(sceneToMove: GameScene(size: self.size))
            }
    
            if mapButton.contains(location) {
                // The replay button was clicked, perform your function here
                changeScene(sceneToMove: MapScene(size: self.size))
            }
        }
    }
    
    
}
