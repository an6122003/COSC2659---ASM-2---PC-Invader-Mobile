//
//  LeaderboardScene.swift
//  PC Invader
//
//  Created by An on 9/5/23.
//

import Foundation
import SpriteKit

class LeaderboardScene: SKScene{
    var currentPage = 0
    let recordsPerPage = 10
    var totalPages: Int {
        return (leaderboardData.count) / recordsPerPage + 1 // +1 to account for 1 excess page, ex: 21/2 = 2 pages + 1 page
    }
    var backButton: SKSpriteNode!
    var nextButton: SKSpriteNode!
    var prevButton: SKSpriteNode!
    var achievementButton: SKSpriteNode!
    var leaderboardFrame: SKSpriteNode!
    var leaderboardData: [String: Int] = [
        UserDefaults.standard.string(forKey: "playerName")!: UserDefaults.standard.integer(forKey: "highScore"),
        "Tom": 500,
        "Anna": 700,
        "Bao": 300,
        "Xiaomi": 500,
        "Shelby": 700,
        "Anh": 300,
        "Player 7": 500,
        "Player 8": 700,
        "Player 9": 300,
        "Player 10": 500,
        "Player 11": 700,
        "Player 12": 300,
    ]
    
    override func didMove(to view: SKView) {
        for i in 1...50 {
            let randomName = "Player \(i + 12)"
            let randomScore = Int.random(in: 1...1000)
            leaderboardData[randomName] = randomScore
        }
        
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
        backButton.zPosition = 3
        backButton.setScale(0.5)
        
        // buttons for navigation of the leaderboard
        nextButton = SKSpriteNode(imageNamed: "shop-forward-button")
        nextButton.position = CGPoint(x: leaderboardFrame.position.x + 350, y: leaderboardFrame.position.y - 700)
        nextButton.zPosition = 3
        nextButton.setScale(0.7)
        
        prevButton = SKSpriteNode(imageNamed: "shop-backward-button")
        prevButton.position = CGPoint(x: leaderboardFrame.position.x - 350, y: leaderboardFrame.position.y - 700)
        prevButton.zPosition = 3
        prevButton.setScale(0.7)
        
        let sortedLeaderboard = leaderboardData.sorted { $0.value > $1.value } // sort by descending order
        var playerRank = -1

        for (index, (playerName, _)) in sortedLeaderboard.enumerated() {
            if playerName == UserDefaults.standard.string(forKey: "playerName")! {
                playerRank = index + 1
                break // Exit the loop as the player's rank is found
            }
        }

        // Player current rank label
        let playerRankLabel = SKLabelNode(fontNamed: "ethnocentric")
        playerRankLabel.fontSize = 45
        playerRankLabel.position = CGPoint(x: leaderboardFrame.position.x, y: leaderboardFrame.position.y - 700)
        if playerRank != -1 {
            playerRankLabel.text = "Your Rank: \(playerRank)"
        } else {
            playerRankLabel.text = "Your Rank: N/A"
        }
        playerRankLabel.zPosition = 3
        
        achievementButton = SKSpriteNode(imageNamed: "shop-placeholder")
        achievementButton.position = leaderboardFrame.position
        achievementButton.position.y -= 850
        achievementButton.zPosition = 1
        achievementButton.setScale(1)
        
        let achievementButtonText = SKLabelNode(fontNamed: "ethnocentric")
        achievementButtonText.position = achievementButton.position
        achievementButtonText.text = "Achievement"
        achievementButtonText.position.y -= 5
        achievementButtonText.zPosition = 3
        achievementButtonText.fontSize = 35
        
        self.addChild(playerRankLabel)
        self.addChild(background)
        self.addChild(headerLogo)
        self.addChild(leaderboardFrame)
        self.addChild(backButton)
        self.addChild(nextButton)
        self.addChild(prevButton)
        self.addChild(achievementButton)
        self.addChild(achievementButtonText)
        displayLeaderboard(page: currentPage)
    }
    
    func displayLeaderboard(page: Int) {
        
        let startIndex = page * recordsPerPage // first record of each page
        let endIndex = min(startIndex + recordsPerPage, leaderboardData.count) // In case their are less then 10 record per page
        let sortedLeaderboard = leaderboardData.sorted { $0.value > $1.value } // sort by descending order

        // Clear previous record
        self.enumerateChildNodes(withName: "record"){
            record, arg in
            record.removeFromParent()
        }

        // Display leaderboard for the current page
        var initialPosition = self.leaderboardFrame!.position.y + 690
        var yOffset: CGFloat = 300

        for (index, (playerName, highScore)) in sortedLeaderboard[startIndex..<endIndex].enumerated() { //..< means from startIndex to less than endIndex
            let rank = startIndex + (index + 1)
            let nameLabel = SKLabelNode(fontNamed: "ethnocentric")
            if playerName == UserDefaults.standard.string(forKey: "playerName")!{
                nameLabel.fontColor = .yellow
            }
            nameLabel.text = "\(rank). \(playerName)"
            nameLabel.fontSize = 50
            nameLabel.horizontalAlignmentMode = .left
            nameLabel.position = CGPoint(x: self.size.width / 2 - 325, y: initialPosition - yOffset)
            nameLabel.zPosition = 3
            nameLabel.name = "record"
            self.addChild(nameLabel)

            let scoreLabel = SKLabelNode(fontNamed: "ethnocentric")
            if playerName == UserDefaults.standard.string(forKey: "playerName")!{
                scoreLabel.fontColor = .yellow
            }
            scoreLabel.text = "\(highScore)"
            scoreLabel.fontSize = 50
            scoreLabel.horizontalAlignmentMode = .right
            scoreLabel.position = CGPoint(x: self.size.width / 2 + 335, y: initialPosition - yOffset)
            scoreLabel.zPosition = 3
            scoreLabel.name = "record"
            self.addChild(scoreLabel)
            
            yOffset += 100
        }
    }
    
    
    func nextPage() {
        if currentPage < totalPages - 1 {
            currentPage += 1
            displayLeaderboard(page: currentPage)
        }
    }

    func prevPage() {
        if currentPage > 0 {
            currentPage -= 1
            displayLeaderboard(page: currentPage)
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
                GameManager.gameManager.playSoundEffect(fileName: "click", type: ".mp3")
                changeScene(sceneToMove: MainMenuScene(size: self.size))
            }
            
            if nextButton.contains(location){
                GameManager.gameManager.playSoundEffect(fileName: "click", type: ".mp3")
                nextPage()
            }
            
            if prevButton.contains(location){
                GameManager.gameManager.playSoundEffect(fileName: "click", type: ".mp3")
                prevPage()
            }
            
            if achievementButton.contains(location){
                GameManager.gameManager.playSoundEffect(fileName: "click", type: ".mp3")
                changeScene(sceneToMove: AchievementScene(size: self.size))
            }
        }
    }
}
