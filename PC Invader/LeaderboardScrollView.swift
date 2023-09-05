//
//  LeaderboardScrollView.swift
//  PC Invader
//
//  Created by An on 9/5/23.
//

import SwiftUI
import SpriteKit

struct LeaderboardScrollView: View {
//    let leaderboardData: [String: Int]

    var body: some View {
        let leaderboardData: [String: Int] = [
                "Player 1": 5000,
                "Player 2": 7000,
                "Player 3": 3000,
                "Player 4": 5000,
                "Player 5": 7000,
                "Player 6": 3000,
                "Player 7": 5000,
                "Player 8": 7000,
                "Player 9": 3000,
            ]
        
        var scene: SKScene {
            let scene = LeaderboardScene(size: CGSize(width: 1536, height: 2048))
            scene.scaleMode = .aspectFill
            return scene
        }
        ZStack{
            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(leaderboardData.sorted { $0.value > $1.value }, id: \.key) { (playerName, highScore) in
                        Text("\(playerName): \(highScore)")
                            .font(.title)
                            .padding()
                            
                    }
                }
            }
            .background(.clear)
        }
        
        
        
    }
}

struct LeaderboardScrollView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardScrollView()
    }
}
