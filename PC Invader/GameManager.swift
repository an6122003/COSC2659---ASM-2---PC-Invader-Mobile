//
//  GameManager.swift
//  PC Invader
//
//  Created by An on 8/16/23.
//

import Foundation
import SwiftUI
import AVFoundation

class GameManager {
    static let gameManager = GameManager() // Singleton design pattern
    private init() { }

    var gamePlayableArea: CGRect?
    static var highScore: Int = UserDefaults.standard.integer(forKey: "highScore") // Default value is 0
    static var currentSelectedShip: Int = UserDefaults.standard.integer(forKey: "currentSelectedShip") // Default value is 0
    static var playerName: String = UserDefaults.standard.string(forKey: "playerName")!
    static var playerMoney: Int = UserDefaults.standard.integer(forKey: "playerMoney") // Default value is 0
    static var currentUnlockLevel: Int = UserDefaults.standard.integer(forKey: "currentUnlockLevel")
    static var enemyKilled: Int = UserDefaults.standard.integer(forKey: "enemyKilled") // Default value is 0
    
    static var musicMute: Bool = UserDefaults.standard.bool(forKey: "musicMute")
    
    static var soundMute: Bool = UserDefaults.standard.bool(forKey: "soundMute")

    static var shipBought: [Int] = [0] // Initial ship is 0
    
    static let ShipPrice: [Int: Int] = [0: 200,
                                        1: 400,
                                        2: 1000,
                                        3: 2000,
                                        4: 4000]
    
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
    
    var backgroundMusicPlayer: AVAudioPlayer?
    var soundEffectPlayer: AVAudioPlayer?
    var bulletSoundEffectPlayer: AVAudioPlayer?

    // Function to play background music
    func playBackgroundMusic(fileName: String, type: String) {
        if let musicPath = Bundle.main.path(forResource: fileName, ofType: type){
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: musicPath))
                if UserDefaults.standard.bool(forKey: "musicMute") == true{
                    backgroundMusicPlayer?.volume = 0
                }else{
                    backgroundMusicPlayer?.volume = 0.5
                }
                backgroundMusicPlayer?.numberOfLoops = -1  // Loop indefinitely
                backgroundMusicPlayer?.play()
            } catch {
                print("Error loading background music: \(error.localizedDescription)")
            }
        }
    }
    
    func stopBackgroundMusic(){
        backgroundMusicPlayer?.stop()
    }
    
    func playSoundEffect(fileName: String, type: String) {
        if let musicPath = Bundle.main.path(forResource: fileName, ofType: type){
            do {
                soundEffectPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: musicPath))
                if UserDefaults.standard.bool(forKey: "soundMute") == true{
                    soundEffectPlayer?.volume = 0
                }else{
                    soundEffectPlayer?.volume = 0.5
                }
                soundEffectPlayer?.numberOfLoops = 0
                soundEffectPlayer?.play()
            } catch {
                print("Error loading background music: \(error.localizedDescription)")
            }
        }
    }
    // Function to play sfx
    func playBulletSoundEffect(fileName: String, type: String) {
        if let musicPath = Bundle.main.path(forResource: fileName, ofType: type){
            do {
                bulletSoundEffectPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: musicPath))
                if UserDefaults.standard.bool(forKey: "soundMute") == true{
                    bulletSoundEffectPlayer?.volume = 0
                }else{
                    bulletSoundEffectPlayer?.volume = 0.1
                }
                bulletSoundEffectPlayer?.numberOfLoops = 0
                bulletSoundEffectPlayer?.play()
            } catch {
                print("Error loading background music: \(error.localizedDescription)")
            }
        }
    }
    // save ship bought array to userdefaults
    static func saveShipBought() {
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: Self.shipBought, requiringSecureCoding: false)
            UserDefaults.standard.set(encodedData, forKey: "shipBought")
        } catch {
            print("Error saving shipBought in GameManager: \(error)")
        }
    }
    // load ship bought array to userdefaults
    static func loadShipBought() {
        if let encodedData = UserDefaults.standard.data(forKey: "shipBought") {
            do {
                if let savedShipBought = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSNumber.self], from: encodedData) as? [Int] { //Specify array, and int is allowed to decode, and return result as an array of Int
                    Self.shipBought = savedShipBought
                }
            } catch {
                print("Error loading shipBought in GameManager: \(error)")
            }
        }
    }
    
    func calculatePlayableArea(size: CGSize) {
        let aspectRatio = 19.5 / 9.0
        let maxPlayableWidth = size.height / aspectRatio
        let margin = (size.width - maxPlayableWidth) / 2
        gamePlayableArea = CGRect(x: margin, y: 0, width: maxPlayableWidth, height: size.height)
    }
}
