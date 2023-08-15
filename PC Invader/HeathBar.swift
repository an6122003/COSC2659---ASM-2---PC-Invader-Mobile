//
//  HeathBar.swift
//  PC Invader
//
//  Created by An on 8/15/23.
//

import Foundation
import SpriteKit

class HealthBar: SKNode {
    private let leftBracket: SKSpriteNode
    private let rightBracket: SKSpriteNode
    let initialPlayerHealth: Int
    let player: Player
    
    private var redRectangles: [SKSpriteNode] = []
    private var greyRectangles: [SKSpriteNode] = []
    
    init(player: Player) {
        leftBracket = SKSpriteNode(imageNamed: "left-bracket.png")
        rightBracket = SKSpriteNode(imageNamed: "right-bracket.png")
//        redRectangle = SKSpriteNode(imageNamed: "active-segment.png")
//        greyRectangle = SKSpriteNode(imageNamed:"inactive-segment.png")
        initialPlayerHealth = player.health
        self.player = player
        
        super.init()
        
        addChild(leftBracket)
        
        var startingWidth = leftBracket.position.x
        
        for _ in 0..<initialPlayerHealth {
            let redRectangle = SKSpriteNode(imageNamed: "active-segment.png")
            startingWidth += 4
            redRectangle.position.x = startingWidth
            
            addChild(redRectangle)
//            addChild(greyRectangle)
        }
        
        rightBracket.position.x = startingWidth + 4
        addChild(rightBracket)
        
    }
    
    func updateHealthBar(){
        self.removeAllChildren()
        
        addChild(leftBracket)
        
        var startingWidth = leftBracket.position.x
        
        for index in 0..<initialPlayerHealth {
            let redRectangle = SKSpriteNode(imageNamed: "active-segment.png")
            let greyRectangle = SKSpriteNode(imageNamed:"inactive-segment.png")
            startingWidth += 4
            
            if index < self.player.health{
                redRectangle.position.x = startingWidth
                addChild(redRectangle)
            }else{
                greyRectangle.position.x = startingWidth
                addChild(greyRectangle)
            }
        }
        
        rightBracket.position.x = startingWidth + 4
        addChild(rightBracket)
        print(player.health)
    }
    
//    func updateHealth(percentage: CGFloat) {
//        let newWidth = (redRectangle.size.width + greyRectangle.size.width) * percentage
//        redRectangle.size.width = max(newWidth, 0)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

