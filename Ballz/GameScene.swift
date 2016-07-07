//
//  GameScene.swift
//  Ballz
//
//  Created by Alan Gao on 7/5/16.
//  Copyright (c) 2016 Alan Gao. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var funnel: SKShapeNode! = nil
    var windmill: SKSpriteNode!
    /* Used to create other Ball objects by the .copy() method */
    var genericBall: Ball!
    /* Stores all balls in the gamescene */
    var ballArray: [Ball] = []
    
    /* How fast the mill rotates */
    let MILL_ROTATION = CGFloat(0.02)
    /* The position of the bottom most ball on the funnel */
    let LAST_BALL_POSITION = CGPoint(x: 187.5, y: 550.5)
    /* The distance the next ball will spawn above the one below it*/
    let BALL_INCREMENT = CGPoint(x: 0, y: 35)
    
    
    var i = 1
    
    override func didMoveToView(view: SKView) {
        /* Set physics world delegate */
        physicsWorld.contactDelegate = self

        addFunnel()
        initializeVars()
        ballArray.append(genericBall)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -7.5)
        addRandomBalls(4)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let droppedBall = ballArray[0]
        
        /* To drop the ball from funnel, we change the ball's collision bit mask */
        droppedBall.physicsBody?.collisionBitMask = PhysicsCategory.Windmill | PhysicsCategory.Ball
        /* Now that the ball has dropped, we care about what the ball contacts */
        droppedBall.physicsBody?.contactTestBitMask = PhysicsCategory.Windmill | PhysicsCategory.Ball
        
        ballArray.removeAtIndex(0)
        addRandomBalls(1)
    }
   
    override func update(currentTime: CFTimeInterval) {
        windmill.zRotation += MILL_ROTATION
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let ballA = contact.bodyA.node as? Ball
        let ballB = contact.bodyB.node as? Ball
        var fallingBall: Ball!
        
        if(ballA != nil && ballA?.isConnected == false) {
            fallingBall = ballA
        }
        else {
            fallingBall = ballB
        }
        
        let ANCHOR_POINT = contact.contactPoint
        let joint = SKPhysicsJointFixed.jointWithBodyA(fallingBall!.physicsBody!, bodyB: windmill.physicsBody!, anchor: ANCHOR_POINT)
        self.physicsWorld.addJoint(joint)
        fallingBall.isConnected = true
        /* Must remove collision properties or ball may continue to make an obscene number of joints */
        fallingBall.removeCollisions()
    }
    
    func addRandomBalls(nTimes: Int) {
        for _ in 0 ..< nTimes {
            let newBall = ballArray.last!.copy() as! Ball
            
            newBall.position.y += BALL_INCREMENT.y
            newBall.texture = SKTexture(imageNamed: newBall.randomizeColor().rawValue)
            
            let physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(19))
            newBall.physicsBody = physicsBody
            
            self.addChild(newBall)
            ballArray.append(newBall)
        }
    }
    
    func initializeVars() {
        windmill = self.childNodeWithName("windmill") as! SKSpriteNode
        genericBall = self.childNodeWithName("genericBall") as! Ball
        
        /* Physics contact is two ways - i.e. ball hits windmill and windmill hits ball
           We only need to consider whether the ball hit the windmill and not the other way around 
           Therefore, the windmill's collision and contact mask are both 0 (None) */
        windmill.physicsBody?.categoryBitMask = PhysicsCategory.Windmill
        windmill.physicsBody?.collisionBitMask = PhysicsCategory.None
        windmill.physicsBody?.contactTestBitMask = PhysicsCategory.None
        
        genericBall.physicsBody?.categoryBitMask = PhysicsCategory.Ball
        genericBall.physicsBody?.collisionBitMask = PhysicsCategory.Ball | PhysicsCategory.Funnel
        genericBall.physicsBody?.contactTestBitMask = PhysicsCategory.None
        
        funnel.physicsBody?.categoryBitMask = PhysicsCategory.Funnel
        funnel.physicsBody?.collisionBitMask = PhysicsCategory.Ball
        funnel.physicsBody?.contactTestBitMask = PhysicsCategory.None
    }
    
    func addFunnel() {
        let path = UIBezierPath()
        let startPoint = CGPoint(x: -200, y: 330)
        path.moveToPoint(startPoint)
        path.addLineToPoint(CGPoint(x: -20, y: 45))
        path.addLineToPoint(CGPoint(x: 0, y: -55))
        path.addLineToPoint(CGPoint(x: 40, y: -55))
        path.addLineToPoint(CGPoint(x: 60, y: 45))
        path.addLineToPoint(CGPoint(x: 240, y: 330))
        
        funnel = SKShapeNode(path: path.CGPath)
        funnel.position = CGPoint(x: self.frame.width/2 - 18, y: 587)
        funnel.physicsBody = SKPhysicsBody(edgeChainFromPath: path.CGPath)
        funnel.strokeColor = UIColor.darkGrayColor()
        funnel.lineWidth = 4
        self.addChild(funnel)
    }
}