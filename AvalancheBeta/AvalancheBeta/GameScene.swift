//
//  GameScene.swift
//  AvalancheBeta
//
//  Created by Cooper Kunz on 7/8/16.
//  Copyright (c) 2016 Cooper.Kunz. All rights reserved.

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var gameOver = false
    var score = 0
    var time = 0
    var ball = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var motionManager: CMMotionManager!
    var movingObjects = SKSpriteNode()
    let kBallSize = CGSize(width: 30, height: 20)
    let kBallName = "ball"
    let kVertPathDown = "path"
    let kVertPathName = "leftPath"
    let kVertPathName2 = "rightPath"
    enum ColliderType: UInt32 {
        case ball = 1
        case object = 2
        case path = 3
    }

    override func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor.white
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontColor = UIColor.black
        scoreLabel.fontSize = 60
        scoreLabel.text = (String)(score)
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.size.height - 70)
        self.addChild(scoreLabel)
        
        //Allow physics
        self.physicsWorld.contactDelegate = self
        //Allow access to phone accelerametor
        self.motionManager = CMMotionManager()
        self.motionManager.startAccelerometerUpdates()
        
        setUpBoundaries()
        
        createInitialPath()
        
        setUpPath()
        
        self.addChild(movingObjects)
    
        _ = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(GameScene.setUpPath), userInfo: nil, repeats: true)
        
        setUpBall()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Do nothing
    }
   
    override func update(_ currentTime: TimeInterval) {
        
        processUserMotionForUpdate(currentTime)
        
        self.time += 1
        
        //Add time to the score
        self.score = time
        
        scoreLabel.text = String(score)
    }

    func didBegin(_ contact: SKPhysicsContact) {
        
        //If the ball is touching the path, continue
        if  contact.bodyA.categoryBitMask == ColliderType.path.rawValue {  }
    
        //Else, if the ball is hitting a boundary, stop the game.
        else {
        
            gameOver = true
        
            motionManager.stopAccelerometerUpdates()
            
            //Present the game over View
            let gameOverScene: GameOverScene = GameOverScene(size: size)
            gameOverScene.scoreEnd = scoreLabel.text
            view?.presentScene(gameOverScene, transition: SKTransition.doorsOpenHorizontal(withDuration: 1.0))
        }
    }
    
    func setUpBall() {
        
        let ball = makeBall()
        ball.position = CGPoint(x: size.width / 2.0, y: size.height / 2)
        addChild(ball)
    }
    
    func makeBall() -> SKNode {
        
        //May need to find a cooler looking ball. lol.
        let ball = SKSpriteNode(imageNamed: "ball_img.png")
        ball.name = kBallName
        ball.physicsBody = SKPhysicsBody(circleOfRadius: kBallSize.height / 2)
        ball.physicsBody!.isDynamic = true
        ball.physicsBody!.affectedByGravity = true
        ball.physicsBody!.mass = 0.02
        ball.physicsBody!.categoryBitMask = ColliderType.ball.rawValue
        ball.physicsBody!.contactTestBitMask = ColliderType.path.rawValue
        ball.physicsBody!.collisionBitMask = ColliderType.object.rawValue
        
        return ball
    }
    
    func setUpBoundaries() {
        
        //These positions are probably only nice for my 6s screensize tbh.
        //Will resize if I actually continue dev. Currently just testing for fun.
        let groundLeft = SKNode()
        
        groundLeft.position = CGPoint(x: 325, y: 0)
        groundLeft.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: self.frame.height * 2))
        groundLeft.physicsBody!.isDynamic = false
        
        groundLeft.physicsBody!.categoryBitMask = ColliderType.object.rawValue
        groundLeft.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        groundLeft.physicsBody!.collisionBitMask = ColliderType.object.rawValue
        
        self.addChild(groundLeft)
        
        let ground = SKNode()
        
        ground.position = CGPoint(x: 0, y: 0)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 2, height: 1))
        ground.physicsBody!.isDynamic = false
        
        ground.physicsBody!.categoryBitMask = ColliderType.object.rawValue
        ground.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.object.rawValue
        
        self.addChild(ground)
        
        let roof = SKNode()
        
        roof.position = CGPoint(x: 0, y: 740)
        roof.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 2, height: 1))
        roof.physicsBody!.isDynamic = false
        
        roof.physicsBody!.categoryBitMask = ColliderType.object.rawValue
        roof.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        roof.physicsBody!.collisionBitMask = ColliderType.object.rawValue
        
        self.addChild(roof)
        
        let groundRight = SKNode()
        
        groundRight.position = CGPoint(x: 700, y: 0)
        groundRight.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: self.frame.height * 2))
        groundRight.physicsBody!.isDynamic = false
        
        groundRight.physicsBody!.categoryBitMask = ColliderType.object.rawValue
        groundRight.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        groundRight.physicsBody!.collisionBitMask = ColliderType.object.rawValue
        
        self.addChild(groundRight)
    }
    
    func createInitialPath(){
        
        let pathTexture = SKTexture(imageNamed: "path_temporary.png")
        let path = SKSpriteNode(texture: pathTexture)
        
        let movePath = SKAction.moveBy(x: 0, y: 1000, duration: TimeInterval(10))
        let removePath = SKAction.removeFromParent()
        let movePathForever = SKAction.sequence([movePath, removePath])
        var increase = (100)
        
        let xPos = CGFloat(self.frame.width / 2)
        let yPos = CGFloat(Int(arc4random()) % 50 + increase)
        
        path.position = CGPoint(x: xPos, y: yPos)
        path.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pathTexture.size().width - 20, height: 50))
        path.physicsBody!.isDynamic = false
        path.physicsBody!.categoryBitMask = ColliderType.path.rawValue
        path.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        path.physicsBody!.collisionBitMask = ColliderType.object.rawValue
        path.run(movePathForever)

        
        self.movingObjects.addChild(path)
        
        increase += 100
    }

    func setUpPath(){
        
        let pathTexture = SKTexture(imageNamed: "path_temporary.png")
        let path = SKSpriteNode(texture: pathTexture)

        let movePath = SKAction.moveBy(x: 0, y: 1000, duration: TimeInterval(10))
        let removePath = SKAction.removeFromParent()
        let movePathForever = SKAction.sequence([movePath, removePath])
        var increase = (100)
        
        let xPos = CGFloat(Int(arc4random()) % (Int(self.frame.width / 2)))
        let yPos = CGFloat(Int(arc4random()) % 50 + increase)
    
        path.position = CGPoint(x: xPos, y: yPos)
        path.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pathTexture.size().width - 20, height: 50))
        path.physicsBody!.isDynamic = false
        path.physicsBody!.categoryBitMask = ColliderType.path.rawValue
        path.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        path.physicsBody!.collisionBitMask = ColliderType.object.rawValue
        path.run(movePathForever)
        
        movingObjects.addChild(path)
        
        let leftPath = SKSpriteNode(texture: pathTexture)
        
        leftPath.position = CGPoint(x:xPos - (225),y: yPos + 150.0)
        leftPath.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pathTexture.size().width - 20, height: 50))
        leftPath.physicsBody!.isDynamic = false
        leftPath.physicsBody!.categoryBitMask = ColliderType.path.rawValue
        leftPath.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        leftPath.physicsBody!.collisionBitMask = ColliderType.object.rawValue
        leftPath.run(movePathForever)
        
        movingObjects.addChild(leftPath)
        
        let rightPath = SKSpriteNode(texture: pathTexture)
        
        rightPath.position = CGPoint(x: xPos + (225),y: yPos - 150.0)
        rightPath.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pathTexture.size().width - 20, height: 50))
        rightPath.physicsBody!.isDynamic = false
        rightPath.physicsBody!.categoryBitMask = ColliderType.path.rawValue
        rightPath.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        rightPath.physicsBody!.collisionBitMask = ColliderType.object.rawValue
        rightPath.run(movePathForever)

        movingObjects.addChild(rightPath)
        
        increase+=100
    }
    
    func processUserMotionForUpdate(_ currentTime: CFTimeInterval) {
    
        if let ball = childNode(withName: kBallName) as? SKSpriteNode {
   
            if let data = motionManager.accelerometerData {
                
                //Force of tiltage
                if fabs(data.acceleration.x) > 0.1{
                    //Force of sliding
                    ball.physicsBody!.applyForce(CGVector(dx: 50.0 * CGFloat(data.acceleration.x), dy: 0))
                }
            }
        }
    }
}
