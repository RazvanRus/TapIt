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
    
    var pauseButton = SKSpriteNode()
    var resumeButton = SKSpriteNode()

    override func didMove(to view: SKView) {
        initialize()
    }
    
    func initialize() {
        callCreateCube()
        createLabels()
        createPauseButton()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if GameManager.instance.noOfLives < 1 {
            // end game
            self.removeAllActions()
            self.removeAllChildren()
        }
        if GameManager.instance.noOfLives < noOfLifes {
            decrementNoOfLives()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if !isGamePaused {
                if atPoint(touch.location(in: self)).name == nil {
                    if cubeCount < 11 {
                        createCube()
                    }
                }
                if atPoint(touch.location(in: self)).name == "ColorCube" {
                    atPoint(touch.location(in: self)).removeFromParent()
                    cubeCount -= 1
                    incrementScore()
                }
                if atPoint(touch.location(in: self)).name == "CubeLabel" {
                    atPoint(touch.location(in: self)).parent?.removeFromParent()
                    cubeCount -= 1
                    incrementScore()
                }
            }
            
            if atPoint(touch.location(in: self)).name == "Pause" {
                // create pause pannel
                pauseButton.removeFromParent()
                createResumeButton()
                self.scene?.isPaused = true
                timer.invalidate()
                isGamePaused = true
            }
            if atPoint(touch.location(in: self)).name == "Resume" {
                self.scene?.isPaused = false
                callCreateCube()
                isGamePaused = false
                resumeButton.removeFromParent()
                createPauseButton()
            }
        }
    }
    
    
    // creating cubes
    func callCreateCube() {
        if cubeCount < 12 {
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
        resumeButton = SKSpriteNode(imageNamed: "play")
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
        return atPoint(CGPoint(x: line, y: colomn)).name == "ColorCube" || atPoint(CGPoint(x: line, y: colomn)).name == "CubeLabel" || atPoint(CGPoint(x: line, y: colomn)).name == "BonusLife" || atPoint(CGPoint(x: line, y: colomn)).name == "BonusLifeLabel"
    }
    
    func randomBetweenNumbers(firstNumber: CGFloat,secoundeNoumber: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNumber - secoundeNoumber) + min(firstNumber, secoundeNoumber)
    }
    
}















