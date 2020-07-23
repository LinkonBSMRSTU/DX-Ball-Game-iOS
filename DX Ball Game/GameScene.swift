//
//  GameScene.swift
//  DX Ball Game
//
//  Created by Fazle Rabbi Linkon on 21/7/20.
//  Copyright © 2020 Fazle Rabbi Linkon. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var paddleTouched = false
    
    let bundle = Bundle.main

    let ballCategoryName = "ball"
    let paddleCategoryName = "paddle"
    let brickCategoryName = "brick"
    
    var backgroundMusicPlayer = AVAudioPlayer()
    
    let ballCategory: UInt32 = 0x1 << 0
    let bottomCategory: UInt32 = 0x1 << 1
    let brickCategory: UInt32 = 0x1 << 2
    let paddleCategory: UInt32 = 0x1 << 3
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.physicsWorld.contactDelegate = self
        
        self.addBackgroundMusic()
        self.addBackgroundImage()
        
        self.setPhyscisGravity()
        self.createWorldBorder()
        self.createWorldBorder()
        self.setWorldFriction()
        
        self.createBallWithPhysics()
        self.createPaddle()
        self.createBricks()
        
        self.createBottomRect()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addBackgroundMusic() {
        
        let backgroundMusicPathString = bundle.path(forResource: "DX_ball_Background", ofType: "mp3")
        
        let backgroundMusicspathURL = URL(fileURLWithPath: backgroundMusicPathString!)
        print(backgroundMusicspathURL as Any)
        
        backgroundMusicPlayer = try! AVAudioPlayer(contentsOf: backgroundMusicspathURL)
        backgroundMusicPlayer.numberOfLoops = -1            //Forever Loop
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
    }
    
    
    func addBackgroundImage() {
        
        let backgroundImage = SKSpriteNode(imageNamed: "17345")
        backgroundImage.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        
        self.addChild(backgroundImage)
    }
    
    func setPhyscisGravity () {
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)      //Set Gravity = 0
    }
    
    func createWorldBorder () {
        
        let worldBorder = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = worldBorder
    }
    
    func setWorldFriction() {
        self.physicsBody?.friction = 0
    }
    
    func createBallWithPhysics () {
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.name = ballCategoryName
        ball.position = CGPoint(x: self.frame.size.width / 4, y: self.frame.size.height / 4)
        ball.size = CGSize(width: 20, height: 20)
        self.addChild(ball)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.width / 2)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.allowsRotation = false
        
        ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: -5))
        
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.contactTestBitMask = bottomCategory
    }
    
    func createPaddle(){
        
        let paddle = SKSpriteNode(imageNamed: "paddle")
        paddle.name = paddleCategoryName

        let middleX = self.frame.midX
        paddle.position = CGPoint(x: middleX, y: paddle.frame.size.height/6)
        paddle.size = CGSize(width: 100, height: 20)
        
        self.addChild(paddle)
        
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.frame.size)
        paddle.physicsBody?.friction = 0.4
        paddle.physicsBody?.restitution = 0.1
        paddle.physicsBody?.isDynamic = false
        
        paddle.physicsBody?.categoryBitMask = paddleCategory
    }
    
    func createBricks() {
        let numberOfRows = 6
        let numberOfBricks = 5
    }
    
    func createBottomRect() {
        let bottomRect = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        
        self.addChild(bottom)
        bottom.physicsBody?.categoryBitMask = bottomCategory
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        let body: SKPhysicsBody? = self.physicsWorld.body(at: touchLocation)
        
        if body?.node?.name == paddleCategoryName {
            print("Paddle Touched")
            paddleTouched = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if paddleTouched {
            let touch = touches.first
            let touchLoc = touch?.location(in: self)
            let previousTouchLoc = touch?.previousLocation(in: self)
            
            let paddle = self.childNode(withName: paddleCategoryName) as! SKSpriteNode
            
            var newXPosition = paddle.position.x + (touchLoc!.x - previousTouchLoc!.x)
            
            newXPosition = max(newXPosition, paddle.size.width/2)
            newXPosition = min(newXPosition, self.size.width - paddle.size.width/2)
            
            paddle.position = CGPoint(x: newXPosition, y: paddle.position.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        paddleTouched = false
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == bottomCategory {
            print("You Loose!")
        }
    }
}
