//
//  CircularMovementEnemy.swift
//  PC Invader
//
//  Created by An on 8/24/23.
//

import Foundation
import SpriteKit

class CircularMovementEnemy: Enemy {
    let centerPoint: CGPoint
    let radius: CGFloat
    var angle: CGFloat = 0.0

    init(textureName: String,
         zPosition: CGFloat,
         scale: CGFloat,
         health: Int,
         bullet: Bullet,
         centerPoint: CGPoint,
         radius: CGFloat) {
        
        self.centerPoint = centerPoint
        self.radius = radius
        let initialPositionX = self.centerPoint.x - self.radius
        let initialPositionY = self.centerPoint.y
        
        super.init(textureName: textureName,
                   zPosition: zPosition,
                   position: CGPoint(x: initialPositionX, y: initialPositionY),
                   scale: scale,
                   health: health,
                   bullet: bullet)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func move() {
        // Determine the initial direction based on the current position
        var clockwise: Bool = true
        let duration: TimeInterval = 8
        
        // Create a circular path
        let pathLeft = CGMutablePath()
        pathLeft.addArc(center: centerPoint, radius: radius, startAngle: 0, endAngle: CGFloat.pi, clockwise: clockwise)
        let semiCircleLeft = SKShapeNode(path: pathLeft)
        
        let semicircularMoveLeft = SKAction.follow(semiCircleLeft.path!, asOffset: false, orientToPath: true, duration: duration)
        
        let pathRight = CGMutablePath()
        pathRight.addArc(center: centerPoint, radius: radius, startAngle: CGFloat.pi, endAngle: 0, clockwise: !clockwise)
        let semiCircleRight = SKShapeNode(path: pathRight)
        
        let semicircularMoveRight = SKAction.follow(semiCircleRight.path!, asOffset: false, orientToPath: true, duration: duration)

        let sequence = SKAction.sequence([semicircularMoveLeft,semicircularMoveRight])

        let repeatAction = SKAction.repeatForever(sequence)

        // Run the action
        self.run(repeatAction)
    }
}

