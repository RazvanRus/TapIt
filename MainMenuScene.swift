//
//  MainMenuScene.swift
//  TapIt
//
//  Created by Rus Razvan on 09/05/2017.
//  Copyright © 2017 RusRazvan. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        initialize()
    }
    
    func initialize() {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if atPoint(location).name == "Play" {
                let mainMenu = GameplayScene(fileNamed: "GameplayScene")
                mainMenu?.scaleMode = .aspectFill
                self.view?.presentScene(mainMenu!, transition: SKTransition.crossFade(withDuration: TimeInterval(0.5)))
            }
            if atPoint(location).name == "Highscore" {
                // display highscore
                displayHighscore()
            }
        }
    }
    
    func displayHighscore() {
        let scoreLabel = SKLabelNode()
        scoreLabel.name = "ScoreLabel"
        scoreLabel.zPosition = 5
        scoreLabel.position = CGPoint(x: 0, y: 200)
        scoreLabel.fontSize = 120
        scoreLabel.fontColor = SKColor.white
        scoreLabel.alpha = 0.95
        scoreLabel.text = "\(GameManager.instance.getHighscore())"
        self.addChild(scoreLabel)
    }
    
    
    
    
}
