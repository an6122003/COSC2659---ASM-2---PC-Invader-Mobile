//
//  GameScene.swift
//  PC Invader
//
//  Created by An on 8/12/23.
//

import SpriteKit

class GameScene: SKScene {
    var gamePlayableArea: CGRect
    var player: Player!
    var lastUpdateTime: TimeInterval = 0
    var timeSinceLastBullet: TimeInterval = 0
    let bulletDelay: TimeInterval = 0.1 // Adjust this delay as needed
    
    override init(size: CGSize) {
        let aspectRatio = 19.5/9.0 // aspect ratio of iphone 14 pro
        let maxPlayableWidth = size.height / aspectRatio
        let margin = (size.width - maxPlayableWidth)/2 // /2 to get 1 margin
        gamePlayableArea = CGRect(x: margin, y: 0, width: maxPlayableWidth, height: size.height)
        
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        // initiate background
        let inGameBackGround = InGameBackground(textureName: "background"
                                                , position: CGPoint(x: self.size.width/2, y: self.size.height/2)
                                                , size: self.size
                                                , zPosition: 0)

        // initiate player
        player = Player(textureName: "player-ship"
                            , zPosition: 2
                            , position: CGPoint(x: self.size.width/2, y: self.size.height/5)
                            , scale: 1)
        
        player.zRotation = CGFloat.pi / 2 // rotate 90 degree counter clockwise
        
        
        // add all node to the scene
        self.addChild(inGameBackGround)
        self.addChild(player)
    }
    
    func randomFloat() -> CGFloat{ // Return a random float
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func randomFloat(min: CGFloat, max: CGFloat) -> CGFloat{
        return randomFloat() * (max - min) + min
    }
    
    func spawnEnemy(){
        let startX = randomFloat(min: gamePlayableArea.minX
                                 , max: gamePlayableArea.maxX)
        
        let endX = randomFloat(min: gamePlayableArea.minX
                                 , max: gamePlayableArea.maxX)
        
        let startPosition = CGPoint(x: startX, y: self.size.height*1.1)
        
        let endPosition = CGPoint(x: endX, y: -self.size.height*0.1) // y coordinate is negative, under the screen
        
        let enemy = SKSpriteNode(imageNamed: "enemyShip")
        enemy.setScale(1)
        enemy.position = startPosition
        enemy.zPosition = 2
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPosition, duration: 2)
        let disposeEnemy = SKAction.removeFromParent()
        let sequenceEnemy = SKAction.sequence([moveEnemy, disposeEnemy])
        
        enemy.run(sequenceEnemy)
    }
    
    func shootBullet(){
        if let playerPosition = player?.position{
            let bullet = Bullet(textureName: "bullet 1"
                                , position: playerPosition
                                , zPosition: 1
                                , scale: 10
                                , soundName: "shooting.wav")
            bullet.zRotation = CGFloat.pi / 2 // rotate 90 degree counter clockwise
            bullet.setScale(10)
            self.addChild(bullet)
            
            let bulletMove = SKAction.moveTo(y: self.size.height, duration: 1)
            let deleteBullet = SKAction.removeFromParent()
            let playSoundBullet = bullet.soundSkAction!
            let bulletSequence = SKAction.sequence([playSoundBullet, bulletMove, deleteBullet])
            bullet.run(bulletSequence)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Calculate time since last update
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        // Update time since last bullet
        timeSinceLastBullet += deltaTime
        
        // Shoot bullet if the desired delay has passed
        if timeSinceLastBullet >= bulletDelay {
            shootBullet()
            timeSinceLastBullet = 0
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.location(in: self)
            let previousTouchLocation = touch.previousLocation(in: self)
            let distanceDragX = touchLocation.x - previousTouchLocation.x
            let distanceDragY = touchLocation.y - previousTouchLocation.y
            
            if let playerPosition = player?.position{
                player.position.x += distanceDragX
                player.position.y += distanceDragY
                print("Player X: \(playerPosition.x)")
                print("Player Y: \(playerPosition.y)")
            }
            
            if player.position.x > gamePlayableArea.maxX - player.size.width/2{
                player.position.x = gamePlayableArea.maxX - player.size.width/2
            }
            
            if player.position.x < gamePlayableArea.minX + player.size.width/2{
                player.position.x = gamePlayableArea.minX + player.size.width/2
            }
            
            spawnEnemy()
        }
    }
    
}

