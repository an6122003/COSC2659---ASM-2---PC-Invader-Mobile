//
//  GameScene.swift
//  PC Invader
//
//  Created by An on 8/12/23.
//

import SpriteKit

class GameScene: SKScene {
    
    var lastUpdateTime: TimeInterval = 0
    var timeSinceLastBullet: TimeInterval = 0
    let bulletDelay: TimeInterval = 0.1 // Adjust this delay as needed

    override func didMove(to view: SKView) {
        // initiate background
        var inGameBackGround = InGameBackground(textureName: "background"
                                                , position: CGPoint(x: self.size.width/2, y: self.size.height/2)
                                                , size: self.size
                                                , zPosition: 0)

        // initiate player
        var player = Player(textureName: "player-ship"
                            , zPosition: 2
                            , position: CGPoint(x: self.size.width/2, y: self.size.height/5)
                            , scale: 1)
        
        player.zRotation = CGFloat.pi / 2 // rotate 90 degree counter clockwise
        
        
        // add all node to the scene
        self.addChild(inGameBackGround)
        self.addChild(player)
    }
    
//    func shootBullet(){
//        let bullet =  SKSpriteNode(imageNamed: "bullet 1")
//        bullet.position =  player.position
//        bullet.zPosition = 1
//        bullet.zRotation = CGFloat.pi / 2 // rotate 90 degree counter clockwise
//        bullet.setScale(10)
//        self.addChild(bullet)
//        
//        let bulletMove = SKAction.moveTo(y: self.size.height, duration: 1)
//        let deleteBullet = SKAction.removeFromParent()
//        let bulletSequence = SKAction.sequence([bulletMove, deleteBullet])
//        bullet.run(bulletSequence)
//    }
//    
//    override func update(_ currentTime: TimeInterval) {
//        // Calculate time since last update
//        if lastUpdateTime == 0 {
//            lastUpdateTime = currentTime
//        }
//        let deltaTime = currentTime - lastUpdateTime
//        lastUpdateTime = currentTime
//        
//        // Update time since last bullet
//        timeSinceLastBullet += deltaTime
//        
//        // Shoot bullet if the desired delay has passed
//        if timeSinceLastBullet >= bulletDelay {
//            shootBullet()
//            timeSinceLastBullet = 0
//        }
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches{
//            let touchLocation = touch.location(in: self)
//            let previousTouchLocation = touch.previousLocation(in: self)
//            let distanceDragX = touchLocation.x - previousTouchLocation.x
//            let distanceDragY = touchLocation.y - previousTouchLocation.y
//            print(distanceDragX)
//            print(distanceDragY)
//
//            player.position.x += distanceDragX
//            player.position.y += distanceDragY
//        }
//    }
    
}

