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
    let shopButton = SKSpriteNode(imageNamed: "shop-placeholder")
    let leaderboardButton = SKSpriteNode(imageNamed: "shop-placeholder")

    override func didMove(to view: SKView) {
        GameManager.loadShipBought() // load ship bought as UserDefaults data
        GameManager.gameManager.playBackgroundMusic(fileName: "main-menu", type: ".mp3")
        
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
        startButton.setScale(1)
        
        mapButton.position = background.position
        mapButton.position.x += 0
        mapButton.position.y -= 150
        mapButton.zPosition = 1
        mapButton.setScale(1)
        
        shopButton.position = background.position
        shopButton.position.x += 0
        shopButton.position.y -= 300
        shopButton.zPosition = 1
        shopButton.setScale(1)
        
        let shopText = SKSpriteNode(imageNamed: "shop-text")
        shopText.position = background.position
        shopText.position.x += 0
        shopText.position.y -= 300
        shopText.zPosition = 2
        shopText.setScale(0.7)
        
        leaderboardButton.position = background.position
        leaderboardButton.position.x += 0
        leaderboardButton.position.y -= 450
        leaderboardButton.zPosition = 1
        leaderboardButton.setScale(1)
        
        let leaderboardText = SKLabelNode(fontNamed: "ethnocentric")
        leaderboardText.position = background.position
        leaderboardText.text = "Leaderboard"
        leaderboardText.position.x += 0
        leaderboardText.position.y -= 460
        leaderboardText.zPosition = 3
        leaderboardText.fontSize = 35
        
        self.addChild(background)
        self.addChild(headerLogo)
        self.addChild(startButton)
        self.addChild(mapButton)
        self.addChild(shopButton)
        self.addChild(shopText)
        self.addChild(leaderboardButton)
        self.addChild(leaderboardText)
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
                GameManager.gameManager.playSoundEffect(fileName: "click", type: ".mp3")
                // The replay button was clicked, perform your function here
                GameScene.setLevel(level: UserDefaults.standard.integer(forKey: "currentUnlockLevel")+1)
                changeScene(sceneToMove: GameScene(size: self.size))
            }
    
            if mapButton.contains(location) {
                GameManager.gameManager.playSoundEffect(fileName: "click", type: ".mp3")
                // The replay button was clicked, perform your function here
                changeScene(sceneToMove: MapScene(size: self.size))
            }
            
            if shopButton.contains(location){
                GameManager.gameManager.playSoundEffect(fileName: "click", type: ".mp3")
                changeScene(sceneToMove: ShopScene(size: self.size))
            }
            
            if leaderboardButton.contains(location){
                GameManager.gameManager.playSoundEffect(fileName: "click", type: ".mp3")
                changeScene(sceneToMove: LeaderboardScene(size: self.size))
            }
        }
    }
    
    
}
