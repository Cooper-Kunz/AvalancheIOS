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
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = SKColor.black
        gameOverLabel.text = "Game Over!"
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: 2.0 / 3.0 * self.size.height);
        
        self.addChild(gameOverLabel)
        
        //need to customize score label at some point
        let scoreLabel = SKLabelNode(fontNamed:  "Helvetica")
        scoreLabel.fontColor = UIColor.black
        scoreLabel.fontSize = 40
        scoreLabel.text = "Your score was \(scoreEnd!)"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.size.height - 70)
        
        self.addChild(scoreLabel)

        
        let tapLabel = SKLabelNode(fontNamed: "Courier")
        tapLabel.fontSize = 25
        tapLabel.fontColor = SKColor.black
        tapLabel.text = "(Tap to Play Again)"
        tapLabel.position = CGPoint(x: self.size.width/2, y: gameOverLabel.frame.origin.y - gameOverLabel.frame.size.height - 40);
        
        self.addChild(tapLabel)
        
        self.backgroundColor = SKColor.white
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Stub
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)  {
        //Stub
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Stub
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)  {
        
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = .aspectFill
        self.view?.presentScene(gameScene, transition: SKTransition.doorsCloseHorizontal(withDuration: 1.0))
    }
}
