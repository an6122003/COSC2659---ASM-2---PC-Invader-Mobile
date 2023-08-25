//
//  GameScene.swift
//  PC Invader
//
//  Created by An on 8/12/23.
//

import SpriteKit
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate {
    static var level: Int = 1
    var player: Player!
    var healthBar: HealthBar!
    var spawnManager: SpawnManager?
    var lastUpdateTime: TimeInterval = 0
    var timeSinceLastBullet: TimeInterval = 0
    let bulletDelay: TimeInterval = 0.1 // Adjust this delay as needed
    var timeSinceLastEnemySpawn: TimeInterval = 0
    let spawnDelay: TimeInterval = 3 // Adjest time to spawn enemy wave
    static var playerScore: Int = 0
    let scoreLabel = SKLabelNode(fontNamed: "ethnocentric")
    

    
    enum gameState{
        case Menu
        case inGame
        case gameOver
    }
    
    public static func setLevel(level: Int){
        self.level = level
    }
    
    public static func getPlayerScore() -> Int{
        return self.playerScore
    }
    
    var currentGameState = gameState.inGame
    
    override init(size: CGSize) {
        super.init(size: size)
        GameManager.gameManager.calculatePlayableArea(size: size)
        spawnManager = SpawnManager(gameScene: self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        //initate physics world
        self.physicsWorld.contactDelegate = self
        
        // initiate background
        let inGameBackGround = InGameBackground(textureName: "background"
                                                , position: CGPoint(x: self.size.width/2, y: self.size.height/2)
                                                , size: self.size
                                                , zPosition: 0)

        // initiate player
        player = Player(textureName: "player-ship-0"
                            , zPosition: 2
                            , position: CGPoint(x: self.size.width/2, y: self.size.height/5)
                            , scale: 1
                            , trailEmitterName: "MyParticle"
                            , health: 5)
        
        healthBar = HealthBar(player: player)
        healthBar.position = CGPoint(x: size.width / 4, y: size.height * 0.9)
        healthBar.setScale(10)
        healthBar.zPosition = 4
        addChild(healthBar)
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size) //physics body size = self.size
        player.physicsBody!.affectedByGravity = false //remove affect of gravity
        player.physicsBody?.categoryBitMask = physicsCategories.Player // asign this physics body into category of Player
        player.physicsBody?.collisionBitMask = physicsCategories.None
        player.physicsBody?.contactTestBitMask = physicsCategories.Enemy
        
        
        player.zRotation = CGFloat.pi / 2 // rotate 90 degree counter clockwise
        
        GameScene.playerScore = 0
        scoreLabel.text = "Score: \(GameScene.playerScore)"
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        scoreLabel.position = CGPoint(x: self.size.width*0.75, y: self.size.height*0.9)
        scoreLabel.zPosition = 3
        
        
        // add all node to the scene
        self.addChild(inGameBackGround)
        self.addChild(player)
        self.addChild(player.trailEmitter)
        self.addChild(scoreLabel)
        spawnManager?.spawnEnemiesForLevel(level: GameScene.level)

//        spawnEnemyPerSecond(timeInterval: 1)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) { // This function process contact of 2 bodies call Body A and Body B
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask { // Ensure when a contact happens, the body with lower categoryBitMask will always be Body 1, so don't need to check a type of 1 body for 2 time (Body A and B)
            body1 = contact.bodyA
            body2 = contact.bodyB
        }else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == physicsCategories.Bullet && body2.categoryBitMask == physicsCategories.Enemy {
            // Bullet hit Enemy
            if let enemy = body2.node as? Enemy {
                enemy.health -= 1
                GameScene.playerScore += 1
                scoreLabel.text = "Score: \(GameScene.playerScore)"
                
                if enemy.health <= 0 {
                    spawnExplosion(position: enemy.position, explosionName: "explosion")
                    enemy.removeFromParent()
                    GameScene.playerScore += 10
                    scoreLabel.text = "Score: \(GameScene.playerScore)"
                }
            }
            
            if body2.node != nil && body2.node!.position.y < self.size.height {
//                spawnExplosion(position: body2.node!.position, explosionName: "explosion")
            }
            
            body1.node?.removeFromParent()
        }
        
        if body1.categoryBitMask == physicsCategories.Player && body2.categoryBitMask == physicsCategories.Enemy{
            // Player hit Enemy
            if body1.node != nil{
                spawnExplosion(position: body1.node!.position, explosionName: "explosion")
            }// prevent error if there the node not exist
            
            if body2.node != nil{
                spawnExplosion(position: body2.node!.position, explosionName: "explosion")
            } // prevent error if there the node not exist
            
//            body1.node?.removeFromParent() //TODO: Remove the trail
            body2.node?.removeFromParent()
            playerHit()
            print("Player Health: ", player.health!)
            healthBar.updateHealthBar()

        }
        
        if body1.categoryBitMask  == physicsCategories.Player && body2.categoryBitMask == physicsCategories.enemyBullet {
            playerHit()
            healthBar.updateHealthBar()
            if body2.node != nil{
                spawnExplosion(position: player.position, explosionName: "explosion")
                body2.node?.removeFromParent()
            }
            
        }
    }
    
    func playerHit(){
        player.health -= 1
        if player.health == 0{
        if UserDefaults.standard.integer(forKey: "highScore") < GameScene.playerScore{
            UserDefaults.standard.set(GameScene.playerScore, forKey: "highScore")
        }
            gameOver()
        }
    }
    
    func gameOver(){
        currentGameState = gameState.gameOver
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Bullet"){
            bullet, arg in
            bullet.removeAllActions()
        }
        
        self.enumerateChildNodes(withName: "Enemy"){
            enemy, arg in
            enemy.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run { [self] in
            changeScene(sceneToMove: GameOverScene())
        }
        let wait = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([wait, changeSceneAction])
        self.run(changeSceneSequence)
    }
    
    func gameWin(){
        currentGameState = gameState.gameOver
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Bullet"){
            bullet, arg in
            bullet.removeAllActions()
        }
        
        self.enumerateChildNodes(withName: "Enemy"){
            enemy, arg in
            enemy.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run { [self] in
            changeScene(sceneToMove: GameWinScene())
        }
        let wait = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([wait, changeSceneAction])
        self.run(changeSceneSequence)
    }
    
    func changeScene(sceneToMove: SKScene){
        sceneToMove.size = self.size
        sceneToMove.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 1)
        self.view?.presentScene(sceneToMove, transition: transition)
    }
    
    func spawnExplosion(position: CGPoint, explosionName: String){
        let explosion = SKSpriteNode(imageNamed: explosionName)
        explosion.position = position
        explosion.zPosition = 3
        self.addChild(explosion)
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let deleteExplosion = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([fadeIn, fadeOut, deleteExplosion])
        explosion.run(explosionSequence)
    }
    
    struct physicsCategories{ //We arrange the physics bodies into different categories, so we can manage the interaction more efficient
        static let None: UInt32 = 0 // for contact with nothing
        static let Player: UInt32 = 0b1 // 1 in binary
        static let Bullet: UInt32 = 0b10 // 2 in binary
        static let Enemy: UInt32 = 0b100 // 4 in binary, 3 will represent bot Player and Bullet (1 and 2)
        static let enemyBullet: UInt32 = 0b1000
        
    }
    
    func randomFloat() -> CGFloat{ // Return a random float
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func randomFloat(min: CGFloat, max: CGFloat) -> CGFloat{
        return randomFloat() * (max - min) + min
    }
    
//    func spawnEnemy(){
//        spawnManager?.spawnEnemiesForLevel(level: 2)
//    }
//
//    func spawnEnemyPerSecond(timeInterval: Float) {
//
//        let spawnEnemyAction = SKAction.run { [weak self] in
//                self?.spawnEnemy()
//            }
//        let wait = SKAction.wait(forDuration: TimeInterval(timeInterval), withRange: 0.1)
//        let spawnSequence = SKAction.sequence([spawnEnemyAction, wait])
//        let spawnForever = SKAction.repeatForever(spawnSequence)
//        self.run(SKAction.repeatForever(spawnForever))
//    }

    
    func shootBullet(){
        if let playerPosition = player?.position{
            if currentGameState == gameState.inGame{
                let bullet = Bullet(textureName: "bullet 1"
                                    , position: playerPosition
                                    , zPosition: 1
                                    , scale: 10
                                    , soundName: "shooting.wav")
                bullet.zRotation = CGFloat.pi / 2 // rotate 90 degree counter clockwise
                bullet.setScale(10)
                bullet.name = "Bullet" // Name to gather all bullet objects to dispose later
                bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size) // physics body of bullet
                bullet.physicsBody?.affectedByGravity = false
                bullet.physicsBody?.categoryBitMask = physicsCategories.Bullet
                bullet.physicsBody?.collisionBitMask = physicsCategories.None
                bullet.physicsBody?.contactTestBitMask = physicsCategories.Enemy
                
                self.addChild(bullet)
                
                let bulletMove = SKAction.moveTo(y: self.size.height, duration: 1)
                let deleteBullet = SKAction.removeFromParent()
                let playSoundBullet = bullet.soundSkAction!
                let bulletSequence = SKAction.sequence([ bulletMove, deleteBullet]) //TODO: add playSoundBullet to the sequence
                bullet.run(bulletSequence)
            }
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
        
        timeSinceLastEnemySpawn += deltaTime
        
        if timeSinceLastEnemySpawn >= spawnDelay {
//            spawnManager?.spawnEnemiesForLevel(level: GameScene.level)
            timeSinceLastEnemySpawn = 0
        }
//        print("timeSinceLastBullet: \(timeSinceLastBullet)")
//        print("timeSinceLastEnemySpawn: \(timeSinceLastEnemySpawn)")
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.location(in: self)
            let previousTouchLocation = touch.previousLocation(in: self)
            let distanceDragX = touchLocation.x - previousTouchLocation.x
            let distanceDragY = touchLocation.y - previousTouchLocation.y
            
            if let playerPosition = player?.position{
                if currentGameState == gameState.inGame{
                    player.position.x += distanceDragX
                    player.position.y += distanceDragY
                    player.trailEmitter.position.x += distanceDragX
                    player.trailEmitter.position.y += distanceDragY
    //                player.trailEmitter.emissionAngle = atan2(distanceDragY, distanceDragX) + CGFloat.pi / 2
    //                print("Player X: \(playerPosition.x)")
    //                print("Player Y: \(playerPosition.y)")
    //                print("Player Trail X: \(playerPosition.x)")
    //                print("Player Trail Y: \(playerPosition.y)")
                }
            }
            //Constraint in x for player to stay within game area
            if player.position.x > GameManager.gameManager.gamePlayableArea!.maxX - player.size.width/2{
                player.position.x = GameManager.gameManager.gamePlayableArea!.maxX - player.size.width/2
                player.trailEmitter.position.x = GameManager.gameManager.gamePlayableArea!.maxX - player.size.width/2
                player.trailEmitter.position.x += 5
            }
            
            if player.position.x < GameManager.gameManager.gamePlayableArea!.minX + player.size.width/2{
                player.position.x = GameManager.gameManager.gamePlayableArea!.minX + player.size.width/2
                player.trailEmitter.position.x = GameManager.gameManager.gamePlayableArea!.minX + player.size.width/2
                player.trailEmitter.position.x += 5
            }
            
            //Constraint in y for player to stay within game area
            if player.position.y > GameManager.gameManager.gamePlayableArea!.maxY - player.size.height/2{
                player.position.y = GameManager.gameManager.gamePlayableArea!.maxY - player.size.height/2
                player.trailEmitter.position.y = GameManager.gameManager.gamePlayableArea!.maxY - player.size.height/2
            }
            
            if player.position.y < GameManager.gameManager.gamePlayableArea!.minY + player.size.height/2{
                player.position.y = GameManager.gameManager.gamePlayableArea!.minY + player.size.height/2
                player.trailEmitter.position.y = GameManager.gameManager.gamePlayableArea!.minY + player.size.height/2
            }
        }
    }
    
}

