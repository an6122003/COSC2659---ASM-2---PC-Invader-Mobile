//
//  SpawnManager.swift
//  PC Invader
//
//  Created by An on 8/16/23.
//

import Foundation
import SpriteKit

class SpawnManager {
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
                (SKAction.wait(forDuration: 3), { self.spawnFixedMovementEnemies(count: 5, positionPercentage: 0.8) }),
                (SKAction.wait(forDuration: 3), { self.spawnCircularMovementEnemies(count: 3) }),
                (SKAction.wait(forDuration: 3), { self.spawnVerticalEnemies(count: 3) }),
                (SKAction.wait(forDuration: 3), { self.spawnVerticalEnemies(count: 2) }),
                (SKAction.wait(forDuration: 3), { self.spawnRandomMovementEnemies(count: 3) }),
                (SKAction.wait(forDuration: 3), { self.spawnVerticalEnemies(count: 2) }),
                (SKAction.wait(forDuration: 3), { self.spawnRandomMovementEnemies(count: 3) })
            ])
        case 2:
            spawnEnemy(actions: [
                (SKAction.wait(forDuration: 2), { self.spawnHorizontalRightMovementEnemies(count: 3) }),
                (SKAction.wait(forDuration: 2), { self.spawnHorizontalLeftMovementEnemies(count: 3) }),
                (SKAction.wait(forDuration: 2), { self.spawnVerticalEnemies(count: 2) }),
                (SKAction.wait(forDuration: 2), { self.spawnRandomMovementEnemies(count: 3) }),
                (SKAction.wait(forDuration: 2), { self.spawnVerticalEnemies(count: 2) }),
                (SKAction.wait(forDuration: 2), { self.spawnRandomMovementEnemies(count: 3) })
            ])
        case 3:
            spawnEnemy(actions: [
                (SKAction.wait(forDuration: 3), {
                    self.spawnVerticalEnemies(count: 3)
                    self.spawnRandomMovementEnemies(count: 3)
                }),
                (SKAction.wait(forDuration: 3), { self.spawnVerticalEnemies(count: 2) }),
                (SKAction.wait(forDuration: 3), { self.spawnRandomMovementEnemies(count: 3) }),
                (SKAction.wait(forDuration: 3), { self.spawnVerticalEnemies(count: 2) }),
                (SKAction.wait(forDuration: 3), { self.spawnRandomMovementEnemies(count: 3) })
            ])
        default:
            break
        }
    }
    
    func spawnVerticalEnemies(count: Int) {
        for _ in 1...count {
            let verticalMoveEnemy = VerticalMovementEnemy(textureName: "enemyShip"
                                                      , zPosition: 2
                                                          , scale: 0.8
                                                      , health: 5
                                                      , bullet: bullet)
            verticalMoveEnemy.physicsBody = SKPhysicsBody(rectangleOf: verticalMoveEnemy.size)
            verticalMoveEnemy.physicsBody?.affectedByGravity = false
            verticalMoveEnemy.physicsBody?.categoryBitMask = GameScene.physicsCategories.Enemy
            verticalMoveEnemy.physicsBody?.collisionBitMask = GameScene.physicsCategories.None
            verticalMoveEnemy.physicsBody?.contactTestBitMask = GameScene.physicsCategories.Bullet | GameScene.physicsCategories.Player
            
            gameScene.addChild(verticalMoveEnemy)
            verticalMoveEnemy.move()
            verticalMoveEnemy.shootLoop(gameScene: gameScene)
        }
    }
    
    func spawnVerticalEnemyWave(count: Int, wave: Int) {
        let spawnAction = SKAction.run {
            self.spawnVerticalEnemies(count: count)
        }
        let waitAction = SKAction.wait(forDuration: 3)
        let gameWonAction = SKAction.run {
            if UserDefaults.standard.integer(forKey: "highScore") < GameScene.playerScore{
                UserDefaults.standard.set(GameScene.playerScore, forKey: "highScore")
            }
            self.gameScene.gameWin()
        }
        let spawnSequence = SKAction.sequence([spawnAction,waitAction])
        let repeatSequence = SKAction.repeat(spawnSequence
                                             , count: wave)
        let finalSequence = SKAction.sequence([repeatSequence,gameWonAction])
        gameScene.run(finalSequence)
    }
    
    func spawnEnemy(actions: [(SKAction, () -> Void)]) {
        var spawnAction: [SKAction] = []
        
        let waitAction = SKAction.wait(forDuration: 3)
        let gameWonAction = SKAction.run {
            if UserDefaults.standard.integer(forKey: "highScore") < GameScene.playerScore{
                UserDefaults.standard.set(GameScene.playerScore, forKey: "highScore")
            }
            self.gameScene.gameWin()
        }
        
        for (action, actionClosure) in actions {
            let runAction = SKAction.run(actionClosure)
            spawnAction.append(runAction)
            spawnAction.append(action)
        }
        
        let repeatSequence = SKAction.repeat(SKAction.sequence(spawnAction), count: 1)
        
        let sequenceAction = SKAction.sequence([repeatSequence,gameWonAction])
        gameScene.run(sequenceAction)
    }

    
    
    func spawnRandomMovementEnemies(count: Int) {
        for _ in 1...count {
            let randomMoveEnemy = RandomMovementEnemy(textureName: "enemyShip"
                                                      , zPosition: 2
                                                      , scale: 1
                                                      , health: 5
                                                      , bullet: Bullet(textureName: "bullet 1"
                                                                       , position: gameScene.player.position
                                                                       , zPosition: 1
                                                                       , scale: 10
                                                                       , soundName: "shooting.wav"))
            randomMoveEnemy.physicsBody = SKPhysicsBody(rectangleOf: randomMoveEnemy.size)
            randomMoveEnemy.physicsBody?.categoryBitMask = GameScene.physicsCategories.Enemy
            randomMoveEnemy.physicsBody?.collisionBitMask = GameScene.physicsCategories.None // set collision to none, as we work with only contact and not collision which will knock the body when collide
            randomMoveEnemy.physicsBody?.contactTestBitMask = GameScene.physicsCategories.Bullet | GameScene.physicsCategories.Player// allow contact with Bullet and Player category
    
            gameScene.addChild(randomMoveEnemy)
            randomMoveEnemy.move()
        }
    }
    
    func spawnHorizontalRightMovementEnemies(count: Int) {
        for _ in 1...count {
            let horizontalRightMoveEnemy = HorizontalRightMovementEnemy(textureName: "enemyShip"
                                                      , zPosition: 2
                                                      , scale: 1
                                                      , health: 5
                                                      , bullet: Bullet(textureName: "bullet 1"
                                                                       , position: gameScene.player.position
                                                                       , zPosition: 1
                                                                       , scale: 10
                                                                       , soundName: "shooting.wav"))
            horizontalRightMoveEnemy.physicsBody = SKPhysicsBody(rectangleOf: horizontalRightMoveEnemy.size)
            horizontalRightMoveEnemy.physicsBody?.categoryBitMask = GameScene.physicsCategories.Enemy
            horizontalRightMoveEnemy.physicsBody?.collisionBitMask = GameScene.physicsCategories.None // set collision to none, as we work with only contact and not collision which will knock the body when collide
            horizontalRightMoveEnemy.physicsBody?.contactTestBitMask = GameScene.physicsCategories.Bullet | GameScene.physicsCategories.Player// allow contact with Bullet and Player category
    
            gameScene.addChild(horizontalRightMoveEnemy)
            horizontalRightMoveEnemy.move()
        }
    }
    
    func spawnHorizontalLeftMovementEnemies(count: Int) {
        for _ in 1...count {
            let horizontalLeftMoveEnemy = HorizontalLeftMovementEnemy(textureName: "enemyShip"
                                                      , zPosition: 2
                                                      , scale: 1
                                                      , health: 5
                                                      , bullet: Bullet(textureName: "bullet 1"
                                                                       , position: gameScene.player.position
                                                                       , zPosition: 1
                                                                       , scale: 10
                                                                       , soundName: "shooting.wav"))
            horizontalLeftMoveEnemy.zRotation = CGFloat.pi
            horizontalLeftMoveEnemy.physicsBody = SKPhysicsBody(rectangleOf: horizontalLeftMoveEnemy.size)
            horizontalLeftMoveEnemy.physicsBody?.categoryBitMask = GameScene.physicsCategories.Enemy
            horizontalLeftMoveEnemy.physicsBody?.collisionBitMask = GameScene.physicsCategories.None // set collision to none, as we work with only contact and not collision which will knock the body when collide
            horizontalLeftMoveEnemy.physicsBody?.contactTestBitMask = GameScene.physicsCategories.Bullet | GameScene.physicsCategories.Player// allow contact with Bullet and Player category
    
            gameScene.addChild(horizontalLeftMoveEnemy)
            horizontalLeftMoveEnemy.move()
        }
    }
    
    func spawnFixedMovementEnemies(count: Int, positionPercentage: CGFloat) {
        var spawnPosition = (GameManager.gameManager.gamePlayableArea!.maxX*0.9 / CGFloat(count))
        var spawnIncrement = (GameManager.gameManager.gamePlayableArea!.maxX*0.9 / CGFloat(count))

        for _ in 1...count {
            let fixedMoveEnemy = FixedMovementEnemy(textureName: "enemyShip"
                                                      , zPosition: 2
                                                      , scale: 1
                                                      , health: 5
                                                      , bullet: Bullet(textureName: "bullet 1"
                                                                       , position: gameScene.player.position
                                                                       , zPosition: 1
                                                                       , scale: 10
                                                                       , soundName: "shooting.wav")
                                                      , startX: spawnPosition)
            fixedMoveEnemy.zRotation = -CGFloat.pi/2
            fixedMoveEnemy.physicsBody = SKPhysicsBody(rectangleOf: fixedMoveEnemy.size)
            fixedMoveEnemy.physicsBody?.affectedByGravity = false
            fixedMoveEnemy.physicsBody?.categoryBitMask = GameScene.physicsCategories.Enemy
            fixedMoveEnemy.physicsBody?.collisionBitMask = GameScene.physicsCategories.None // set collision to none, as we work with only contact and not collision which will knock the body when collide
            fixedMoveEnemy.physicsBody?.contactTestBitMask = GameScene.physicsCategories.Bullet | GameScene.physicsCategories.Player// allow contact with Bullet and Player category
    
            gameScene.addChild(fixedMoveEnemy)
            spawnPosition += spawnIncrement
            fixedMoveEnemy.move(positionPercentage: positionPercentage)
        }
    }
    
    func spawnCircularMovementEnemies(count: Int) {
        let center = CGPoint(x: GameManager.gameManager.gamePlayableArea!.width/2
                             , y: GameManager.gameManager.gamePlayableArea!.height/2)
        for _ in 1...count {
            let circularMoveEnemy = CircularMovementEnemy(textureName: "enemyShip"
                                                      , zPosition: 2
                                                      , scale: 1
                                                      , health: 5
                                                      , bullet: Bullet(textureName: "bullet 1"
                                                                       , position: gameScene.player.position
                                                                       , zPosition: 1
                                                                       , scale: 10
                                                                       , soundName: "shooting.wav")
                                                                       , centerPoint: center
                                                          , radius: 0.1)
            circularMoveEnemy.zRotation = CGFloat.pi
            circularMoveEnemy.physicsBody = SKPhysicsBody(rectangleOf: circularMoveEnemy.size)
            circularMoveEnemy.physicsBody?.categoryBitMask = GameScene.physicsCategories.Enemy
            circularMoveEnemy.physicsBody?.collisionBitMask = GameScene.physicsCategories.None // set collision to none, as we work with only contact and not collision which will knock the body when collide
            circularMoveEnemy.physicsBody?.contactTestBitMask = GameScene.physicsCategories.Bullet | GameScene.physicsCategories.Player// allow contact with Bullet and Player category
    
            gameScene.addChild(circularMoveEnemy)
            circularMoveEnemy.move()
        }
    }
}
