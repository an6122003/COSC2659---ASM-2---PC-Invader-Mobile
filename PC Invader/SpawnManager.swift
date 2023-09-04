//
//  SpawnManager.swift
//  PC Invader
//
//  Created by An on 8/16/23.
//

import Foundation
import SpriteKit

class SpawnManager {
    var isWinning = false
    var gameScene: GameScene
    var level: Int = 1
    let bullet = Bullet(textureName: "bullet 1"
                        , position: .zero
               , zPosition: 1
               , scale: 10
               , soundName: "shooting.wav")
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
    }
    
    func spawnEnemiesForLevel(level: Int) {
        switch level {
        case 1:
            spawnEnemy(actions: [
                (SKAction.wait(forDuration: 5), { self.spawnFixedMovementEnemies(count: 3, positionPercentage: 0.8, fireDelay: 5) }),
                (SKAction.wait(forDuration: 5), { self.spawnFixedMovementEnemies(count: 3, positionPercentage: 0.7, fireDelay: 5) }),
                (SKAction.wait(forDuration: 5), { self.spawnFixedMovementEnemies(count: 3, positionPercentage: 0.6, fireDelay: 5) }),
            ], repeatTime: 2)
            incrementLevel(Level: level)
        case 2:
            spawnEnemy(actions: [
                (SKAction.wait(forDuration: 5), { self.spawnFixedMovementEnemies(count: 4, positionPercentage: 0.6, fireDelay: 5) }),
                (SKAction.wait(forDuration: 5), { self.spawnFixedMovementEnemies(count: 3, positionPercentage: 0.7, fireDelay: 5) }),
                (SKAction.wait(forDuration: 5), { self.spawnFixedMovementEnemies(count: 4, positionPercentage: 0.8, fireDelay: 5) }),
            ], repeatTime: 2)
            incrementLevel(Level: level)
        case 3:
            spawnEnemy(actions: [
                (SKAction.wait(forDuration: 5), { self.spawnFixedMovementEnemies(count: 4, positionPercentage: 0.6, fireDelay: 5) }),
                (SKAction.wait(forDuration: 5), {self.spawnRandomMovementEnemies(count: 3) }),
                (SKAction.wait(forDuration: 5), { self.spawnFixedMovementEnemies(count: 4, positionPercentage: 0.8, fireDelay: 5) }),
                (SKAction.wait(forDuration: 5), {self.spawnRandomMovementEnemies(count: 3) })
            ], repeatTime: 2)
            incrementLevel(Level: level)
        case 4:
            spawnEnemy(actions: [
                (SKAction.wait(forDuration: 3), { self.spawnFixedMovementEnemies(count: 4, positionPercentage: 0.6, fireDelay: 5) }),
                (SKAction.wait(forDuration: 5), {self.spawnRandomMovementEnemies(count: 3) }),
                (SKAction.wait(forDuration: 3), { self.spawnFixedMovementEnemies(count: 4, positionPercentage: 0.8, fireDelay: 5) }),
                (SKAction.wait(forDuration: 5), {self.spawnRandomMovementEnemies(count: 3) })
            ], repeatTime: 2)
            incrementLevel(Level: level)
        case 5:
            spawnEnemy(actions: [
                (SKAction.wait(forDuration: 5), {
                    self.spawnFixedMovementEnemies(count: 4, positionPercentage: 0.6, fireDelay: 5)
                    self.spawnRandomMovementEnemies(count: 3)
                }),
                (SKAction.wait(forDuration: 3), { self.spawnFixedMovementEnemies(count: 4, positionPercentage: 0.8, fireDelay: 5) }),
                (SKAction.wait(forDuration: 5), {
                    self.spawnFixedMovementEnemies(count: 4, positionPercentage: 0.6, fireDelay: 5)
                    self.spawnRandomMovementEnemies(count: 3)
                }),
            ], repeatTime: 2)
            incrementLevel(Level: level)
        case 6:
            spawnEnemy(actions: [
                (SKAction.wait(forDuration: 3), { self.spawnFixedMovementEnemies(count: 4, positionPercentage: 0.6, fireDelay: 5) }),
                (SKAction.wait(forDuration: 3), {self.spawnRandomMovementEnemies(count: 3) }),
                (SKAction.wait(forDuration: 3), { self.spawnVerticalEnemies(count: 3, bulletCount: 5, fireDelay: 5) }),
                (SKAction.wait(forDuration: 5), {self.spawnRandomMovementEnemies(count: 3) })
            ], repeatTime: 2)
            incrementLevel(Level: level)
        case 7:
            spawnEnemy(actions: [
                (SKAction.wait(forDuration: 5), {
                    self.spawnFixedMovementEnemies(count: 4, positionPercentage: 0.6, fireDelay: 5)
                    self.spawnRandomMovementEnemies(count: 4)
                }),
                (SKAction.wait(forDuration: 3), { self.spawnVerticalEnemies(count: 3, bulletCount: 7, fireDelay: 5) }),
            ], repeatTime: 4)
            incrementLevel(Level: level)
        case 8:
            spawnEnemy(actions: [
                (SKAction.wait(forDuration: 5), {
                    self.spawnVerticalEnemies(count: 3, bulletCount: 7, fireDelay: 5)
                    self.spawnRandomMovementEnemies(count: 5)
                }),
                (SKAction.wait(forDuration: 5), {
                    self.spawnCircularMovementEnemies(count: 3, centerPointY: self.gameScene.size.height*0.9)
                    self.spawnRandomMovementEnemies(count: 3)
                }),
                (SKAction.wait(forDuration: 5), { self.spawnVerticalEnemies(count: 4, bulletCount: 7, fireDelay: 5) }),
            ], repeatTime: 2)
            incrementLevel(Level: level)
        case 9:
            spawnEnemy(actions: [
                (SKAction.wait(forDuration: 5), {
                    self.spawnVerticalEnemies(count: 3, bulletCount: 7, fireDelay: 5)
                    self.spawnRandomMovementEnemies(count: 5)
                }),
                (SKAction.wait(forDuration: 5), {
                    self.spawnCircularMovementEnemies(count: 3, centerPointY: self.gameScene.size.height*0.9)
                    self.spawnRandomMovementEnemies(count: 3)
                    self.spawnHorizontalRightMovementEnemies(count: 3)
                }),
                (SKAction.wait(forDuration: 5), {
                    self.spawnVerticalEnemies(count: 3, bulletCount: 7, fireDelay: 5)
                    self.spawnHorizontalLeftMovementEnemies(count: 3)
                }),
            ], repeatTime: 2)
            incrementLevel(Level: level)
        case 10:
            spawnEnemy(actions: [
                (SKAction.wait(forDuration: 5), {
                    self.spawnVerticalEnemies(count: 3, bulletCount: 5, fireDelay: 4)
                    self.spawnFixedMovementEnemies(count: 4, positionPercentage: 0.8, fireDelay: 3)
                }),
                (SKAction.wait(forDuration: 5), {
                    self.spawnCircularMovementEnemies(count: 4, centerPointY: self.gameScene.size.height*0.9)
                    self.spawnRandomMovementEnemies(count: 3)
                    self.spawnHorizontalRightMovementEnemies(count: 3)
                }),
                (SKAction.wait(forDuration: 5), {
                    self.spawnVerticalEnemies(count: 3, bulletCount: 7, fireDelay: 5)
                    self.spawnHorizontalLeftMovementEnemies(count: 3)
                }),
            ], repeatTime: 2)
            incrementLevel(Level: level)
        case 11:
            spawnEnemy(actions: [
                (SKAction.wait(forDuration: 5), {
                    self.spawnVerticalEnemies(count: 3, bulletCount: 7, fireDelay: 4)
                    self.spawnFixedMovementEnemies(count: 5, positionPercentage: 0.8, fireDelay: 3)
                }),
                (SKAction.wait(forDuration: 3), {
                    self.spawnCircularMovementEnemies(count: 5, centerPointY: self.gameScene.size.height*0.9)
                    self.spawnRandomMovementEnemies(count: 3)
                    self.spawnHorizontalRightMovementEnemies(count: 4)
                }),
                (SKAction.wait(forDuration: 3), {
                    self.spawnVerticalEnemies(count: 3, bulletCount: 7, fireDelay: 5)
                    self.spawnHorizontalLeftMovementEnemies(count: 4)
                }),
            ], repeatTime: 3)
            incrementLevel(Level: level)
//        case 12:
//
//            break
        default:
            break
        }
    }
    
//    spawnEnemy(actions: [
//        (SKAction.wait(forDuration: 3), {
//            self.spawnVerticalEnemies(count: 3, bulletCount: 6, fireDelay: 5)
//            self.spawnRandomMovementEnemies(count: 3)
//        }),
//        (SKAction.wait(forDuration: 3), { self.spawnVerticalEnemies(count: 3, bulletCount: 6, fireDelay: 5) }),                (SKAction.wait(forDuration: 3), { self.spawnRandomMovementEnemies(count: 3) }),
//        (SKAction.wait(forDuration: 3), { self.spawnVerticalEnemies(count: 3, bulletCount: 6, fireDelay: 5) }),                (SKAction.wait(forDuration: 3), { self.spawnRandomMovementEnemies(count: 3) })
//    ], repeatTime: <#Int#>)
//    incrementLevel(Level: level)
    
    func incrementLevel (Level: Int){
        if UserDefaults.standard.integer(forKey: "currentUnlockLevel") < Level && isWinning == true{
            let temp = UserDefaults.standard.integer(forKey: "currentUnlockLevel")
            UserDefaults.standard.set(temp + 1, forKey: "currentUnlockLevel")
            isWinning = false
        }
    }
    
    func spawnVerticalEnemies(count: Int, bulletCount: Int, fireDelay: CGFloat) {
        for _ in 1...count {
            let verticalMoveEnemy = VerticalMovementEnemy(textureName: "enemy-1"
                                                      , zPosition: 2
                                                          , scale: 0.6
                                                      , health: 5
                                                      , bullet: bullet)
//            verticalMoveEnemy.zRotation = CGFloat.pi/2
            verticalMoveEnemy.name = "Enemy"
            verticalMoveEnemy.physicsBody = SKPhysicsBody(rectangleOf: verticalMoveEnemy.size)
            verticalMoveEnemy.physicsBody?.affectedByGravity = false
            verticalMoveEnemy.physicsBody?.categoryBitMask = GameScene.physicsCategories.Enemy
            verticalMoveEnemy.physicsBody?.collisionBitMask = GameScene.physicsCategories.None
            verticalMoveEnemy.physicsBody?.contactTestBitMask = GameScene.physicsCategories.Bullet | GameScene.physicsCategories.Player
            
            gameScene.addChild(verticalMoveEnemy)
            verticalMoveEnemy.move()
            verticalMoveEnemy.shootLoop(gameScene: gameScene, bulletCount: bulletCount, fireDelay: fireDelay)
        }
    }
    
//    func spawnVerticalEnemyWave(count: Int, wave: Int) {
//        let spawnAction = SKAction.run {
//            self.spawnVerticalEnemies(count: count)
//        }
//        let waitAction = SKAction.wait(forDuration: 3)
//        let gameWonAction = SKAction.run {
//            if UserDefaults.standard.integer(forKey: "highScore") < GameScene.playerScore{
//                UserDefaults.standard.set(GameScene.playerScore, forKey: "highScore")
//            }
//            self.gameScene.gameWin()
//        }
//        let spawnSequence = SKAction.sequence([spawnAction,waitAction])
//        let repeatSequence = SKAction.repeat(spawnSequence
//                                             , count: wave)
//        let finalSequence = SKAction.sequence([repeatSequence,gameWonAction])
//        gameScene.run(finalSequence)
//    }
    
    func spawnEnemy(actions: [(SKAction, () -> Void)], repeatTime: Int) {
        var spawnAction: [SKAction] = []
        
        let gameWonAction = SKAction.run {
            if UserDefaults.standard.integer(forKey: "highScore") < GameScene.playerScore{
                UserDefaults.standard.set(GameScene.playerScore, forKey: "highScore")
            }
            self.isWinning = true
            self.gameScene.gameWin()
        }
        
        for (action, actionClosure) in actions {
            let runAction = SKAction.run(actionClosure)
            spawnAction.append(runAction)
            spawnAction.append(action)
        }
        
        let repeatSequence = SKAction.repeat(SKAction.sequence(spawnAction), count: repeatTime)
        
        let sequenceAction = SKAction.sequence([repeatSequence,gameWonAction])
        gameScene.run(sequenceAction)
    }

    
    
    func spawnRandomMovementEnemies(count: Int) {
        for _ in 1...count {
            let randomMoveEnemy = RandomMovementEnemy(textureName: "enemy-3"
                                                      , zPosition: 2
                                                      , scale: 0.6
                                                      , health: 10
                                                      , bullet: Bullet(textureName: "bullet 1"
                                                                       , position: gameScene.player.position
                                                                       , zPosition: 1
                                                                       , scale: 10
                                                                       , soundName: "shooting.wav")
                                                      , gameScene:  gameScene)
            randomMoveEnemy.name = "Enemy"
            randomMoveEnemy.physicsBody = SKPhysicsBody(rectangleOf: randomMoveEnemy.size)
            randomMoveEnemy.physicsBody?.affectedByGravity = false
            randomMoveEnemy.physicsBody?.categoryBitMask = GameScene.physicsCategories.Enemy
            randomMoveEnemy.physicsBody?.collisionBitMask = GameScene.physicsCategories.None // set collision to none, as we work with only contact and not collision which will knock the body when collide
            randomMoveEnemy.physicsBody?.contactTestBitMask = GameScene.physicsCategories.Bullet | GameScene.physicsCategories.Player// allow contact with Bullet and Player category
    
            gameScene.addChild(randomMoveEnemy)
            randomMoveEnemy.move()
        }
    }
    
    func spawnHorizontalRightMovementEnemies(count: Int) {
        for _ in 1...count {
            let horizontalRightMoveEnemy = HorizontalRightMovementEnemy(textureName: "enemy-5"
                                                      , zPosition: 2
                                                                        , scale: 0.6
                                                      , health: 5
                                                      , bullet: Bullet(textureName: "bullet 1"
                                                                       , position: gameScene.player.position
                                                                       , zPosition: 1
                                                                       , scale: 10
                                                                       , soundName: "shooting.wav"))
            horizontalRightMoveEnemy.name = "Enemy"
            horizontalRightMoveEnemy.physicsBody = SKPhysicsBody(rectangleOf: horizontalRightMoveEnemy.size)
            horizontalRightMoveEnemy.physicsBody?.affectedByGravity = false
            horizontalRightMoveEnemy.physicsBody?.categoryBitMask = GameScene.physicsCategories.Enemy
            horizontalRightMoveEnemy.physicsBody?.collisionBitMask = GameScene.physicsCategories.None // set collision to none, as we work with only contact and not collision which will knock the body when collide
            horizontalRightMoveEnemy.physicsBody?.contactTestBitMask = GameScene.physicsCategories.Bullet | GameScene.physicsCategories.Player// allow contact with Bullet and Player category
    
            gameScene.addChild(horizontalRightMoveEnemy)
            horizontalRightMoveEnemy.move()
        }
    }
    
    func spawnHorizontalLeftMovementEnemies(count: Int) {
        for _ in 1...count {
            let horizontalLeftMoveEnemy = HorizontalLeftMovementEnemy(textureName: "enemy-6"
                                                      , zPosition: 2
                                                      , scale: 0.6
                                                      , health: 5
                                                      , bullet: Bullet(textureName: "bullet 1"
                                                                       , position: gameScene.player.position
                                                                       , zPosition: 1
                                                                       , scale: 10
                                                                       , soundName: "shooting.wav"))
            horizontalLeftMoveEnemy.name = "Enemy"
            horizontalLeftMoveEnemy.zRotation = CGFloat.pi
            horizontalLeftMoveEnemy.physicsBody = SKPhysicsBody(rectangleOf: horizontalLeftMoveEnemy.size)
            horizontalLeftMoveEnemy.physicsBody?.affectedByGravity = false
            horizontalLeftMoveEnemy.physicsBody?.categoryBitMask = GameScene.physicsCategories.Enemy
            horizontalLeftMoveEnemy.physicsBody?.collisionBitMask = GameScene.physicsCategories.None // set collision to none, as we work with only contact and not collision which will knock the body when collide
            horizontalLeftMoveEnemy.physicsBody?.contactTestBitMask = GameScene.physicsCategories.Bullet | GameScene.physicsCategories.Player// allow contact with Bullet and Player category
    
            gameScene.addChild(horizontalLeftMoveEnemy)
            horizontalLeftMoveEnemy.move()
        }
    }
    
    func spawnFixedMovementEnemies(count: Int, positionPercentage: CGFloat, fireDelay: CGFloat) {
        var spawnPosition = (GameManager.gameManager.gamePlayableArea!.maxX*0.9 / CGFloat(count))
        var spawnIncrement = (GameManager.gameManager.gamePlayableArea!.maxX*0.9 / CGFloat(count))

        for _ in 1...count {
            let fixedMoveEnemy = FixedMovementEnemy(textureName: "enemy-2"
                                                      , zPosition: 2
                                                    , scale: 0.6
                                                      , health: 5
                                                      , bullet: Bullet(textureName: "bullet 1"
                                                                       , position: gameScene.player.position
                                                                       , zPosition: 1
                                                                       , scale: 5
                                                                       , soundName: "shooting.wav")
                                                      , startX: spawnPosition)
            fixedMoveEnemy.name = "Enemy"
//            fixedMoveEnemy.zRotation = -CGFloat.pi/2
            fixedMoveEnemy.physicsBody = SKPhysicsBody(rectangleOf: fixedMoveEnemy.size)
            fixedMoveEnemy.physicsBody?.affectedByGravity = false
            fixedMoveEnemy.physicsBody?.categoryBitMask = GameScene.physicsCategories.Enemy
            fixedMoveEnemy.physicsBody?.collisionBitMask = GameScene.physicsCategories.None // set collision to none, as we work with only contact and not collision which will knock the body when collide
            fixedMoveEnemy.physicsBody?.contactTestBitMask = GameScene.physicsCategories.Bullet | GameScene.physicsCategories.Player// allow contact with Bullet and Player category
    
            gameScene.addChild(fixedMoveEnemy)
            spawnPosition += spawnIncrement
            fixedMoveEnemy.move(positionPercentage: positionPercentage)
            fixedMoveEnemy.shootLoop(gameScene: gameScene, fireDelay: fireDelay)
        }
    }
    
    func spawnCircularMovementEnemies(count: Int, centerPointY: CGFloat) {
        let center = CGPoint(x: self.gameScene.size.width/2, y: self.gameScene.size.height/2)
        
        let spawnAction = SKAction.run { [weak self] in
            guard let self = self else { return }
            
            let circularMoveEnemy = CircularMovementEnemy(textureName: "enemy-4",
                                                          zPosition: 2,
                                                          scale: 0.6,
                                                          health: 5,
                                                          bullet: Bullet(textureName: "circular-enemy-bullet",
                                                                         position: self.gameScene.player.position,
                                                                         zPosition: 1,
                                                                         scale: 0.3,
                                                                         soundName: "shooting.wav"),
                                                          centerPoint: CGPoint(x: self.gameScene.size.width/2, y: centerPointY),
                                                          radius: (self.gameScene.size.width/2) * 1.1)
            circularMoveEnemy.name = "Enemy"
            circularMoveEnemy.zRotation = CGFloat.pi
            circularMoveEnemy.physicsBody = SKPhysicsBody(rectangleOf: circularMoveEnemy.size)
            circularMoveEnemy.physicsBody?.affectedByGravity = false
            circularMoveEnemy.physicsBody?.categoryBitMask = GameScene.physicsCategories.Enemy
            circularMoveEnemy.physicsBody?.collisionBitMask = GameScene.physicsCategories.None
            circularMoveEnemy.physicsBody?.contactTestBitMask = GameScene.physicsCategories.Bullet | GameScene.physicsCategories.Player
            
            self.gameScene.addChild(circularMoveEnemy)
            circularMoveEnemy.move()
            circularMoveEnemy.shootLoop(gameScene: gameScene, fireRate: 1)
        }
        
        let waitAction = SKAction.wait(forDuration: 1)
        let spawnSequence = SKAction.sequence([spawnAction, waitAction])
        let repeatAction = SKAction.repeat(spawnSequence, count: count)
        
        self.gameScene.run(repeatAction)
    }
}
