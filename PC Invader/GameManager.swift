//
//  GameManager.swift
//  PC Invader
//
//  Created by An on 8/16/23.
//

import Foundation
import SwiftUI

class GameManager {
    static let gameManager = GameManager()
    
    var gamePlayableArea: CGRect?
//    @AppStorage("highScore") var highScore = 0
    static var highScore: Int = UserDefaults.standard.integer(forKey: "highScore") // Default value is 0
    private init() { }
    
    func calculatePlayableArea(size: CGSize) {
        let aspectRatio = 19.5 / 9.0
        let maxPlayableWidth = size.height / aspectRatio
        let margin = (size.width - maxPlayableWidth) / 2
        gamePlayableArea = CGRect(x: margin, y: 0, width: maxPlayableWidth, height: size.height)
    }
}
