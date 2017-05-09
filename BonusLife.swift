//
//  BonusLife.swift
//  TapIt
//
//  Created by Rus Razvan on 08/05/2017.
//  Copyright © 2017 RusRazvan. All rights reserved.
//

import SpriteKit

class BonusLife {
    
    var bonusLife = SKSpriteNode()
    var bonusLifeLabel = SKLabelNode()
    
    func initialize() {
        createCube()
        createAction()
    }
    
    func createCube() {
        bonusLife = SKSpriteNode()
        bonusLife.name = "BonusLife"
        bonusLife.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bonusLife.size = CGSize(width: 250, height: 250)
        bonusLife.zPosition = 2
        bonusLife.color = SKColor.blue
        
        bonusLifeLabel = SKLabelNode()
        bonusLifeLabel.name = "BonusLifeLabel"
        bonusLifeLabel.position = CGPoint(x: 0, y: 0)
        bonusLifeLabel.zPosition = 3
        bonusLifeLabel.color = SKColor.black
        bonusLifeLabel.verticalAlignmentMode = .center
        bonusLifeLabel.horizontalAlignmentMode = .center
        bonusLifeLabel.fontSize = 130
        bonusLifeLabel.text = "<#"
        
        bonusLife.addChild(bonusLifeLabel)
    }
    
    func setPosition(position: CGPoint) {
        bonusLife.position = position
    }
    
    func createAction() {
        let resize = SKAction.scale(to: 0.80, duration: TimeInterval(5))
        let remove = SKAction.removeFromParent()
        let die = SKAction.run({() in GameManager.instance.noOfLives += 1})

        let sequence = SKAction.sequence([resize,remove,die])
        
        bonusLife.run(sequence)
    }
    
    
}

