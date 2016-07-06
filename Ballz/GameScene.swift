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
    var firstBall: Ball!
    var MILL_ROTATION = CGFloat(0.02)
    var ballArray: [Ball] = []
    var LAST_BALL_POSITION: CGPoint!

    
    override func didMoveToView(view: SKView) {
        initializeVars()
        ballArray.append(firstBall)
        LAST_BALL_POSITION = ballArray.last?.position
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let droppedBall = ballArray[0]
        droppedBall.initializePhysicsBody()
        addRandomBalls(1)
    }
   
    override func update(currentTime: CFTimeInterval) {
        windmill.zRotation += MILL_ROTATION
    }
    
    func addRandomBalls(nTimes: Int) {
        for _ in 0 ..< nTimes {
            let newBall = firstBall.copy() as! Ball
            newBall.position = LAST_BALL_POSITION
            newBall.texture = SKTexture(imageNamed: newBall.randomizeColor().rawValue)
            newBall.physicsBody = nil
            self.addChild(newBall)
            
            ballArray.removeAtIndex(0)
            ballArray.append(newBall)
        }
    }
    
    func initializeVars() {
        windmill = self.childNodeWithName("windmill") as! SKSpriteNode
        firstBall = self.childNodeWithName("firstBall") as! Ball
    }
}
