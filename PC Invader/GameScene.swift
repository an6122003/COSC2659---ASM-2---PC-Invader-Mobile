//
//  GameScene.swift
//  PC Invader
//
//  Created by An on 8/12/23.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var gamePlayableArea: CGRect
    var player: Player!
    var healthBar: HealthBar!
    var lastUpdateTime: TimeInterval = 0
    var timeSinceLastBullet: TimeInterval = 0
    let bulletDelay: TimeInterval = 0.1 // Adjust this delay as needed
    
    enum gameState{
        case Menu
        case inGame
        case gameOver
    }
    
    var currentGameState = gameState.inGame
    
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
        //initate physics world
        self.physicsWorld.contactDelegate = self
        
        // initiate background
        let inGameBackGround = InGameBackground(textureName: "background"
                                                , position: CGPoint(x: self.size.width/2, y: self.size.height/2)
                                                , size: self.size
                                                , zPosition: 0)

        // initiate player
        player = Player(textureName: "player-ship 1"
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
        
        
        // add all node to the scene
        self.addChild(inGameBackGround)
        self.addChild(player)
        self.addChild(player.trailEmitter)
        spawnEnemyPerSecond(enemyName: "enemyShip", timeInterval: 1)
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
        
        if body1.categoryBitMask == physicsCategories.Bullet && body2.categoryBitMask == physicsCategories.Enemy{
            //Bullet hit Enemy
            if body2.node != nil{ // only remove the enemy when inside the screen area
                if body2.node!.position.y < self.size.height{
                    spawnExplosion(position: body2.node!.position, explosionName: "explosion")
                    body2.node?.removeFromParent()
                }
                else{
                    spawnExplosion(position: body2.node!.position, explosionName: "explosion")
                }
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
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
    }
    
    func playerHit(){
        player.health -= 1
        if player.health == 0{
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
        
    }
    
    func randomFloat() -> CGFloat{ // Return a random float
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func randomFloat(min: CGFloat, max: CGFloat) -> CGFloat{
        return randomFloat() * (max - min) + min
    }
    
    func spawnEnemy(enemyName: String){
        let startX = randomFloat(min: gamePlayableArea.minX
                                 , max: gamePlayableArea.maxX)
        
        let endX = randomFloat(min: gamePlayableArea.minX
                                 , max: gamePlayableArea.maxX)
        
        let startPosition = CGPoint(x: startX, y: self.size.height*1.1)
        
        let endPosition = CGPoint(x: endX, y: -self.size.height*0.1) // y coordinate is negative, under the screen
        
        let rotation = atan2(endPosition.y - startPosition.y, endPosition.x - startPosition.x) // tan = opposite/adjacent = dy/dx
        
        let enemy = Enemy(textureName: enemyName
                          , zPosition: 2
                          , position: startPosition
                          , scale: 1
                          , trailEmitterName: "PlayerSpaceShipTrail")
        enemy.name = "Enemy" // Name to gather all enemy objects to dispose later
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size) //enemy physics body
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = physicsCategories.Enemy
        enemy.physicsBody?.collisionBitMask = physicsCategories.None // set collision to none, as we work with only contact and not collision which will knock the body when collide
        enemy.physicsBody?.contactTestBitMask = physicsCategories.Bullet | physicsCategories.Player // allow contact with Bullet and Player category

        enemy.zRotation = rotation
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPosition, duration: 2)
        let disposeEnemy = SKAction.removeFromParent()
        let sequenceEnemy = SKAction.sequence([moveEnemy, disposeEnemy])
        enemy.run(sequenceEnemy)
    }
    
    func spawnEnemyPerSecond(enemyName: String, timeInterval: Float) {
        
        let spawnEnemyAction = SKAction.run { [weak self] in
                self?.spawnEnemy(enemyName: enemyName)
            }
        let wait = SKAction.wait(forDuration: TimeInterval(timeInterval), withRange: 0.1)
        let spawnSequence = SKAction.sequence([spawnEnemyAction, wait])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(SKAction.repeatForever(spawnForever))
    }

    
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
            if player.position.x > gamePlayableArea.maxX - player.size.width/2{
                player.position.x = gamePlayableArea.maxX - player.size.width/2
                player.trailEmitter.position.x = gamePlayableArea.maxX - player.size.width/2
                player.trailEmitter.position.x += 5
            }
            
            if player.position.x < gamePlayableArea.minX + player.size.width/2{
                player.position.x = gamePlayableArea.minX + player.size.width/2
                player.trailEmitter.position.x = gamePlayableArea.minX + player.size.width/2
                player.trailEmitter.position.x += 5
            }
            
            //Constraint in y for player to stay within game area
            if player.position.y > gamePlayableArea.maxY - player.size.height/2{
                player.position.y = gamePlayableArea.maxY - player.size.height/2
                player.trailEmitter.position.y = gamePlayableArea.maxY - player.size.height/2
            }
            
            if player.position.y < gamePlayableArea.minY + player.size.height/2{
                player.position.y = gamePlayableArea.minY + player.size.height/2
                player.trailEmitter.position.y = gamePlayableArea.minY + player.size.height/2
            }
        }
    }
    
}

