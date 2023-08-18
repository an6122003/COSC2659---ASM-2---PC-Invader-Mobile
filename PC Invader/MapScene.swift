//
//  MapScene.swift
//  PC Invader
//
//  Created by An on 8/17/23.
//

import Foundation
import SpriteKit

class MapScene: SKScene{
    var headerRect: CGRect!
    var levelNodeArray: [LevelNode] = []
    var lineArray: [SKShapeNode] = []
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
        
        headerRect = CGRect(x: 0, y: 1500, width: self.size.width, height: 600)
        
        //
//        let headerRectNode = SKShapeNode(rect: headerRect)
//        headerRectNode.fillColor = SKColor.red.withAlphaComponent(0.5) // Adjust the color and opacity as needed
//        headerRectNode.zPosition = 2 // Ensure it's behind the headerLogo
//        self.addChild(headerRectNode)
        //
        
//        createLevelNode(level: 1, positionX: nodePosition.x, positionY: nodePosition.y)
//        createLevelNode(level: 2, positionX: nodePosition.x, positionY: nodePosition.y + 400)
//        createLevelNode(level: 3, positionX: nodePosition.x, positionY: nodePosition.y + 800)
//        createLevelNode(level: 4, positionX: nodePosition.x, positionY: nodePosition.y + 1200)
//        createLevelNode(level: 5, positionX: nodePosition.x, positionY: nodePosition.y + 1600)
//        createLevelNode(level: 6, positionX: nodePosition.x, positionY: nodePosition.y + 2000)
        createNodes()
        connectNodesWithLines()
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
        
        func createNodes() {
            var currentLevel = 1
                let positions = [
                    CGPoint(x: 1050, y: 400),
                    CGPoint(x: 950, y: 600),
                    CGPoint(x: 700, y: 625),
                    CGPoint(x: 550, y: 825),
                    CGPoint(x: 800, y: 1000),
                    CGPoint(x: 1000, y: 1150),
                    CGPoint(x: 950, y: 1400),
                    CGPoint(x: 750, y: 1225),
                    CGPoint(x: 600, y: 1450),
                    CGPoint(x: Int.random(in: 500...1050), y: 1625),
                    CGPoint(x: Int.random(in: 500...1050), y: 1800),
                    CGPoint(x: Int.random(in: 500...1050), y: 1975),
                    
    
                ]
                
                // Create node
            for position in positions {
                    createLevelNode(level: currentLevel, positionX: position.x, positionY: position.y)
                    currentLevel += 1
                }
            }
        
        func connectNodesWithLines() {
            for i in 0..<levelNodeArray.count - 1 {
                let path = CGMutablePath()
                path.move(to: levelNodeArray[i].position)
                path.addLine(to: levelNodeArray[i + 1].position)
                
                let line = SKShapeNode(path: path)
                line.strokeColor = SKColor.systemBlue
                line.lineWidth = 5
                line.zPosition = 1
                self.addChild(line)
                lineArray.append(line)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)
        
        let deltaY = location.y - previousLocation.y
        scrollMap(DeltaY: deltaY)
        updateLevelNodeZPosition()

    }
    
    func updateLevelNodeZPosition(){
        let headerBottom = headerRect.minY

        for node in levelNodeArray {
            let halfNodeHeight = node.size.height / 2 // Adjust this based on your node's height
            if node.position.y - halfNodeHeight > headerBottom {
                node.zPosition = -1 // Above the header area
            } else {
                node.zPosition = 1 // Below or within the header area
            }
        }
        
        for line in lineArray {
            let halflineHeight = line.frame.height / 2 // Adjust this based on your line's height
            if line.position.y - halflineHeight > headerBottom {
                line.zPosition = -1 // Above the header area
            } else {
                line.zPosition = 1 // Below or within the header area
            }
            print("Zposition: \(line.zPosition)")
        }
    }
    
    func scrollMap(DeltaY: CGFloat){
        for node in levelNodeArray{
            node.position.y += DeltaY
        }
        for line in lineArray{
            line.position.y += DeltaY
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


