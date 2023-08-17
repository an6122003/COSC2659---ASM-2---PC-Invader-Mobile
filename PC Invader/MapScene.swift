//
//  MapScene.swift
//  PC Invader
//
//  Created by An on 8/17/23.
//

import Foundation
import SpriteKit

class MapScene: SKScene{
    var levelNodeArray: [SKNode] = []
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        
        background.position = CGPoint(x: self.size.width/2
                                      , y: self.size.height/2)
        background.zPosition = 0
        let bgPosition = background.position
        
        let headerLogo = SKSpriteNode(imageNamed: "main-menu-header")
        headerLogo.zPosition = 1
        headerLogo.setScale(0.4)
        headerLogo.position = background.position
        headerLogo.position.y += 700
        
        createLevelNode(level: 1, positionX: bgPosition.x, positionY: bgPosition.y)
        createLevelNode(level: 2, positionX: bgPosition.x, positionY: bgPosition.y + 200)
        createLevelNode(level: 1, positionX: bgPosition.x, positionY: bgPosition.y)
        createLevelNode(level: 2, positionX: bgPosition.x, positionY: bgPosition.y + 400)
        createLevelNode(level: 1, positionX: bgPosition.x, positionY: bgPosition.y)
        createLevelNode(level: 2, positionX: bgPosition.x, positionY: bgPosition.y + 600)
        createLevelNode(level: 1, positionX: bgPosition.x, positionY: bgPosition.y)
        createLevelNode(level: 2, positionX: bgPosition.x, positionY: bgPosition.y + 800)

        
        self.addChild(background)
        self.addChild(headerLogo)
        
        
        func createLevelNode(level: Int, positionX: CGFloat, positionY: CGFloat){
            let node = SKSpriteNode(imageNamed: "level-node")
            node.zPosition = 1
            node.position = CGPoint(x: positionX, y: positionY)
            levelNodeArray.append(node)
            self.addChild(node)
        }
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)
        
        let deltaY = location.y - previousLocation.y
        scrollMap(DeltaY: deltaY)
    }
    
    func scrollMap(DeltaY: CGFloat){
        for node in levelNodeArray{
            node.position.y += DeltaY
        }
    }
  
}


