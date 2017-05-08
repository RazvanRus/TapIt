//
//  BonusLife.swift
//  TapIt
//
//  Created by Rus Razvan on 08/05/2017.
//  Copyright © 2017 RusRazvan. All rights reserved.
//

import SpriteKit

class BonusLife {
    
    var cube = SKSpriteNode()
    var cubeLabel = SKLabelNode()
    
    func initialize() {
        createCube()
    }
    
    func createCube() {
        cube = SKSpriteNode()
        cube.name = "BonusLife"
        cube.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        cube.size = CGSize(width: 250, height: 250)
        cube.zPosition = 2
        cube.color = SKColor.blue
        
        cubeLabel = SKLabelNode()
        cubeLabel.name = "BonusLifeLabel"
        cubeLabel.position = CGPoint(x: 0, y: 0)
        cubeLabel.zPosition = 3
        cubeLabel.color = SKColor.black
        cubeLabel.verticalAlignmentMode = .center
        cubeLabel.horizontalAlignmentMode = .center
        cubeLabel.fontSize = 130
        cubeLabel.text = "<#"
        
        cube.addChild(cubeLabel)
        
        let resize = SKAction.scale(to: 0.80, duration: TimeInterval(5))

        let remove = SKAction.removeFromParent()
        
        let sequence = SKAction.sequence([resize,remove])
        
        cube.run(sequence)
    }
    
    func setPosition(position: CGPoint) {
        cube.position = position
    }
    
    
    
    
}

