//
//  Achievement2.swift
//  PC Invader
//
//  Created by An on 9/5/23.
//

import Foundation
import SpriteKit

class Achievement2: SKSpriteNode {
    var achievementDescription: String
    var achievementName: String
    let highScore = UserDefaults.standard.integer(forKey: "highScore")
    let goalScore = 1000  // Set your goal score here

    init(imageName: String, achievementName: String, achievementDescription: String) {
        let texture = SKTexture(imageNamed: imageName)
        self.achievementName = achievementName
        self.achievementDescription = achievementDescription
        
        super.init(texture: texture, color: .clear, size: texture.size())
        self.setScale(1.0)
        
        let nameLabel = SKLabelNode(fontNamed: "ethnocentric")
        nameLabel.text = self.achievementName
        nameLabel.fontSize = 40
        nameLabel.position.x += 400
        nameLabel.position.y += 50
        
        let descriptionLabel = SKLabelNode(fontNamed: "AppleSDGothicNeo-Medium")
        descriptionLabel.text = self.achievementDescription
        descriptionLabel.fontSize = 35
        descriptionLabel.position = nameLabel.position
        descriptionLabel.position.y -= 55
        descriptionLabel.position.x -= 80
        
        
        let progress = min(1.0, CGFloat(highScore) / CGFloat(goalScore))
        
        let progressBar = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 500, height: 20))
        progressBar.fillColor = .gray
        progressBar.lineWidth = 0
        progressBar.position = nameLabel.position
        progressBar.position.y -= 100
        progressBar.position.x -= 240

        let progressBarWidth = 500 * CGFloat(progress)
        let progressRect = CGRect(x: 0, y: 0, width: progressBarWidth, height: 20)
        let progressNode = SKShapeNode(rect: progressRect)
        progressNode.fillColor = .blue  // Adjust the color as needed
        progressNode.lineWidth = 0
        progressBar.addChild(progressNode)
        
        let progressText = SKLabelNode(fontNamed: "AppleSDGothicNeo-Medium")
        progressText.text = "\(String(highScore))/\(String(goalScore))"
        progressText.fontSize = 30
        progressText.position = nameLabel.position
        progressText.position.y -= 150
        progressText.position.x -= 175
        
        self.addChild(descriptionLabel)
        self.addChild(nameLabel)
        self.addChild(progressBar)
        self.addChild(progressText)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
