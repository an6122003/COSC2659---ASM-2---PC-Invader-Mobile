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
    static var currentSelectedShip: Int = UserDefaults.standard.integer(forKey: "currentSelectedShip") // Default value is 0
    
    static let PlayerHealthInformation: [Int: Int] = [0: 2,
                                                      1: 4,
                                                      2: 6,
                                                      3: 8,
                                                      4: 10]
    static let PlayerTextureInformation: [Int: String] = [0: "player-ship-0",
                                                          1: "player-ship-1",
                                                          2: "player-ship-2",
                                                          3: "player-ship-3",
                                                          4: "player-ship-4"]
    static let PlayerTrailEmitterInformation: [Int: String] = [0: "trail-emitter-0",
                                                               1: "trail-emitter-1",
                                                               2: "trail-emitter-2",
                                                               3: "trail-emitter-3",
                                                               4: "trail-emitter-4"]
    private init() { }
    
    func calculatePlayableArea(size: CGSize) {
        let aspectRatio = 19.5 / 9.0
        let maxPlayableWidth = size.height / aspectRatio
        let margin = (size.width - maxPlayableWidth) / 2
        gamePlayableArea = CGRect(x: margin, y: 0, width: maxPlayableWidth, height: size.height)
    }
}
