//
//  LeaderboardScene.swift
//  PC Invader
//
//  Created by An on 9/5/23.
//

import Foundation
import SpriteKit

class LeaderboardScene: SKScene{
    var backButton: SKSpriteNode!
    var leaderboardFrame: SKSpriteNode!
    let leaderboardData: [String: Int] = [
            "Player 1": 5000,
            "Player 2": 7000,
            "Player 3": 3000,
            "Player 4": 5000,
            "Player 5": 7000,
            "Player 6": 3000,
            "Player 7": 5000,
            "Player 8": 7000,
            "Player 9": 3000,
        ]
    
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
        
        leaderboardFrame = SKSpriteNode(imageNamed: "leaderboard-frame")
        leaderboardFrame.position = background.position
        leaderboardFrame.zPosition = 1
        leaderboardFrame.setScale(0.8)
        
        backButton = SKSpriteNode(imageNamed: "map-back-button")
        backButton.position = CGPoint(x: self.size.width * 0.25, y: self.size.height * 0.95)
        backButton.zPosition = 5
        backButton.setScale(0.5)
        
        self.addChild(background)
        self.addChild(headerLogo)
        self.addChild(leaderboardFrame)
        self.addChild(backButton)
        displayLeaderboard()
    }
    
    func displayLeaderboard() {
            // Sort the leaderboard data by high scores in descending order.
            let sortedLeaderboard = leaderboardData.sorted { $0.value > $1.value }
            
            var initialPosition = self.leaderboardFrame!.position.y + 650
            var yOffset: CGFloat = 300  // Adjust this value based on your design.
            
            // Iterate through the sorted data and create labels for player names and high scores.
            for (rank, (playerName, highScore)) in sortedLeaderboard.enumerated() {
                let nameLabel = SKLabelNode(fontNamed: "ethnocentric")
                nameLabel.text = "\(rank + 1). \(playerName)"
                nameLabel.fontSize = 50
                nameLabel.horizontalAlignmentMode = .left
                nameLabel.position = CGPoint(x: self.size.width / 2 - 325, y: initialPosition - yOffset)
                nameLabel.zPosition = 3
                self.addChild(nameLabel)
                
                let scoreLabel = SKLabelNode(fontNamed: "ethnocentric")
                scoreLabel.text = "\(highScore)"
                scoreLabel.fontSize = 50
                scoreLabel.horizontalAlignmentMode = .right
                scoreLabel.position = CGPoint(x: self.size.width / 2 + 335, y: initialPosition - yOffset)
                scoreLabel.zPosition = 3
                self.addChild(scoreLabel)
                
                yOffset += 100  // Adjust this value to control the vertical spacing between entries.
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
        }
    }
}
