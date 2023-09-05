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
    var nextButton: SKSpriteNode!
    var prevButton: SKSpriteNode!
    var unlockButton: SKSpriteNode!
    var currentPage = 0
    var headerText: SKLabelNode!
    var background: SKSpriteNode!
    override func didMove(to view: SKView) {
        background = SKSpriteNode(imageNamed: "background")
        
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
        
        headerText = SKLabelNode(fontNamed: "ethnocentric")
        headerText.zPosition = 1
        headerText.text = "How to play"
        headerText.position = headerLogo.position
        headerText.position.y -= 250
        headerText.fontSize = 80
        
        backButton = SKSpriteNode(imageNamed: "map-back-button")
        backButton.position = CGPoint(x: self.size.width * 0.25, y: self.size.height * 0.95)
        backButton.zPosition = 5
        backButton.setScale(0.5)
        
        nextButton = SKSpriteNode(imageNamed: "shop-forward-button")
        nextButton.position = CGPoint(x: background.position.x + 350, y: background.position.y - 700)
        nextButton.zPosition = 3
        nextButton.setScale(0.7)
        
        prevButton = SKSpriteNode(imageNamed: "shop-backward-button")
        prevButton.position = CGPoint(x: background.position.x - 350, y: background.position.y - 700)
        prevButton.zPosition = 3
        prevButton.setScale(0.7)
        
        unlockButton = SKSpriteNode(imageNamed: "shop-placeholder")
        unlockButton.position = CGPoint(x: background.position.x, y: background.position.y - 700)
        unlockButton.zPosition = 1
        unlockButton.setScale(0.9)
        
        let unlockText = SKLabelNode(fontNamed: "ethnocentric")
        unlockText.position = unlockButton.position
        unlockText.position.y -= 10
        unlockText.zPosition = 2
        unlockText.text = "Unlock All"
        unlockText.fontSize = 36
        
        self.addChild(background)
        self.addChild(headerLogo)
        self.addChild(headerText)
        self.addChild(backButton)
        self.addChild(nextButton)
        self.addChild(prevButton)
        self.addChild(unlockButton)
        self.addChild(unlockText)
        
        showInstructions(page: currentPage)
        
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if backButton.contains(location){
                GameManager.gameManager.playSoundEffect(fileName: "click", type: ".mp3")
                changeScene(sceneToMove: MainMenuScene(size: self.size))
            }
            
            if nextButton.contains(location){
                GameManager.gameManager.playSoundEffect(fileName: "click", type: ".mp3")
                nextPage()
            }
            
            if prevButton.contains(location){
                GameManager.gameManager.playSoundEffect(fileName: "click", type: ".mp3")
                previousPage()
            }
             
            if unlockButton.contains(location){
                GameManager.gameManager.playSoundEffect(fileName: "click", type: ".mp3")
                UserDefaults.standard.set(10000, forKey: "playerMoney")
                UserDefaults.standard.set(11, forKey: "currentUnlockLevel")
            }
        }
    }
    
    func changeScene(sceneToMove: SKScene){
        sceneToMove.size = self.size
        sceneToMove.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 1)
        self.view?.presentScene(sceneToMove, transition: transition)
    }
    
    func showInstructions(page: Int) {
        self.enumerateChildNodes(withName: "instruction") {
            node, _ in
            node.removeFromParent()
        }

        let instructions: [String] = [
            "1. Use your spaceship to shoot down enemy ships.",
            "2. Collect crystals to upgrade your spaceship.",
            "3. Defeat the boss at level 12 to win the game.",
            "4. Unlock achievements by completing challenges."
        ]
        
        let images: [String] = [
            "how-to-play-1",
            "how-to-play-2",
            "how-to-play-3",
            "how-to-play-4",
        ]

        let instructionLabel = SKLabelNode(fontNamed: "AppleSDGothicNeo-Medium")
        instructionLabel.name = "instruction"
        instructionLabel.text = instructions[page]
        instructionLabel.fontSize = 40
        instructionLabel.position = headerText.position
        instructionLabel.position.y -= 100
        instructionLabel.zPosition = 1
        
        let image = SKSpriteNode(imageNamed: images[page])
        image.name = "instruction"
        image.position = background.position
        image.zPosition = 3
        
        self.addChild(image)
        self.addChild(instructionLabel)
    }
    
    func nextPage() {
            if currentPage < 3 {
                currentPage += 1
                showInstructions(page: currentPage)
            }
        }

    func previousPage() {
            if currentPage > 0 {
                currentPage -= 1
                showInstructions(page: currentPage)
            }
        }
}
