//
//  GameManager.swift
//  TapIt
//
//  Created by Rus Razvan on 08/05/2017.
//  Copyright © 2017 RusRazvan. All rights reserved.
//

import Foundation

class GameManager {

    var noOfLives = 3
    
    static let instance = GameManager()
    private init() {}
    
    func resetLifes() {
        noOfLives = 3
    }
    
    func setHighscore(highscore: Int) {
        UserDefaults.standard.set(highscore, forKey: "Highscore")
    }
    
    func getHighscore() -> Int {
        return UserDefaults.standard.integer(forKey: "Highscore")
    }
}
