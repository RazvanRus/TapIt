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
    var noOfLives = GameManager.instance.noOfLives
    var scoreLabel = SKLabelNode()
    var noOfLivesLabel = SKLabelNode()


    override func didMove(to view: SKView) {
        initialize()
    }
    
    func initialize() {
        callCreateCube()
        createLabels()
        Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self, selector: #selector(GameplayScene.callCreateBonusItems), userInfo: nil, repeats: false)

    }
    
    override func update(_ currentTime: TimeInterval) {
        if GameManager.instance.noOfLives < 1 {
            // end game
            self.removeAllActions()
            self.removeAllChildren()
        }
        if GameManager.instance.noOfLives < noOfLives {
            decrementNoOfLives()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
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
            if atPoint(touch.location(in: self)).name == "BonusLife" {
                atPoint(touch.location(in: self)).removeFromParent()
                cubeCount -= 1
                incrementNoOfLifes()
            }
            if atPoint(touch.location(in: self)).name == "BonusLifeLabel" {
                atPoint(touch.location(in: self)).parent?.removeFromParent()
                cubeCount -= 1
                incrementNoOfLifes()
            }
        }
    }
    
    func callCreateCube() {
        if cubeCount < 12 {
            createCube()
        }
        Timer.scheduledTimer(timeInterval: TimeInterval(gameSpeed), target: self, selector: #selector(GameplayScene.callCreateCube), userInfo: nil, repeats: false)
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
    
    func callCreateBonusItems() {
        if cubeCount < 12 && noOfLives < 3 {
            createBonusItems()
        }
        Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self, selector: #selector(GameplayScene.callCreateBonusItems), userInfo: nil, repeats: false)
    }
    
    func createBonusItems() {
        var line = (Int(arc4random_uniform(UInt32(3))) * 250) - 250
        var colomn = (Int(arc4random_uniform(UInt32(4))) * 250) - 350
        
        while isPlaceTaken(line: line, colomn: colomn) {
            line = (Int(arc4random_uniform(UInt32(3))) * 250) - 250
            colomn = (Int(arc4random_uniform(UInt32(4))) * 250) - 350
        }
        
        
        let cube = BonusLife()
        cube.initialize()
        cube.setPosition(position: CGPoint(x: line, y: colomn))
        self.addChild(cube.cube)
        cubeCount += 1
        
    }
    
    func incrementScore() {
        score += 1
        scoreLabel.text = "\(score)"
    }
    
    func createLabels() {
        scoreLabel.zPosition = 4
        scoreLabel.position = CGPoint(x: -50, y: 560)
        scoreLabel.fontSize = 90
        scoreLabel.text = "\(score)"
        self.addChild(scoreLabel)
        
        noOfLivesLabel.zPosition = 4
        noOfLivesLabel.position = CGPoint(x: 250, y: 560)
        noOfLivesLabel.fontSize = 70
        noOfLivesLabel.fontColor = SKColor.red
        noOfLivesLabel.text = "\(GameManager.instance.noOfLives)"
        self.addChild(noOfLivesLabel)
    }

    func decrementNoOfLives() {
        noOfLives = GameManager.instance.noOfLives
        noOfLivesLabel.text = "\(noOfLives)"
        
        gameSpeed += 0.20
        
    }
    
    func incrementNoOfLifes() {
        GameManager.instance.noOfLives += 1
        noOfLives = GameManager.instance.noOfLives
        noOfLivesLabel.text = "\(noOfLives)"
        
        gameSpeed += 0.10
    }
    
    func isPlaceTaken(line: Int, colomn: Int) -> Bool {
        return atPoint(CGPoint(x: line, y: colomn)).name == "ColorCube" || atPoint(CGPoint(x: line, y: colomn)).name == "CubeLabel" || atPoint(CGPoint(x: line, y: colomn)).name == "BonusLife" || atPoint(CGPoint(x: line, y: colomn)).name == "BonusLifeLabel"
    }
    
}















