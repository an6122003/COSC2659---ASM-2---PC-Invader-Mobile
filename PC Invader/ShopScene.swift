//
//  ShopScene.swift
//  PC Invader
//
//  Created by An on 8/25/23.
//

import Foundation
import SpriteKit

class ShopScene: SKScene{
    var backButton: SKSpriteNode!
    var backwardButton: SKSpriteNode!
    var forwardButton: SKSpriteNode!
    var shipImage: SKSpriteNode!
    let shipDictionary:[Int: String] = [0: "player-ship-0",
                                        1: "player-ship-1",
                                        2: "player-ship-2",
                                        3: "player-ship-3",
                                        4: "player-ship-4"]
    var currentSelectedShip = UserDefaults.standard.integer(forKey: "currentSelectedShip")
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2
                                      , y: self.size.height/2)
        background.zPosition = 0
        
        let headerLogo = SKSpriteNode(imageNamed: "main-menu-header")
        headerLogo.zPosition = 1
        headerLogo.setScale(0.8)
        headerLogo.position = background.position
        headerLogo.position.y += 500
        
//        if UserDefaults.standard.integer(forKey: "highScore") < GameScene.playerScore{
//            UserDefaults.standard.set(GameScene.playerScore, forKey: "highScore")
//        }
        
        
        shipImage = SKSpriteNode(imageNamed: shipDictionary[currentSelectedShip]!)
        
        shipImage.position = background.position
        
        shipImage.zPosition = 1
        shipImage.zRotation = CGFloat.pi/2
        shipImage.setScale(3)
        
        backButton = SKSpriteNode(imageNamed: "map-back-button")
        backButton.position = CGPoint(x: self.size.width * 0.25, y: self.size.height * 0.95)
        backButton.zPosition = 5
        backButton.setScale(0.5)
        
        backwardButton = SKSpriteNode(imageNamed:"shop-backward-button")
        backwardButton.position = shipImage.position
        backwardButton.position.x -= 300
        backwardButton.zPosition = 1
        backwardButton.setScale(0.7)
        
        forwardButton = SKSpriteNode(imageNamed:"shop-forward-button")
        forwardButton.position = shipImage.position
        forwardButton.position.x += 300
        forwardButton.zPosition = 1
        forwardButton.setScale(0.7)

        self.addChild(background)
        self.addChild(headerLogo)
        self.addChild(shipImage)
        self.addChild(backButton)
        self.addChild(backwardButton)
        self.addChild(forwardButton)
    }
    
    func updateShipDisplay(){
        self.currentSelectedShip = UserDefaults.standard.integer(forKey: "currentSelectedShip")
//        self.shipImage = SKSpriteNode(imageNamed: self.shipDictionary[self.currentSelectedShip]!)
        let newTexture = SKTexture(imageNamed: self.shipDictionary[currentSelectedShip]!)
        self.shipImage.texture = newTexture
    }
    
    func backwardButtonPressed(){
        if UserDefaults.standard.integer(forKey: "currentSelectedShip") == 0 {
            return
        }else{
            let temp = UserDefaults.standard.integer(forKey: "currentSelectedShip")
            UserDefaults.standard.set(temp - 1, forKey: "currentSelectedShip")
            updateShipDisplay()
            print(UserDefaults.standard.integer(forKey: "currentSelectedShip"))
            print("backward pressed")
        }
    }
    
    func forwardButtonPressed(){
        if UserDefaults.standard.integer(forKey: "currentSelectedShip") == 4 {
            return
        }else{
            let temp = UserDefaults.standard.integer(forKey: "currentSelectedShip")
            UserDefaults.standard.set(temp + 1, forKey: "currentSelectedShip")
            updateShipDisplay()
            print(UserDefaults.standard.integer(forKey: "currentSelectedShip"))
            print("forward pressed")
        }
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
            if backButton.contains(location){
                changeScene(sceneToMove: MainMenuScene(size: self.size))
            }
            if backwardButton.contains(location){
                backwardButtonPressed()
            }
            if forwardButton.contains(location){
                forwardButtonPressed()
            }
        }
    }
    
}
