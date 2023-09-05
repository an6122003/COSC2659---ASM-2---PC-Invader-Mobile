//
//  Registration Scene.swift
//  PC Invader
//
//  Created by An on 9/5/23.
//

import Foundation
import SpriteKit

class RegistrationScene: SKScene {
    var textField: UITextField!
    var submitButton: SKSpriteNode!
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2
                                      , y: self.size.height/2)
        background.zPosition = 0
        
        let headerLogo = SKSpriteNode(imageNamed: "main-menu-header")
        headerLogo.zPosition = 1
        headerLogo.setScale(0.8)
        headerLogo.position = background.position
        headerLogo.position.y += 400
        
        submitButton = SKSpriteNode(imageNamed: "shop-placeholder")
        submitButton.position = background.position
        submitButton.position.y -= 100
        submitButton.zPosition = 1
        submitButton.setScale(1)
        
        let submitButtonText = SKLabelNode(fontNamed: "ethnocentric")
        submitButtonText.position = submitButton.position
        submitButtonText.text = "Submit"
        submitButtonText.position.y -= 15
        submitButtonText.zPosition = 3
        submitButtonText.fontSize = 60
        
        self.addChild(background)
        self.addChild(headerLogo)
        self.addChild(submitButton)
        self.addChild(submitButtonText)
        
        // UITextField for text input
        textField = UITextField(frame: CGRect(x: self.view!.frame.size.width / 2 - 100, y: self.view!.frame.size.height / 2 - 50, width: 200, height: 40))
        textField.placeholder = "Enter your text"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.white
        textField.textColor = .black
        view.addSubview(textField)
    }
    
    @objc func submitButtonPressed() {
        UserDefaults.standard.set(textField.text, forKey: "playerName")
        textField.removeFromSuperview()
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if submitButton.contains(location) {
                GameManager.gameManager.playSoundEffect(fileName: "click", type: ".mp3")
                submitButtonPressed()
                changeScene(sceneToMove: MainMenuScene(size: self.size))
            }
        }
    }
    
    func changeScene(sceneToMove: SKScene){
        sceneToMove.size = self.size
        sceneToMove.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 1)
        self.view?.presentScene(sceneToMove, transition: transition)
    }
    
}

