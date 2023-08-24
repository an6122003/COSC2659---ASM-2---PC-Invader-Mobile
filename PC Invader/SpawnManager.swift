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
                (SKAction.wait(forDuration: 3), { self.spawnVerticalEnemies(count: 3) }),
                (SKAction.wait(forDuration: 3), { self.spawnVerticalEnemies(count: 2) }),
                (SKAction.wait(forDuration: 3), { self.spawnRandomMovementEnemies(count: 3) }),
                (SKAction.wait(forDuration: 3), { self.spawnVerticalEnemies(count: 2) }),
                (SKAction.wait(forDuration: 3), { self.spawnRandomMovementEnemies(count: 3) })
            ])
        case 2:
            spawnEnemy(actions: [
                (SKAction.wait(forDuration: 2), { self.spawnVerticalEnemies(count: 3) }),
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
    
    private func spawnVerticalEnemies(count: Int) {
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
    
    private func spawnVerticalEnemyWave(count: Int, wave: Int) {
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

    
    
    private func spawnRandomMovementEnemies(count: Int) {
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
}
