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
    var selectButton: SKSpriteNode!
    var forwardButton: SKSpriteNode!
    var buyButton: SKSpriteNode!
    var shipImage: SKSpriteNode!
    var shipHealth: SKLabelNode!
    var shipPrice: SKLabelNode!
    let shipDictionary:[Int: String] = [0: "player-ship-0",
                                        1: "player-ship-1",
                                        2: "player-ship-2",
                                        3: "player-ship-3",
                                        4: "player-ship-4"]
    var currentSelectedShip = UserDefaults.standard.integer(forKey: "currentSelectedShip")
    var currentViewShip = 0
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2
                                      , y: self.size.height/2)
        background.zPosition = 0
        
        let headerLogo = SKSpriteNode(imageNamed: "main-menu-header")
        headerLogo.zPosition = 1
        headerLogo.setScale(0.5)
        headerLogo.position = background.position
        headerLogo.position.y += 750
        
//        if UserDefaults.standard.integer(forKey: "highScore") < GameScene.playerScore{
//            UserDefaults.standard.set(GameScene.playerScore, forKey: "highScore")
//        }
        
        let shopWindow = SKSpriteNode(imageNamed: "shop-window")
        shopWindow.zPosition = 1
        shopWindow.setScale(0.85)
        shopWindow.position = background.position
//        shopWindow.position.y -= 130
        
        let shopHeader = SKSpriteNode(imageNamed: "shop-header")
        shopHeader.zPosition = 2
        shopHeader.setScale(0.85)
        shopHeader.position = shopWindow.position
        shopHeader.position.y += 530
        
        let shopShipPlaceholder = SKSpriteNode(imageNamed: "shop-ship-placeholder")
        shopShipPlaceholder.zPosition = 2
        shopShipPlaceholder.setScale(1)
        shopShipPlaceholder.position = shopWindow.position
        shopShipPlaceholder.position.y += 120
        
        shipImage = SKSpriteNode(imageNamed: shipDictionary[currentSelectedShip]!)
        shipImage.position = shopShipPlaceholder.position
        shipImage.position.y += 50
        shipImage.zPosition = 3
        shipImage.zRotation = CGFloat.pi/2
        shipImage.setScale(2)
        
        shipHealth = SKLabelNode(fontNamed: "ethnocentric")
        shipHealth.text = "Health: \(GameManager.PlayerHealthInformation[UserDefaults.standard.integer(forKey: "currentSelectedShip")]!)"
        shipHealth.fontSize = 40
        shipHealth.position = shipImage.position
        shipHealth.position.y -= 200
        shipHealth.zPosition = 3
        
        backButton = SKSpriteNode(imageNamed: "map-back-button")
        backButton.position = CGPoint(x: self.size.width * 0.25, y: self.size.height * 0.95)
        backButton.zPosition = 5
        backButton.setScale(0.5)
        
        backwardButton = SKSpriteNode(imageNamed:"shop-backward-button")
        backwardButton.position = shopWindow.position
        backwardButton.position.x -= 250
        backwardButton.position.y -= 450
        backwardButton.zPosition = 2
        backwardButton.setScale(0.7)
        
        forwardButton = SKSpriteNode(imageNamed:"shop-forward-button")
        forwardButton.position = shopWindow.position
        forwardButton.position.x += 250
        forwardButton.position.y -= 450
        forwardButton.zPosition = 2
        forwardButton.setScale(0.7)
        
        selectButton = SKSpriteNode(imageNamed:"shop-select-button")
        selectButton.position = shopWindow.position
        selectButton.position.y -= 450
        selectButton.zPosition = 2
        selectButton.setScale(0.7)
        
        buyButton = SKSpriteNode(imageNamed:"shop-buy-button")
        buyButton.position = shopWindow.position
        buyButton.position.y -= 250
        buyButton.zPosition = 2
        buyButton.setScale(1)
        
        shipPrice = SKLabelNode(fontNamed: "ethnocentric")
        if GameManager.shipBought.contains(UserDefaults.standard.integer(forKey: "currentSelectedShip")){
            shipPrice.position = buyButton.position
            shipPrice.text = "Acquired"
            shipPrice.fontSize = 40
            shipPrice.position.y -= 10
        }else{
            shipPrice.position = buyButton.position
            shipPrice.text = String(GameManager.ShipPrice[UserDefaults.standard.integer(forKey: "currentSelectedShip")]!)
            shipPrice.fontSize = 60
            shipPrice.position.y -= 15
        }
        shipPrice.zPosition = 3

        self.addChild(background)
        self.addChild(headerLogo)
        self.addChild(shopWindow)
        self.addChild(shopHeader)
        self.addChild(shopShipPlaceholder)
        self.addChild(shipImage)
        self.addChild(shipHealth)
        self.addChild(shipPrice)
        self.addChild(backButton)
        self.addChild(backwardButton)
        self.addChild(forwardButton)
        self.addChild(selectButton)
        self.addChild(buyButton)
    }
    
    func updateShipDisplay(){
        self.currentSelectedShip = UserDefaults.standard.integer(forKey: "currentSelectedShip")
//        self.shipImage = SKSpriteNode(imageNamed: self.shipDictionary[self.currentSelectedShip]!)
        let newTexture = SKTexture(imageNamed: self.shipDictionary[currentSelectedShip]!)
        self.shipImage.texture = newTexture
        self.shipHealth.text = "Health: \(GameManager.PlayerHealthInformation[UserDefaults.standard.integer(forKey: "currentSelectedShip")]!)"
        //Buy Status
        if GameManager.shipBought.contains(UserDefaults.standard.integer(forKey: "currentSelectedShip")){
            shipPrice.position = buyButton.position
            shipPrice.text = "Acquired"
            shipPrice.fontSize = 40
            shipPrice.position.y -= 10
        }else{
            shipPrice.position = buyButton.position
            shipPrice.text = String(GameManager.ShipPrice[UserDefaults.standard.integer(forKey: "currentSelectedShip")]!)
            shipPrice.fontSize = 60
            shipPrice.position.y -= 15
        }
        
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
