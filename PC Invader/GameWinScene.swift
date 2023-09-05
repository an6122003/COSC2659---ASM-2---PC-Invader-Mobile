//
//  GameWinScene.swift
//  PC Invader
//
//  Created by An on 8/23/23.
//

import Foundation
import SpriteKit

class GameWinScene: SKScene{
    let replayButton = SKSpriteNode(imageNamed: "replay-btn")
    let continueButton = SKSpriteNode(imageNamed: "continue-btn")
    let closeButton = SKSpriteNode(imageNamed: "close-btn")
    let score = GameScene.getPlayerScore()
    let highScore = UserDefaults.standard.integer(forKey: "highScore")
    
    
    override func didMove(to view: SKView) {
        GameManager.gameManager.playBackgroundMusic(fileName: "game-win", type: "mp3")

        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2
                                      , y: self.size.height/2)
        background.zPosition = 0
        
        
        let window = SKSpriteNode(imageNamed: "window")
        window.setScale(0.85)
        window.position = background.position
        window.zPosition = 1
        
        let youLoseText = SKSpriteNode(imageNamed: "you-win")
        youLoseText.position = window.position
        youLoseText.position.y += 390
        youLoseText.zPosition = 2
        
        let leftStar = SKSpriteNode(imageNamed: "star-3")
        leftStar.position = window.position
        leftStar.position.x -= 230
        leftStar.position.y += 130
        leftStar.zPosition = 3
        leftStar.setScale(0.85)
        
        let middleStar = SKSpriteNode(imageNamed: "star-3")
        middleStar.position = window.position
        middleStar.position.x += 0
        middleStar.position.y += 180
        middleStar.zPosition = 3
        middleStar.setScale(0.85)
        
        let rightStar = SKSpriteNode(imageNamed: "star-3")
        rightStar.position = window.position
        rightStar.position.x += 230
        rightStar.position.y += 130
        rightStar.zPosition = 3
        rightStar.setScale(0.85)
        
        
        let scoreText = SKSpriteNode(imageNamed: "score")
        scoreText.position = window.position
        scoreText.position.x -= 150
        scoreText.position.y -= 60
        scoreText.zPosition = 3
        scoreText.setScale(0.85)
        
        
        let scoreCollumn = SKSpriteNode(imageNamed: "table")
        scoreCollumn.position = window.position
        scoreCollumn.position.x += 150
        scoreCollumn.position.y -= 60
        scoreCollumn.zPosition = 3
        scoreCollumn.setScale(0.85)
        
        let scoreLabel = SKLabelNode(fontNamed: "ethnocentric")
        scoreLabel.text = String(score)
        scoreLabel.zPosition = 4
        scoreLabel.position = scoreCollumn.position
        scoreLabel.position.y -= 13
        scoreLabel.fontSize = 50
        
        let recordText = SKSpriteNode(imageNamed: "record")
        recordText.position = window.position
        recordText.position.x -= 170
        recordText.position.y -= 160
        recordText.zPosition = 3
        recordText.setScale(0.85)
        
        let recordCollumn = SKSpriteNode(imageNamed: "table")
        recordCollumn.position = window.position
        recordCollumn.position.x += 150
        recordCollumn.position.y -= 160
        recordCollumn.zPosition = 3
        recordCollumn.setScale(0.85)
        
        let highScoreLabel = SKLabelNode(fontNamed: "ethnocentric")
        highScoreLabel.text = String(highScore)
        highScoreLabel.zPosition = 4
        highScoreLabel.position = recordCollumn.position
        highScoreLabel.position.y -= 13
        highScoreLabel.fontSize = 50
        
        replayButton.position = window.position
        replayButton.position.x -= 250
        replayButton.position.y -= 320
        replayButton.zPosition = 3
        replayButton.setScale(0.85)
        
        continueButton.position = window.position
        continueButton.position.x += 0
        continueButton.position.y -= 320
        continueButton.zPosition = 3
        continueButton.setScale(0.85)
        
        closeButton.position = window.position
        closeButton.position.x += 250
        closeButton.position.y -= 320
        closeButton.zPosition = 3
        closeButton.setScale(0.85)
        
        self.addChild(background)
        self.addChild(window)
        self.addChild(youLoseText)
        self.addChild(leftStar)
        self.addChild(middleStar)
        self.addChild(rightStar)
        self.addChild(scoreText)
        self.addChild(scoreLabel)
        self.addChild(scoreCollumn)
        self.addChild(recordText)
        self.addChild(recordCollumn)
        self.addChild(highScoreLabel)
        self.addChild(replayButton)
        self.addChild(continueButton)
        self.addChild(closeButton)
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
            
            if replayButton.contains(location) {
                changeScene(sceneToMove: GameScene(size: self.size))
            }
            
            if continueButton.contains(location){
                changeScene(sceneToMove: MapScene(size: self.size))
            }
    
            if closeButton.contains(location){
                changeScene(sceneToMove: MainMenuScene(size: self.size))
            }
        }
    }
    
    
}
