//
//  MapScene.swift
//  PC Invader
//
//  Created by An on 8/17/23.
//

import Foundation
import SwiftUI
import SpriteKit

class MapScene: SKScene{
    var headerRect: CGRect!
    var levelNodeArray: [LevelNode] = []
    var lineArray: [SKShapeNode] = []
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
        
        headerRect = CGRect(x: 0, y: 1500, width: self.size.width, height: 600)
        
        //
//        let headerRectNode = SKShapeNode(rect: headerRect)
//        headerRectNode.fillColor = SKColor.red.withAlphaComponent(0.5) // Adjust the color and opacity as needed
//        headerRectNode.zPosition = 2 // Ensure it's behind the headerLogo
//        self.addChild(headerRectNode)
        //
        
        backButton = SKSpriteNode(imageNamed: "map-back-button")
        backButton.position = CGPoint(x: self.size.width * 0.25, y: self.size.height * 0.95)
        backButton.zPosition = 5
        backButton.setScale(0.5)
        
        self.addChild(background)
        self.addChild(headerLogo)
        self.addChild(backButton)
        createNodes()
        connectNodesWithLines()
        updateLevelNodeZPosition()

        func createLevelNode(level: Int, positionX: CGFloat, positionY: CGFloat){
            if level <= UserDefaults.standard.integer(forKey: "currentUnlockLevel") + 1{
                let node = LevelNode(imageName: "level-node"
                                     , level: level
                                     , positionX: positionX
                                     , positionY: positionY)
                node.zPosition = 1
                levelNodeArray.append(node)
                self.addChild(node)
            }else{
                let node = LevelNode(imageName: "level-node-bw"
                                     , level: level
                                     , positionX: positionX
                                     , positionY: positionY)
                node.zPosition = 1
                levelNodeArray.append(node)
                self.addChild(node)
            }
            
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
                    
                    let startPosition = levelNodeArray[i].position
                    let endPosition = levelNodeArray[i + 1].position
                    
                    // Set coordinate to match the origin of the screen
                    path.move(to: CGPoint(x: 0, y: 0))
                    // Draw line to end position
                    path.addLine(to: CGPoint(x: endPosition.x - startPosition.x, y: endPosition.y - startPosition.y))
                    
                    let line = SKShapeNode(path: path)
                    line.strokeColor = SKColor.systemBlue
                    line.lineWidth = 5
                    line.zPosition = 1
                    line.position = startPosition
                    
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
            let halfNodeHeight = node.size.height / 2
            let targetAlpha: CGFloat = (node.position.y - halfNodeHeight > headerBottom) ? 0 : 1
            node.run(SKAction.fadeAlpha(to: targetAlpha, duration: 0.2))
        }

        for line in lineArray {
            let halfLineHeight = line.frame.height / 2
            let condition = line.position.y + halfLineHeight > headerBottom
            let targetAlpha: CGFloat = condition ? 0 : 1
            line.run(SKAction.fadeAlpha(to: targetAlpha, duration: 0.2))
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            for node in levelNodeArray {
                if node.contains(location) && node.level <= UserDefaults.standard.integer(forKey: "currentUnlockLevel") + 1{
                    GameManager.gameManager.playSoundEffect(fileName: "click", type: ".mp3")
                    changeToGameScene(level: node.level)
                }
                
                if node.contains(location) && node.level > UserDefaults.standard.integer(forKey: "currentUnlockLevel") + 1 {
                    GameManager.gameManager.playSoundEffect(fileName: "click", type: ".mp3")
                    if let viewController = self.view?.window?.rootViewController {
                        let alert = UIAlertController(title: "Can Not Play!"
                                                      , message: "You have not unlocked this mission. Please complete previous level"
                                                      , preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        viewController.present(alert, animated: true)
                    }
                }
            }
            
            if backButton.contains(location){
                GameManager.gameManager.playSoundEffect(fileName: "click", type: ".mp3")
                changeScene(sceneToMove: MainMenuScene(size: self.size))
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


