//
//  GameScene.swift
//  AvalancheBeta
//
//  Created by Cooper Kunz on 7/8/16.
//  Copyright (c) 2016 Cooper.Kunz. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var gameOver = false
    
    var ball = SKSpriteNode()

    
    var motionManager: CMMotionManager!
    
    let kBallSize = CGSize(width: 30, height: 20)
    let kBallName = "ball"
    
    enum ColliderType: UInt32 {
        
        case Ball = 1
        case Object = 2
        case Path = 3
    }

    
    //MARK: View did load
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.motionManager = CMMotionManager()
        self.motionManager.startAccelerometerUpdates()
        
        setUpBall()
        setUpBoundaries()
        setUpPath(self.frame.width / 2, yPos: 50)
        
         self.backgroundColor = SKColor.whiteColor()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        //Pass to process sliding func in real time
        processUserMotionForUpdate(currentTime)
    }

    func didBeginContact(contact: SKPhysicsContact) {
        
        if  contact.bodyA.categoryBitMask == ColliderType.Path.rawValue {  }
    
        else {
        
            gameOver = true
        
            motionManager.stopAccelerometerUpdates()
        
            let gameOverScene: GameOverScene = GameOverScene(size: size)
            view?.presentScene(gameOverScene, transition: SKTransition.doorsOpenHorizontalWithDuration(1.0))
        }
    }
    
    
    func setUpBall() {
     
        let ball = makeBall()
        ball.position = CGPoint(x: size.width / 2.0, y: kBallSize.height * 5)
        addChild(ball)
    }
    
    func makeBall() -> SKNode {
        
        let ball = SKSpriteNode(imageNamed: "ball_img.png")
        
        ball.name = kBallName
        ball.physicsBody = SKPhysicsBody(circleOfRadius: kBallSize.height / 2)
        ball.physicsBody!.dynamic = true
        //I think I'm going to want to make this true as soon as I make the "path" it can sit on..
        ball.physicsBody!.affectedByGravity = true
        ball.physicsBody!.mass = 0.02
        ball.physicsBody!.categoryBitMask = ColliderType.Ball.rawValue
        ball.physicsBody!.contactTestBitMask = ColliderType.Path.rawValue
        ball.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        return ball
    }
    
    func setUpBoundaries() {
        
        // changed ground from var to let
        let groundLeft = SKNode()
        
        groundLeft.position = CGPointMake(325, 0)
        groundLeft.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(10, self.frame.height))
        groundLeft.physicsBody!.dynamic = false
        
        groundLeft.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        groundLeft.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        groundLeft.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(groundLeft)
        
        let ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.size.width * 2, 1))
        ground.physicsBody!.dynamic = false
        
        ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(ground)
        
        // changed ground from var to let
        let groundRight = SKNode()
        
        groundRight.position = CGPointMake(700, 0)
        groundRight.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(10, self.frame.height))
        groundRight.physicsBody!.dynamic = false
        
        groundRight.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        groundRight.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        groundRight.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(groundRight)
        
    }

    func setUpPath(xPos: CGFloat, yPos: CGFloat){
        
        let pathTexture = SKTexture(imageNamed: "path_temporary.png")
        let path = SKSpriteNode(texture: pathTexture)
        
        path.position = CGPointMake(xPos, yPos)
        path.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pathTexture.size().width - 20, 40))
        path.physicsBody!.dynamic = false
        path.physicsBody!.categoryBitMask = ColliderType.Path.rawValue
        path.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        path.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(path)
        
        
    }
    //Tbh, I copied this func from stackoverflow
    func processUserMotionForUpdate(currentTime: CFTimeInterval) {
    
        if let ball = childNodeWithName(kBallName) as? SKSpriteNode {
   
            if let data = motionManager.accelerometerData {
                //Force of tiltage
                if fabs(data.acceleration.x) > 0.1{
                    //Force of sliding
                    ball.physicsBody!.applyForce(CGVectorMake(50.0 * CGFloat(data.acceleration.x), 0))
                }
            }
        }
    }
}
