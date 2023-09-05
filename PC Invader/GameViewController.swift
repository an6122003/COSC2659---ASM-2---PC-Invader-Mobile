//
//  GameViewController.swift
//  PC Invader
//
//  Created by An on 8/12/23.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var scene: SKScene!
    override func viewDidLoad() {
            
    super.viewDidLoad()
            
            if let view = self.view as! SKView? {

                // Load the SKScene from 'GameScene.sks'
                if UserDefaults.standard.string(forKey: "playerName") == nil {
                    scene = RegistrationScene(size: CGSize(width: 1536, height: 2048))
                }else{
                    scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
                }

                    // Set the scale mode to scale to fit the window

                    scene.scaleMode = .aspectFill
                    
                    // Present the scene

                    view.presentScene(scene)
                
                view.ignoresSiblingOrder = true
                
                view.showsFPS = false

                view.showsNodeCount = false
            }

        }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
