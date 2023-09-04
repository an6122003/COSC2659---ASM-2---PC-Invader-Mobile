//
//  LeaderboardScrollView.swift
//  PC Invader
//
//  Created by An on 9/5/23.
//

import SwiftUI

struct LeaderboardScrollView: View {
    let leaderboardData: [String: Int]

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(leaderboardData.sorted { $0.value > $1.value }, id: \.key) { (playerName, highScore) in
                    Text("\(playerName): \(highScore)")
                        .font(.title)
                        .padding()
                }
            }
        }
    }
}

//struct LeaderboardScrollView_Previews: PreviewProvider {
//    static var previews: some View {
//        LeaderboardScrollView()
//    }
//}
