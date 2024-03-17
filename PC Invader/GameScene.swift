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
    let bulletDelay: TimeInterval = 0.1 // Adjust this delay for player fire rate
    var timeSinceLastEnemySpawn: TimeInterval = 0
    let spawnDelay: TimeInterval = 3 // Adjust time to spawn enemy wave
    static var playerScore: Int = 0
    let scoreLabel = SKLabelNode(fontNamed: "ethnocentric")
    let moneyLabel = SKLabelNode(fontNamed: "ethnocentric")
    static var currentMoneyEarn: Int = 0
    
    struct physicsCategories{ //We arrange the physics bodies into different categories, so we can manage the interaction more efficient
        static let None: UInt32 = 0 // for contact with nothing
        static let Player: UInt32 = 0b1 // 1 in binary
        static let Bullet: UInt32 = 0b10 // 2 in binary
        static let Enemy: UInt32 = 0b100 // 4 in binary, 3 will represent bot Player and Bullet (1 and 2)
        static let enemyBullet: UInt32 = 0b1000
        static let Money: UInt32 = 0b10000
        static let Boss: UInt32 = 0b100000
    }

    
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
        GameManager.gameManager.playBackgroundMusic(fileName: "game-scene", type: "mp3")
        //initate physics world
        self.physicsWorld.contactDelegate = self
        
        // initiate background
        for i in 0...2{
            let inGameBackGround = InGameBackground(textureName: "background"
                                                    , position: CGPoint(x: self.size.width/2, y: self.size.height*CGFloat((i)))
                                                    , size: self.size
                                                    , zPosition: 0)
            inGameBackGround.anchorPoint = CGPoint(x: 0.5, y: 0)
            inGameBackGround.name = "Background"
            self.addChild(inGameBackGround)
        }

        // initiate player
        let shipTexture = GameManager.PlayerTextureInformation[UserDefaults.standard.integer(forKey: "currentSelectedShip")]
        let shipHealth = GameManager.PlayerHealthInformation[UserDefaults.standard.integer(forKey: "currentSelectedShip")]
        let shipTrailEmitter = GameManager.PlayerTrailEmitterInformation[UserDefaults.standard.integer(forKey: "currentSelectedShip")]
        player = Player(textureName: shipTexture!
                            , zPosition: 2
                            , position: CGPoint(x: self.size.width/2, y: self.size.height/5)
                            , scale: 1
                            , trailEmitterName: shipTrailEmitter!
                            , health: shipHealth!)
        
        healthBar = HealthBar(player: player)
        healthBar.position = CGPoint(x: size.width / 4, y: size.height * 0.9)
        healthBar.setScale(10)
        healthBar.zPosition = 4
        addChild(healthBar)
        // physics body generate from sprite content
        if let playerTexture = player.texture {
            player.physicsBody = playerTexture.generatePhysicsBody() // Extension in Utils
        }
        player.physicsBody!.affectedByGravity = false //remove affect of gravity
        player.physicsBody?.categoryBitMask = physicsCategories.Player // asign this physics body into category of Player
        player.physicsBody?.collisionBitMask = physicsCategories.None
        player.physicsBody?.contactTestBitMask = physicsCategories.Enemy
        
        
//        player.zRotation = CGFloat.pi / 2 // rotate 90 degree counter clockwise
        player.position.x += 5
        GameScene.currentMoneyEarn = 0
        GameScene.playerScore = 0
        scoreLabel.text = "Score: \(GameScene.playerScore)"
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        scoreLabel.position = CGPoint(x: self.size.width*0.75, y: self.size.height*0.9)
        scoreLabel.zPosition = 3
        
        moneyLabel.text = "Crystal: \(GameScene.currentMoneyEarn)"
        moneyLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        moneyLabel.position = CGPoint(x: self.size.width*0.75, y: self.size.height*0.88)
        moneyLabel.zPosition = 3
        
        // add all node to the scene
        self.addChild(player)
        self.addChild(player.trailEmitter)
        self.addChild(scoreLabel)
        self.addChild(moneyLabel)
        spawnManager?.spawnEnemiesForLevel(level: GameScene.level)
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
            if let bullet = body1.node as? Bullet,let enemy = body2.node as? Enemy {
                enemy.health -= bullet.damage
                enemy.healthBar!.updateHealthBar(currentHealth: CGFloat(enemy.health), maxHealth: CGFloat(enemy.maxHealth))
                GameScene.playerScore += 1
                scoreLabel.text = "Score: \(GameScene.playerScore)"
                
                // Fade enemy
                let fadeOutAction = SKAction.fadeAlpha(to: 0.8, duration: 0.05)
                let fadeInAction = SKAction.fadeAlpha(to: 1.0, duration: 0.1)
                let fadeSequence = SKAction.sequence([fadeOutAction, fadeInAction])
                enemy.run(fadeSequence)

                // destroy enemy
                if enemy.health <= 0 {
                    GameManager.gameManager.playSoundEffect(fileName: "explode", type: ".mp3")
                    spawnExplosion(position: enemy.position, explosionName: "explosion")
                    let temp = randomInt(min: 1, max: 3)
                    if temp == 1{ //33% drop rate
                        dropMoney(position: enemy.position)
                    }
                    enemy.removeFromParent()
                    GameScene.playerScore += 10
                    scoreLabel.text = "Score: \(GameScene.playerScore)"
                    incrementKilledEnemyCount()
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
                if let enemy = body2.node as? Enemy {
                    enemy.healthBar?.removeFromParent()
                    incrementKilledEnemyCount()
                }
            } // prevent error if there the node not exist
            GameManager.gameManager.playSoundEffect(fileName: "explode", type: ".mp3")
            body2.node?.removeFromParent()
            
            playerHit()
            print("Player Health: ", player.health!)
            healthBar.updateHealthBar()

        }
        
        if body1.categoryBitMask  == physicsCategories.Player && body2.categoryBitMask == physicsCategories.enemyBullet {
            if body2.node != nil{
                spawnExplosion(position: player.position, explosionName: "explosion")
                body2.node?.removeFromParent()
            }
            GameManager.gameManager.playSoundEffect(fileName: "hit", type: ".wav")
            playerHit()
            healthBar.updateHealthBar()
            
            
        }
        
        if body1.categoryBitMask == physicsCategories.Player && body2.categoryBitMask == physicsCategories.Money {
            body2.node?.removeFromParent()
            GameScene.currentMoneyEarn += 1
            moneyLabel.text = "Crystal: \(GameScene.currentMoneyEarn)"
            var temp = UserDefaults.standard.integer(forKey: "playerMoney")
            UserDefaults.standard.set(temp + 1, forKey: "playerMoney")
            GameManager.gameManager.playSoundEffect(fileName: "collect", type: ".mp3")
        }
        
        if body1.categoryBitMask == physicsCategories.Bullet && body2.categoryBitMask == physicsCategories.Boss {
            // Bullet hit Enemy
            if let bullet = body1.node as? Bullet, let boss = body2.node as? BossEnemy {
                boss.health -= bullet.damage
                boss.healthBar!.updateHealthBar(currentHealth: CGFloat(boss.health), maxHealth: CGFloat(boss.maxHealth))
                GameScene.playerScore += 1
                scoreLabel.text = "Score: \(GameScene.playerScore)"
                
                // Fade boss
                let fadeOutAction = SKAction.fadeAlpha(to: 0.8, duration: 0.05)
                let fadeInAction = SKAction.fadeAlpha(to: 1.0, duration: 0.1)
                let fadeSequence = SKAction.sequence([fadeOutAction, fadeInAction])
                boss.run(fadeSequence)

                // destroy boss
                if boss.health <= 0 {
                    GameManager.gameManager.playSoundEffect(fileName: "explode", type: ".mp3")
                    spawnExplosion(position: boss.position, explosionName: "explosion")
                    boss.removeFromParent()
                    GameScene.playerScore += 10
                    scoreLabel.text = "Score: \(GameScene.playerScore)"
                    incrementKilledEnemyCount()
                    
                    let winAction = SKAction.run {
                        self.gameWin()
                    }
                    let dropMoneyAction = SKAction.run {
                        self.dropMoney(position: boss.position, ammount: 50, fadeAmount: 10)
                    }
                    let moneyDropWaitAction = SKAction.wait(forDuration: 1)
                    
                    let dropSequence = SKAction.sequence([
                        dropMoneyAction,moneyDropWaitAction,
                        dropMoneyAction,moneyDropWaitAction,
                        dropMoneyAction,moneyDropWaitAction,
                        dropMoneyAction,moneyDropWaitAction,
                        dropMoneyAction,moneyDropWaitAction,
                        dropMoneyAction,moneyDropWaitAction,
                        dropMoneyAction,moneyDropWaitAction,
                        dropMoneyAction,moneyDropWaitAction,
                        dropMoneyAction,moneyDropWaitAction,
                        dropMoneyAction,moneyDropWaitAction,
                        winAction
                    ])
                    self.run(dropSequence)
                }
            }
            
            if body2.node != nil && body2.node!.position.y < self.size.height {
            }
            
            body1.node?.removeFromParent()
        }
    }
    
    func dropMoney(position: CGPoint) {
        let randomNum = randomInt(min: 1, max: 5)
        for _ in 0...randomNum {
            let money = SKSpriteNode(imageNamed: "shop-money-symbol")
            money.setScale(1)
            money.position = position
            money.zPosition = 2
            
            money.physicsBody = SKPhysicsBody(rectangleOf: money.size)
            physicsWorld.gravity = CGVector(dx: 0, dy: -1)
            money.physicsBody?.mass = 1
            money.physicsBody?.affectedByGravity = true
            money.physicsBody?.categoryBitMask = physicsCategories.Money
            money.physicsBody?.collisionBitMask = physicsCategories.None
            money.physicsBody?.contactTestBitMask = physicsCategories.Player
            
            addChild(money)
            
            
            let spreadAction = SKAction.moveBy(x: CGFloat.random(in: -300...300), y: CGFloat.random(in: -300...300), duration: 3)
            let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
            let removeAction = SKAction.removeFromParent()
            let spreadSequence = SKAction.sequence([spreadAction, fadeOutAction, removeAction])
            money.run(spreadSequence)
        }
    }
    
    func dropMoney(position: CGPoint, ammount: Int, fadeAmount: CGFloat) {
        for _ in 0...ammount {
            let money = SKSpriteNode(imageNamed: "shop-money-symbol")
            money.setScale(1)
            money.position = position
            money.zPosition = 2
            
            money.physicsBody = SKPhysicsBody(rectangleOf: money.size)
            physicsWorld.gravity = CGVector(dx: 0, dy: -1)
            money.physicsBody?.mass = 1
            money.physicsBody?.affectedByGravity = true
            money.physicsBody?.categoryBitMask = physicsCategories.Money
            money.physicsBody?.collisionBitMask = physicsCategories.None
            money.physicsBody?.contactTestBitMask = physicsCategories.Player
            
            addChild(money)
            
            
            let spreadAction = SKAction.moveBy(x: CGFloat.random(in: -550...550), y: CGFloat.random(in: -300...300), duration: 3)
            let fadeOutAction = SKAction.fadeOut(withDuration: fadeAmount)
            let removeAction = SKAction.removeFromParent()
            let spreadSequence = SKAction.sequence([spreadAction, fadeOutAction, removeAction])
            money.run(spreadSequence)
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
        
        self.enumerateChildNodes(withName: "EnemyHealthBar"){
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
        
        self.enumerateChildNodes(withName: "EnemyHealthBar"){
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
    
    
    func randomFloat() -> CGFloat{ // Return a random float
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func randomFloat(min: CGFloat, max: CGFloat) -> CGFloat{
        return randomFloat() * (max - min) + min
    }
    
    func randomInt(min: Int, max: Int) -> Int {
        return Int.random(in: min...max)
    }

    func incrementKilledEnemyCount(){
        var temp = UserDefaults.standard.integer(forKey: "enemyKilled")
        UserDefaults.standard.set(temp + 1, forKey: "enemyKilled")
    }
    
    func shootBullet(){
        if let playerPosition = player?.position{
            if currentGameState == gameState.inGame && UserDefaults.standard.integer(forKey: "currentSelectedShip") == 0{
                let bullet = createBullet(textureName: "bullet 1"
                                          , damage: 1
                                          , position: playerPosition
                                          , zPosition: 1
                                          , zRotation: CGFloat.pi / 2
                                          , scale: 10
                                          , soundName: "shooting.wav")
                
                self.addChild(bullet)
                
                let bulletMove = SKAction.moveTo(y: self.size.height, duration: 1)
                let deleteBullet = SKAction.removeFromParent()
                let playSoundBullet = bullet.soundSkAction!
                let bulletSequence = SKAction.sequence([ bulletMove, deleteBullet]) //TODO: add playSoundBullet to the sequence
                bullet.run(bulletSequence)
                GameManager.gameManager.playBulletSoundEffect(fileName: "shooting", type: ".wav")
            }
        }
        
        if let playerPosition = player?.position{
            if currentGameState == gameState.inGame && UserDefaults.standard.integer(forKey: "currentSelectedShip") == 1{
                let bullet = createBullet(textureName: "bullet 1"
                                          , damage: 1
                                          , position: CGPoint(x: playerPosition.x-10, y: playerPosition.y)
                                          , zPosition: 1
                                          , zRotation: CGFloat.pi / 2
                                          , scale: 10
                                          , soundName: "shooting.wav")
                
                let bullet2 = createBullet(textureName: "bullet 1"
                                          , damage: 1
                                          , position: CGPoint(x: playerPosition.x+10, y: playerPosition.y)
                                          , zPosition: 1
                                          , zRotation: CGFloat.pi / 2
                                          , scale: 10
                                          , soundName: "shooting.wav")
                
                self.addChild(bullet)
                self.addChild(bullet2)
                
                let bulletMove = SKAction.moveTo(y: self.size.height, duration: 1)
                let deleteBullet = SKAction.removeFromParent()
                let playSoundBullet = bullet.soundSkAction!
                let bulletSequence = SKAction.sequence([ bulletMove, deleteBullet]) //TODO: add playSoundBullet to the sequence
                bullet.run(bulletSequence)
                bullet2.run(bulletSequence)
                GameManager.gameManager.playBulletSoundEffect(fileName: "shooting", type: ".wav")
            }
        }
        
        if let playerPosition = player?.position{
            if currentGameState == gameState.inGame && UserDefaults.standard.integer(forKey: "currentSelectedShip") == 2{
                let bullet = createBullet(textureName: "bullet 1"
                                          , damage: 1
                                          , position: CGPoint(x: playerPosition.x-20, y: playerPosition.y)
                                          , zPosition: 1
                                          , zRotation: CGFloat.pi / 2
                                          , scale: 10
                                          , soundName: "shooting.wav")
                
                let bullet2 = createBullet(textureName: "bullet 1"
                                          , damage: 1
                                        , position: CGPoint(x: playerPosition.x+20, y: playerPosition.y)
                                           , zPosition: 1, zRotation: CGFloat.pi / 2
                                          , scale: 10
                                          , soundName: "shooting.wav")
                
                let bullet3 = createBullet(textureName: "bullet 1"
                                          , damage: 1
                                           , position: CGPoint(x: playerPosition.x, y: playerPosition.y + 10)
                                          , zPosition: 1
                                           , zRotation: CGFloat.pi / 2
                                           , scale: 10
                                          , soundName: "shooting.wav")
                //fixed-move-enemy-bullet2
                
                self.addChild(bullet)
                self.addChild(bullet2)
                self.addChild(bullet3)

                
                let bulletMove = SKAction.moveTo(y: self.size.height, duration: 1)
                let deleteBullet = SKAction.removeFromParent()
                let playSoundBullet = bullet.soundSkAction!
                let bulletSequence = SKAction.sequence([ bulletMove, deleteBullet]) //TODO: add playSoundBullet to the sequence
                bullet.run(bulletSequence)
                bullet2.run(bulletSequence)
                bullet3.run(bulletSequence)
                GameManager.gameManager.playBulletSoundEffect(fileName: "shooting", type: ".wav")
            }
            
            if let playerPosition = player?.position{
                if currentGameState == gameState.inGame && UserDefaults.standard.integer(forKey: "currentSelectedShip") == 3{
                    let bulletMove = SKAction.moveTo(y: self.size.height, duration: 1)
                    let deleteBullet = SKAction.removeFromParent()
                    let bulletSequence = SKAction.sequence([ bulletMove, deleteBullet]) //TODO: add playSoundBullet to the sequence
                    
                    let bullet = createBullet(textureName: "bullet 1"
                                              , damage: 1
                                              , position: CGPoint(x: playerPosition.x-30, y: playerPosition.y)
                                              , zPosition: 1
                                              , zRotation: CGFloat.pi / 2
                                              , scale: 10
                                              , soundName: "shooting.wav")
                    
                    let bullet2 = createBullet(textureName: "bullet 1"
                                              , damage: 1
                                              , position: CGPoint(x: playerPosition.x-10, y: playerPosition.y+15)
                                              , zPosition: 1
                                               , zRotation: CGFloat.pi / 2
                                              , scale: 10
                                              , soundName: "shooting.wav")
                    
                    let bullet3 = createBullet(textureName: "bullet 1"
                                              , damage: 1
                                               , position: CGPoint(x: playerPosition.x+10, y: playerPosition.y+15)
                                              , zPosition: 1
                                               , zRotation: CGFloat.pi / 2
                                               , scale: 10
                                              , soundName: "shooting.wav")
                    
                    let bullet4 = createBullet(textureName: "bullet 1"
                                              , damage: 1
                                              , position: CGPoint(x: playerPosition.x+30, y: playerPosition.y)
                                              , zPosition: 1
                                               , zRotation: CGFloat.pi / 2
                                              , scale: 10
                                              , soundName: "shooting.wav")

                    
                    self.addChild(bullet)
                    self.addChild(bullet2)
                    self.addChild(bullet3)
                    self.addChild(bullet4)

                    bullet.run(bulletSequence)
                    bullet2.run(bulletSequence)
                    bullet3.run(bulletSequence)
                    bullet4.run(bulletSequence)
                    GameManager.gameManager.playBulletSoundEffect(fileName: "shooting", type: ".wav")
                }
            }
        }
    }
    
    
    var backgroundMovePerSecond: CGFloat = 400
    
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
            timeSinceLastEnemySpawn = 0
        }
        
        let backGroundMovePerFrame = backgroundMovePerSecond * deltaTime
        
        self.enumerateChildNodes(withName: "Background") {
            background, i in
            background.position.y -= backGroundMovePerFrame
            
            if background.position.y < -self.size.height{
                background.position.y += self.size.height*2
            }
        }
        
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
                }
            }
            //Constraint in x for player to stay within game area
            if player.position.x > GameManager.gameManager.gamePlayableArea!.maxX - player.size.width/3{
                player.position.x = GameManager.gameManager.gamePlayableArea!.maxX - player.size.width/3
                player.trailEmitter.position.x = GameManager.gameManager.gamePlayableArea!.maxX - player.size.width/3
                player.trailEmitter.position.x += 5
            }
            
            if player.position.x < GameManager.gameManager.gamePlayableArea!.minX + player.size.width/3{
                player.position.x = GameManager.gameManager.gamePlayableArea!.minX + player.size.width/3
                player.trailEmitter.position.x = GameManager.gameManager.gamePlayableArea!.minX + player.size.width/3
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

