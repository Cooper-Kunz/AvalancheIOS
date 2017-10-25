//
//  GameOverScene.swift
//  AvalancheBeta
//
//  Created by Cooper Kunz on 7/9/16.
//  Copyright © 2016 Cooper.Kunz. All rights reserved.

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    var contentCreated = false
    var scoreEnd: String!
    
    override func didMove(to view: SKView) {
    
        if (!self.contentCreated) {
            self.createContent()
            self.contentCreated = true
        }
    }
    
    func createContent() {
        
        let gameOverLabel = SKLabelNode(fontNamed: "Courier")
        gameOverLabel.fontSize = 70
        gameOverLabel.fontColor = SKColor.black
        gameOverLabel.text = "Game over!"
        gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 150);
        
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed:  "Helvetica")
        scoreLabel.fontColor = UIColor.black
        scoreLabel.fontSize = 80
        scoreLabel.text = "Your score was \(scoreEnd!)"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        self.addChild(scoreLabel)
        
        let tapLabel = SKLabelNode(fontNamed: "Courier")
        tapLabel.fontSize = 40
        tapLabel.fontColor = SKColor.black
        tapLabel.text = "Tap to Play Again"
        tapLabel.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 80)
        
        self.addChild(tapLabel)
        
        self.backgroundColor = SKColor.white
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)  {
        
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = .aspectFill
        self.view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 2.0))
    }
}
