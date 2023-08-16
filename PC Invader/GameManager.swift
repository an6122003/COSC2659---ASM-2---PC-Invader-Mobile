//
//  GameManager.swift
//  PC Invader
//
//  Created by An on 8/16/23.
//

import Foundation

class GameManager {
    static let gameManager = GameManager()
    
    var gamePlayableArea: CGRect?
    
    private init() { }
    
    func calculatePlayableArea(size: CGSize) {
        let aspectRatio = 19.5 / 9.0
        let maxPlayableWidth = size.height / aspectRatio
        let margin = (size.width - maxPlayableWidth) / 2
        gamePlayableArea = CGRect(x: margin, y: 0, width: maxPlayableWidth, height: size.height)
    }
}
