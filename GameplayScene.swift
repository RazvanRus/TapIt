//
//  GameplayScene.swift
//  TapIt
//
//  Created by Rus Razvan on 08/05/2017.
//  Copyright © 2017 RusRazvan. All rights reserved.
//

import SpriteKit

class GameplayScene: SKScene {

    var gameSpeed = 1.0
    var cubeCount = 0
    var score = 0
    var noOfLifes = GameManager.instance.noOfLives
    
    var scoreLabel = SKLabelNode()
    var noOfLifesLabel = SKLabelNode()
    
    var timer = Timer()
    var isGamePaused = false
    var isEndGame = false
    
    var pauseButton = SKSpriteNode()
    var resumeButton = SKSpriteNode()
    
    var pausePannel = SKSpriteNode()
    var endGamePannel = SKSpriteNode()

    override func didMove(to view: SKView) {
        initialize()
    }
    
    func initialize() {
        GameManager.instance.resetLifes()
        noOfLifes = GameManager.instance.noOfLives
        callCreateCube()
        createLabels()
        createPauseButton()
    }
    
    func endGame() {
        isEndGame = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        if GameManager.instance.noOfLives < 1 {
            // end game
            Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(GameplayScene.endGame), userInfo: nil, repeats: false)
            self.scene?.isPaused = true
            timer.invalidate()
            isGamePaused = true
            createEndGamePannel()
        }
        if GameManager.instance.noOfLives < noOfLifes {
            decrementNoOfLives()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if isEndGame {
                let mainMenu = MainMenuScene(fileNamed: "MainMenuScene")
                mainMenu?.scaleMode = .aspectFill
                self.view?.presentScene(mainMenu!, transition: SKTransition.crossFade(withDuration: TimeInterval(0.5)))
            }
            let location = touch.location(in: self)
            if !isGamePaused {
                if atPoint(location).name == nil {
                    if cubeCount < 11 {
                        createCube()
                    }
                }
                if atPoint(location).name == "ColorCube" {
                    atPoint(location).removeFromParent()
                    cubeCount -= 1
                    incrementScore()
                }
                if atPoint(location).name == "CubeLabel" {
                    atPoint(location).parent?.removeFromParent()
                    cubeCount -= 1
                    incrementScore()
                }
            }
//            if atPoint(location).name == "Replay" {
//                let scene = GameplayScene(fileNamed: "GameplayScene")
//                    // Set the scale mode to scale to fit the window
//                scene?.scaleMode = .aspectFill
//                    
//                    // Present the scene
//                view?.presentScene(scene)
//            }
//            if atPoint(location).name == "Quit" {
//                let mainMenu = GameplayScene(fileNamed: "GameplayScene")
//                mainMenu?.scaleMode = .aspectFill
//                self.view?.presentScene(mainMenu!, transition: SKTransition.crossFade(withDuration: TimeInterval(0.5)))
//            }
            
            
            if atPoint(location).name == "Pause" {
                // create pause pannel
                pauseButton.removeFromParent()
                createResumeButton()
                self.scene?.isPaused = true
                timer.invalidate()
                isGamePaused = true
                createPausePannel()
            }
            if atPoint(location).name == "Resume" {
                self.scene?.isPaused = false
                callCreateCube()
                isGamePaused = false
                resumeButton.removeFromParent()
                createPauseButton()
                pausePannel.removeFromParent()
            }
        }
    }
    
    
    // creating cubes
    func callCreateCube() {
        if cubeCount < 12 && !isGamePaused{
            createCube()
        }
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(gameSpeed), target: self, selector: #selector(GameplayScene.callCreateCube), userInfo: nil, repeats: false)
    }
    
    func createCube() {
        var line = (Int(arc4random_uniform(UInt32(3))) * 250) - 250
        var colomn = (Int(arc4random_uniform(UInt32(4))) * 250) - 350
        
        
        while isPlaceTaken(line: line, colomn: colomn) {
            line = (Int(arc4random_uniform(UInt32(3))) * 250) - 250
            colomn = (Int(arc4random_uniform(UInt32(4))) * 250) - 350
        }
        
        
        let cube = Cube()
        cube.initialize()
        cube.setPosition(position: CGPoint(x: line, y: colomn))
        self.addChild(cube.cube)
        cubeCount += 1
        
        if gameSpeed > 0.3 {
            gameSpeed -= 0.05 * gameSpeed
        } else if gameSpeed > 0.25 {
            gameSpeed -= 0.015 * gameSpeed
        } else if gameSpeed > 0.2 {
            gameSpeed -= 0.005 * gameSpeed
        } else if gameSpeed > 0.15 {
            gameSpeed -= 0.001 * gameSpeed
        }
        
    }
    

    
    
    // incrementing the score
    func incrementScore() {
        score += 1
        scoreLabel.text = "\(score)"
    }
    
    // creating score and lifes label
    func createLabels() {
        scoreLabel.zPosition = 4
        scoreLabel.position = CGPoint(x: 0, y: 560)
        scoreLabel.fontSize = 90
        scoreLabel.text = "\(score)"
        self.addChild(scoreLabel)
        
        noOfLifesLabel.zPosition = 4
        noOfLifesLabel.position = CGPoint(x: -300, y: 560)
        noOfLifesLabel.fontSize = 70
        noOfLifesLabel.fontColor = SKColor.red
        noOfLifesLabel.text = "\(GameManager.instance.noOfLives)"
        self.addChild(noOfLifesLabel)
    }
    
    func createPauseButton() {
        pauseButton = SKSpriteNode(imageNamed: "Pause")
        pauseButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pauseButton.zPosition = 4
        pauseButton.name = "Pause"
        pauseButton.alpha = 0.5
        pauseButton.setScale(0.6)
        pauseButton.position = CGPoint(x: 310, y: 590)
        self.addChild(pauseButton)
    }
    
    func createResumeButton() {
        resumeButton = SKSpriteNode(imageNamed: "Resume")
        resumeButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        resumeButton.zPosition = 4
        resumeButton.name = "Resume"
        resumeButton.alpha = 0.5
        resumeButton.setScale(0.8)
        resumeButton.position = CGPoint(x: 220, y: 590)
        self.addChild(resumeButton)
    }

    // decrementing numbers of lifes
    func decrementNoOfLives() {
        noOfLifes = GameManager.instance.noOfLives
        noOfLifesLabel.text = "\(noOfLifes)"
        
        gameSpeed += 0.20
        
    }

    
    
    // chacking if the place is empty
    func isPlaceTaken(line: Int, colomn: Int) -> Bool {

        return !(atPoint(CGPoint(x: line, y: colomn)).name == nil)
        
        //        return atPoint(CGPoint(x: line, y: colomn)).name == "ColorCube" || atPoint(CGPoint(x: line, y: colomn)).name == "CubeLabel" || atPoint(CGPoint(x: line, y: colomn)).name == "BonusLife" || atPoint(CGPoint(x: line, y: colomn)).name == "BonusLifeLabel"
    }
    
    func randomBetweenNumbers(firstNumber: CGFloat,secoundeNoumber: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNumber - secoundeNoumber) + min(firstNumber, secoundeNoumber)
    }
    
    func createPausePannel() {
        pausePannel = SKSpriteNode()
        pausePannel.name = "PausePannel"
        pausePannel.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pausePannel.position = CGPoint(x: 0, y: 28)
        pausePannel.size = CGSize(width: 750, height: 1010)
        pausePannel.zPosition = 10
        pausePannel.color = SKColor.black
        pausePannel.alpha = 0.75
        
        let pauseLabel = SKLabelNode()
        pauseLabel.name = "PausePannelLabel"
        pauseLabel.position = CGPoint(x: 0, y: 0)
        pauseLabel.fontSize = 200
        pauseLabel.fontColor = SKColor.white
        pauseLabel.alpha = 0.8
        pauseLabel.text = "Paused"
        
        pausePannel.addChild(pauseLabel)
        
        self.addChild(pausePannel)
    }
    
    func createEndGamePannel() {
        
        if GameManager.instance.getHighscore() < score {
            GameManager.instance.setHighscore(highscore: score)
        }
        
        endGamePannel = SKSpriteNode()
        
        endGamePannel.name = "EndGamePannel"
        endGamePannel.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        endGamePannel.position = CGPoint(x: 0, y: 0)
        endGamePannel.size = CGSize(width: 750, height: 1334)
        endGamePannel.zPosition = 10
        endGamePannel.color = SKColor.black
        endGamePannel.alpha = 0.95
        
        
        let endGameLabel = SKLabelNode()
        endGameLabel.name = "EndGamePannelLabel"
        endGameLabel.position = CGPoint(x: 0, y: 50)
        endGameLabel.fontSize = 120
        endGameLabel.fontColor = SKColor.white
        endGameLabel.alpha = 0.8
        endGameLabel.text = "Game Over"
        endGamePannel.addChild(endGameLabel)
        
        let endGameScoreLabel = SKLabelNode()
        endGameScoreLabel.name = "EndGameScoreLabel"
        endGameScoreLabel.position = CGPoint(x: 0, y: 300)
        endGameScoreLabel.fontSize = 120
        endGameScoreLabel.fontColor = SKColor.white
        endGameScoreLabel.alpha = 0.8
        endGameScoreLabel.text = "\(score)"
        endGamePannel.addChild(endGameScoreLabel)
        
        let endGameQuitLabel = SKLabelNode()
        endGameQuitLabel.name = "EndGamePannelQuitLabel"
        endGameQuitLabel.position = CGPoint(x: 0, y: -200)
        endGameQuitLabel.fontSize = 90
        endGameQuitLabel.fontColor = SKColor.white
        endGameQuitLabel.alpha = 0.6
        endGameQuitLabel.text = "Tap to quit"
        endGamePannel.addChild(endGameQuitLabel)
        
        self.addChild(endGamePannel)
    }
    
    
    
    
}















