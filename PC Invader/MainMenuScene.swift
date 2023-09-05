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
    var questionButton: SKSpriteNode!
    var soundButton: SKSpriteNode!
    var musicButton: SKSpriteNode!

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
        
        questionButton = SKSpriteNode(imageNamed: "question-btn")
        questionButton.position = CGPoint(x: self.size.width * 0.75, y: self.size.height * 0.22)
        questionButton.zPosition = 2
        questionButton.setScale(0.5)
        
        if UserDefaults.standard.bool(forKey: "soundMute") == false{
            soundButton = SKSpriteNode(imageNamed: "sound-btn")
        }else{
            soundButton = SKSpriteNode(imageNamed: "sound-btn-active")
        }
        soundButton.position = CGPoint(x: self.size.width * 0.75, y: self.size.height * 0.1)
        soundButton.zPosition = 2
        soundButton.setScale(0.5)
        
        if UserDefaults.standard.bool(forKey: "musicMute") == false{
            musicButton = SKSpriteNode(imageNamed: "music-btn")
        }else{
            musicButton = SKSpriteNode(imageNamed: "music-btn-active")
        }
        musicButton.position = CGPoint(x: self.size.width * 0.75, y: self.size.height * 0.16)
        musicButton.zPosition = 2
        musicButton.setScale(0.5)
        
        self.addChild(background)
        self.addChild(headerLogo)
        self.addChild(startButton)
        self.addChild(mapButton)
        self.addChild(shopButton)
        self.addChild(shopText)
        self.addChild(leaderboardButton)
        self.addChild(leaderboardText)
        self.addChild(questionButton)
        self.addChild(soundButton)
        self.addChild(musicButton)
    }
    
    func changeScene(sceneToMove: SKScene){
        sceneToMove.size = self.size
        sceneToMove.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 1)
        self.view?.presentScene(sceneToMove, transition: transition)
    }
    
    func musicButtonPressed(){
        let temp = UserDefaults.standard.bool(forKey: "musicMute")
        UserDefaults.standard.set(!temp, forKey: "musicMute")
        if UserDefaults.standard.bool(forKey: "musicMute") == false{
            musicButton.texture = SKTexture(imageNamed: "music-btn")
        }else{
            musicButton.texture = SKTexture(imageNamed: "music-btn-active")
        }
        GameManager.gameManager.playBackgroundMusic(fileName: "main-menu", type: ".mp3")
    }
    
    func soundButtonPressed(){
        let temp = UserDefaults.standard.bool(forKey: "soundMute")
        UserDefaults.standard.set(!temp, forKey: "soundMute")
        if UserDefaults.standard.bool(forKey: "soundMute") == false{
            soundButton.texture = SKTexture(imageNamed: "sound-btn")
        }else{
            soundButton.texture = SKTexture(imageNamed: "sound-btn-active")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if startButton.contains(location) {
                GameManager.gameManager.playSoundEffect(fileName: "click", type: ".mp3")
                GameScene.setLevel(level: UserDefaults.standard.integer(forKey: "currentUnlockLevel")+1)
                changeScene(sceneToMove: GameScene(size: self.size))
            }
    
            if mapButton.contains(location) {
                GameManager.gameManager.playSoundEffect(fileName: "click", type: ".mp3")
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
            
            if musicButton.contains(location){
                GameManager.gameManager.playSoundEffect(fileName: "click", type: ".mp3")
                musicButtonPressed()
            }
            
            if soundButton.contains(location){
                GameManager.gameManager.playSoundEffect(fileName: "click", type: ".mp3")
                soundButtonPressed()
            }
            
            if questionButton.contains(location){
                GameManager.gameManager.playSoundEffect(fileName: "click", type: ".mp3")
                changeScene(sceneToMove: HowToPlayScene(size: self.size))
            }
        }
    }
    
    
}
