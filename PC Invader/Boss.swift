////
////  Boss.swift
////  PC Invader
////
////  Created by An on 9/4/23.
////
//
//import Foundation
//
//
//func move(positionPercentage: CGFloat) {
//    let endPosition = CGPoint(x: self.position.x, y: GameManager.gameManager.gamePlayableArea!.size.height * positionPercentage)
//    
//    let moveEnemyToEndPosition = SKAction.move(to: endPosition, duration: 5)
//    let moveEnemyLeft = SKAction.moveTo(x: self.position.x - 60, duration: 2)
//    let moveEnemyRight = SKAction.moveTo(x: self.position.x + 60, duration: 2)
//    let moveDownSequence = SKAction.sequence([moveEnemyToEndPosition])
//    let moveLeftRightSequence = SKAction.repeatForever(SKAction.sequence([moveEnemyLeft, moveEnemyRight]))
//    self.run(moveDownSequence)
//    self.run(moveLeftRightSequence)
//}
//
//override func shoot(gameScene: GameScene) {
//    let bulletSpeed: TimeInterval = 10.0 // Adjust bullet speed as needed
//
//    // Create a central bullet
//    let centralBullet = createBullet(textureName: "circular-enemy-bullet",
//                                     position: self.position,
//                                     zPosition: 3,
//                                     scale: 0.3,
//                                     soundName: "shooting.wav")
//
//    centralBullet.zRotation = -CGFloat.pi * 0.75
//    gameScene.addChild(centralBullet)
//
//    // Create bullets moving in a circular pattern around the central bullet
//    let numBullets = 8 // Adjust the number of bullets as needed
//
//    for i in 0..<numBullets {
//        let angle = CGFloat(i) * (2 * CGFloat.pi / CGFloat(numBullets))
//        let xOffset = cos(angle) * 50 // Adjust the radius of the circular pattern
//        let yOffset = sin(angle) * 50 // Adjust the radius of the circular pattern
//
//        let circularBullet = createBullet(textureName: "circular-enemy-bullet",
//                                          position: self.position,
//                                          zPosition: 3,
//                                          scale: 0.3,
//                                          soundName: "shooting.wav")
//
//        circularBullet.position.x += xOffset
//        circularBullet.position.y += yOffset
//        circularBullet.zRotation = angle
//        gameScene.addChild(circularBullet)
//
//        // Move the circular bullets
//        let endPosition = CGPoint(x: self.position.x + xOffset, y: -gameScene.size.height * 0.1)
//        let bulletMove = SKAction.move(to: endPosition, duration: bulletSpeed)
//        circularBullet.run(SKAction.sequence([bulletMove, SKAction.removeFromParent()]))
//    }
//}
//
//func createBullet(textureName: String, position: CGPoint, zPosition: CGFloat, scale: CGFloat, soundName: String) -> Bullet {
//    let bullet = Bullet(textureName: textureName,
//                        position: position,
//                        zPosition: zPosition,
//                        scale: scale,
//                        soundName: soundName)
//
//    bullet.name = "Bullet" // Name to gather all bullet objects to dispose later
//    bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size) // physics body of bullet
//    bullet.physicsBody?.affectedByGravity = false
//    bullet.physicsBody?.categoryBitMask = GameScene.physicsCategories.enemyBullet
//    bullet.physicsBody?.collisionBitMask = GameScene.physicsCategories.None
//    bullet.physicsBody?.contactTestBitMask = GameScene.physicsCategories.Player
//
//    return bullet
//}
//
//func shootLoop(gameScene: GameScene, fireRate: CGFloat ) {
//    let shootAction = SKAction.run { [weak self] in
//        self?.shoot(gameScene: gameScene)
//    }
//    let waitAction = SKAction.wait(forDuration: fireRate) // Adjust the duration as needed
//    let shootSequence = SKAction.sequence([waitAction, shootAction])
//    let loopAction = SKAction.repeatForever(shootSequence)
//    run(loopAction)
//}
