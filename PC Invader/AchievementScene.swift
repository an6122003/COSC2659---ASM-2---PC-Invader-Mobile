//
//  AchievementScene.swift
//  PC Invader
//
//  Created by An on 9/5/23.
//

import Foundation
import SpriteKit

class AchievementScene: SKScene {
    var backButton: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        
        background.position = CGPoint(x: self.size.width/2
                                      , y: self.size.height/2)
        background.zPosition = 0
        var nodePosition = background.position
        nodePosition.y -= 600
        
        let headerLogo = SKSpriteNode(imageNamed: "main-menu-header")
        headerLogo.zPosition = 2
        headerLogo.setScale(0.6)
        headerLogo.position = background.position
        headerLogo.position.y += 750
        
        backButton = SKSpriteNode(imageNamed: "map-back-button")
        backButton.position = CGPoint(x: self.size.width * 0.25, y: self.size.height * 0.95)
        backButton.zPosition = 3
        backButton.setScale(0.5)
        
        self.addChild(background)
        self.addChild(headerLogo)
        self.addChild(backButton)
        createAchievementNode()
    }
    
    func createAchievementNode() {
        var initialPosition = CGPoint(x: self.size.width / 3, y: self.size.height * 0.7)
        let a = Achievement(imageName: "achievement-1",
                            achievementName: "Sharp Shooter",
                            achievementDescription: "Achieved 1000 score.",
                            currentScrore: UserDefaults.standard.integer(forKey: "highScore"),
                            goalScore: 1000)
        
        a.position = CGPoint(x: self.size.width / 3, y: self.size.height * 0.7)
        a.zPosition = 2
        initialPosition.y -= 300
        
        let b = Achievement(imageName: "achievement-2",
                            achievementName: "Killing Spree",
                            achievementDescription: "Kill 500 enemies.",
                            currentScrore: UserDefaults.standard.integer(forKey: "enemyKilled"),
                            goalScore: 500)
        
        b.position = initialPosition
        b.zPosition = 2
        initialPosition.y -= 300
        
        let c = Achievement(imageName: "achievement-3",
                            achievementName: "The Player",
                            achievementDescription: "Unlock Level 12.",
                            currentScrore: UserDefaults.standard.integer(forKey: "currentUnlockLevel") + 1,
                            goalScore: 12)
        
        c.position = initialPosition
        c.zPosition = 2
        initialPosition.y -= 300
        
        let d = Achievement(imageName: "achievement-5",
                            achievementName: "Space Dealer",
                            achievementDescription: "Own 5 spaceship.",
                            currentScrore: GameManager.shipBought.count,
                            goalScore: 5)
        
        d.position = initialPosition
        d.zPosition = 2
        initialPosition.y -= 300
        
        let e = Achievement(imageName: "achievement-4",
                            achievementName: "Rich Spaceman",
                            achievementDescription: "Acquired 10,000 crystals.",
                            currentScrore: UserDefaults.standard.integer(forKey: "playerMoney"),
                            goalScore: 10000)
        
        e.position = initialPosition
        e.zPosition = 2
        
        self.addChild(a)
        self.addChild(b)
        self.addChild(c)
        self.addChild(d)
        self.addChild(e)
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
                changeScene(sceneToMove: LeaderboardScene(size: self.size))
            }
        }
    }
}
