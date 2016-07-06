//
//  GameScene.swift
//  Ballz
//
//  Created by Alan Gao on 7/5/16.
//  Copyright (c) 2016 Alan Gao. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
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
    
    override func didMoveToView(view: SKView) {
        initializeVars()
        ballArray.append(genericBall)
        addRandomBalls(3)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let droppedBall = ballArray[0]
        droppedBall.initializePhysicsBody()
        ballArray.removeAtIndex(0)
        moveBallsDown()
        addRandomBalls(1)
    }
   
    override func update(currentTime: CFTimeInterval) {
        windmill.zRotation += MILL_ROTATION
    }
    
    func moveBallsDown() {
        for ball in ballArray {
            ball.position.y -= BALL_INCREMENT.y
        }
    }
    
    func addRandomBalls(nTimes: Int) {
        for _ in 0 ..< nTimes {
            let newBall = ballArray.last!.copy() as! Ball
            
            newBall.position.y += BALL_INCREMENT.y
            newBall.texture = SKTexture(imageNamed: newBall.randomizeColor().rawValue)
            newBall.physicsBody?.affectedByGravity = false
            newBall.physicsBody?.dynamic = false
            
            self.addChild(newBall)
            ballArray.append(newBall)
        }
    }
    
    func initializeVars() {
        windmill = self.childNodeWithName("windmill") as! SKSpriteNode
        genericBall = self.childNodeWithName("genericBall") as! Ball
    }
}
