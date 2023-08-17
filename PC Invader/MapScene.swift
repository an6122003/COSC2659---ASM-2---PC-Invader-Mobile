//
//  MapScene.swift
//  PC Invader
//
//  Created by An on 8/17/23.
//

import Foundation
import SpriteKit

class MapScene: SKScene{
    var levelNodeArray: [LevelNode] = []
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        
        background.position = CGPoint(x: self.size.width/2
                                      , y: self.size.height/2)
        background.zPosition = 0
        var nodePosition = background.position
        nodePosition.y -= 600
        
        let headerLogo = SKSpriteNode(imageNamed: "main-menu-header")
        headerLogo.zPosition = 1
        headerLogo.setScale(0.4)
        headerLogo.position = background.position
        headerLogo.position.y += 700
        
        createLevelNode(level: 1, positionX: nodePosition.x, positionY: nodePosition.y)
        createLevelNode(level: 2, positionX: nodePosition.x, positionY: nodePosition.y + 400)
        createLevelNode(level: 3, positionX: nodePosition.x, positionY: nodePosition.y + 800)
        createLevelNode(level: 4, positionX: nodePosition.x, positionY: nodePosition.y + 1200)
        createLevelNode(level: 5, positionX: nodePosition.x, positionY: nodePosition.y + 1600)
        createLevelNode(level: 6, positionX: nodePosition.x, positionY: nodePosition.y + 2000)
        
        self.addChild(background)
        self.addChild(headerLogo)
        
        
        func createLevelNode(level: Int, positionX: CGFloat, positionY: CGFloat){
            let node = LevelNode(imageName: "level-node"
                                 , level: level
                                 , positionX: positionX
                                 , positionY: positionY)
            node.zPosition = 1
//            node.position = CGPoint(x: positionX, y: positionY)
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
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let location = touch.location(in: self)
//
//            if startButton.contains(location) {
//                // The replay button was clicked, perform your function here
//                changeScene(sceneToMove: GameScene(size: self.size))
//            }
//        }
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            for node in levelNodeArray {
                if node.contains(location){
                    changeToGameScene(level: node.level)
                }
            }
        }
    }
    
    func changeScene(sceneToMove: SKScene){
        sceneToMove.size = self.size
        sceneToMove.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 1)
        self.view?.presentScene(sceneToMove, transition: transition)
    }
    
    func changeToGameScene(level: Int){
        GameScene.setLevel(level: level)
        changeScene(sceneToMove: GameScene(size: self.size))
    }
  
}


