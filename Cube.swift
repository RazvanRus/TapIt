//
//  Cube.swift
//  TapIt
//
//  Created by Rus Razvan on 08/05/2017.
//  Copyright © 2017 RusRazvan. All rights reserved.
//

import SpriteKit

class Cube : SKSpriteNode{
    
    var cubeLabel = SKLabelNode()
    
    func initialize() {
        createCube()
        createActionForCube()
    }
    
    func createCube() {
        self.name = "ColorCube"
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.size = CGSize(width: 250, height: 250)
        self.zPosition = 3
        self.color = SKColor.green
        
        cubeLabel = SKLabelNode()
        cubeLabel.name = "CubeLabel"
        cubeLabel.position = CGPoint(x: 0, y: 0)
        cubeLabel.zPosition = 3
        cubeLabel.color = SKColor.black
        cubeLabel.verticalAlignmentMode = .center
        cubeLabel.horizontalAlignmentMode = .center
        cubeLabel.fontSize = 130
        cubeLabel.text = "3"
        
        self.addChild(cubeLabel)
    }
    
    func setPosition(position: CGPoint) {
        self.position = position
    }
    
    // create and run action
    func createActionForCube() {
        let resize1 = SKAction.scale(to: 0.90, duration: TimeInterval(1))
        let resize2 = SKAction.scale(to: 0.80, duration: TimeInterval(1))
        let resize3 = SKAction.scale(to: 0.70, duration: TimeInterval(1))
        
        let color1 = SKAction.run({() in self.color = SKColor.yellow})
        let color2 = SKAction.run({() in self.color = SKColor.red})
        
        let countDowun1 = SKAction.run({() in self.cubeLabel.text = "2"})
        let countDowun2 = SKAction.run({() in self.cubeLabel.text = "1"})
        let remove = SKAction.removeFromParent()
        let die = SKAction.run({() in GameManager.instance.noOfLives -= 1})
        
        let sequence = SKAction.sequence([resize1,color1,countDowun1,resize2,color2,countDowun2,resize3,remove,die])
        
        self.run(sequence)
    }
    
    
    func getPoints() -> Int {
        return Int(cubeLabel.text!)!
    }
    
}








