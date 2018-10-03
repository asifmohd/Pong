//
//  GameScene.swift
//  Asif Pong
//
//  Created by Mohd Asif on 24/08/14.
//  Copyright (c) 2014 Asif. All rights reserved.
//

import SpriteKit
import CoreGraphics

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player2Height = 160
    let player2Width = 20
    let SCORE_REQUIRED_TO_WIN = "6"
    
    var finished = true
    override func didMove(to view: SKView) {
        
        let player1Label = SKLabelNode(fontNamed: "Helvetica Bold")
        player1Label.text = "0"
        player1Label.fontSize = 65
        player1Label.name = "Player1 Score"
        player1Label.position = CGPoint(x: self.frame.midX - 100, y: self.frame.size.height - 60)
        self.addChild(player1Label)
        
        let player2Label = SKLabelNode(fontNamed: "Helvetica Bold")
        player2Label.text = "0"
        player2Label.fontSize = 65
        player2Label.name = "Player2 Score"
        player2Label.position = CGPoint(x: self.frame.midX + 100, y: self.frame.size.height - 60)
        self.addChild(player2Label)
        
        
        // Tap anywhere to start label
        let startLabel = SKLabelNode(fontNamed: "Helvetica Bold")
        startLabel.text = "Tap anywhere to start game"
        startLabel.fontSize = 60
        startLabel.name = "startLabel"
        startLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(startLabel)
        
        // creates a dashed pattern
        let myShapeNode = SKShapeNode()
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: self.frame.midX, y: 0))
        bezierPath.addLine(to: CGPoint(x: self.frame.midX, y: self.frame.size.height))
        let pattern = [CGFloat(10.0), CGFloat(10.0)];
        let dashed = bezierPath.cgPath.copy(dashingWithPhase: 0, lengths: pattern)

        myShapeNode.path = dashed
        self.addChild(myShapeNode)
        
        let edgeRect = CGRect(x: self.frame.origin.x - 150, y: self.frame.origin.y, width: self.frame.size.width + 300, height: self.frame.size.height)
        
        let physicsBodyEdge1 = SKPhysicsBody(edgeLoopFrom: edgeRect)
        self.physicsBody = physicsBodyEdge1
        self.physicsBody!.mass = 0.0
        self.physicsBody!.friction = 1.0
        self.physicsBody!.restitution = 1.0
        self.physicsBody!.contactTestBitMask = 0x00000004
        self.physicsWorld.contactDelegate = self
        
        let line1 = SKSpriteNode()
        line1.color = UIColor.blue
        line1.size = CGSize(width: 20, height: 160)
        line1.name = "Player1"
        line1.position = CGPoint(x:(self.frame.origin.x + 20), y:self.frame.midY);
        line1.physicsBody = SKPhysicsBody(rectangleOf: line1.size)
        line1.physicsBody!.isDynamic = false
        line1.physicsBody!.affectedByGravity = false
        line1.physicsBody!.mass = 0.0
        line1.physicsBody!.friction = 0.0
        line1.physicsBody!.restitution = 1.0
        line1.physicsBody!.contactTestBitMask = 0x00000001
        
        self.addChild(line1)
        
        let line2 = SKSpriteNode()
        line2.color = UIColor.red
        line2.size = CGSize(width: 20, height: 160)
        line2.name = "Player2"
        line2.position = CGPoint(x:(self.frame.size.width - CGFloat(player2Width)), y: self.frame.midY);
        line2.physicsBody = SKPhysicsBody(rectangleOf: line1.size)
        line2.physicsBody!.isDynamic = false
        line2.physicsBody!.affectedByGravity = false
        line2.physicsBody!.restitution = 1.0
        line2.physicsBody!.friction = 0.0
        line2.physicsBody!.mass = 0.0
        line2.physicsBody!.contactTestBitMask = 0x00000001
        
        self.addChild(line2)
        
//        self.addChild(createBall(false))
        

    }
    
    func didEndContact(contact: SKPhysicsContact) {
        if (contact.bodyA.contactTestBitMask == 0x00000001 && contact.bodyB.contactTestBitMask == 0x00000001) {
            self.run(SKAction.playSoundFileNamed("pongHit.mp3", waitForCompletion: false))
        }
    }
    
    override func didEvaluateActions() {
        let player1Score = self.childNode(withName: "Player1 Score") as! SKLabelNode
        let player2Score = self.childNode(withName: "Player2 Score") as! SKLabelNode
        if (!self.finished) {
            let ball = self.childNode(withName: "Pong Ball")
            if ball != nil {
                let ballOutFromLeft = ball!.position.x < (self.frame.origin.x - 60)
                let ballOutFromRight = ball!.position.x > (self.frame.size.width + 60)
                if (ballOutFromRight) {
                    ball!.removeFromParent()
                    
                    player1Score.text = "\(Int(player1Score.text!)! + 1)"
                    if (player1Score.text != SCORE_REQUIRED_TO_WIN) {
                        self.addChild(self.createBall(OutFromLeft: false))
                    }
                }
                if (ballOutFromLeft) {
                    ball!.removeFromParent()
                    
                    player2Score.text = "\(Int(player2Score.text!)! + 1)"
                    if (player2Score.text != SCORE_REQUIRED_TO_WIN) {
                        self.addChild(self.createBall(OutFromLeft: true))
                    }
                }
            }
            else {
                if (player1Score.text == "0" && player2Score.text == "0") {
                    self.addChild(self.createBall(OutFromLeft: false))
                    return
                }
            }
        

            let player1Score = self.childNode(withName: "Player1 Score") as! SKLabelNode
            if player1Score.text == SCORE_REQUIRED_TO_WIN {
                let player1WinsLabel = SKLabelNode(fontNamed: "Helvetica Nue")
                player1WinsLabel.text = "Player1 Wins"
                player1WinsLabel.name = "Player1 Wins"
                player1WinsLabel.fontSize = 70
                player1WinsLabel.position = CGPoint(x: self.frame.origin.x + 300, y: self.frame.size.height/2 - 100)
                self.addChild(player1WinsLabel)
                self.finished = true
                
                // Tap anywhere to start label
                let startLabel = SKLabelNode(fontNamed: "Helvetica Bold")
                startLabel.text = "Tap anywhere to start game"
                startLabel.fontSize = 60
                startLabel.name = "startLabel"
                startLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                self.addChild(startLabel)
            }
            let player2Score = self.childNode(withName: "Player2 Score") as! SKLabelNode
            if player2Score.text == SCORE_REQUIRED_TO_WIN {
                let player2WinsLabel = SKLabelNode(fontNamed: "Helvetica Nue")
                player2WinsLabel.text = "Player2 Wins"
                player2WinsLabel.fontSize = 70
                player2WinsLabel.name = "Player2 Wins"
                player2WinsLabel.position = CGPoint(x: self.frame.size.width - 300, y: self.frame.size.height/2 - 100)
                self.addChild(player2WinsLabel)
                self.finished = true
                
                // Tap anywhere to start label
                let startLabel = SKLabelNode(fontNamed: "Helvetica Bold")
                startLabel.text = "Tap anywhere to start game"
                startLabel.fontSize = 60
                startLabel.name = "startLabel"
                startLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                self.addChild(startLabel)
            }
        }
    }
    
    func createBall(OutFromLeft: Bool) -> SKNode {
        let nsingh = SKSpriteNode(imageNamed: "circle")
        nsingh.physicsBody = SKPhysicsBody(circleOfRadius: nsingh.size.width/2)
        nsingh.physicsBody!.isDynamic = true
        nsingh.physicsBody!.affectedByGravity = false
        nsingh.physicsBody!.mass = 0.02
        nsingh.physicsBody!.friction = 0.0
        nsingh.physicsBody!.restitution = 1.0
        nsingh.physicsBody!.allowsRotation = true
        nsingh.physicsBody!.contactTestBitMask = 0x00000001
        nsingh.physicsBody!.linearDamping = 0.0
        nsingh.name = "Pong Ball"
        
        nsingh.xScale = 0.5
        nsingh.yScale = 0.5
        nsingh.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        var dx = 0
        if (OutFromLeft) {
            dx = Int(arc4random_uniform(5)) + 750
        }
        else {
            dx = Int(arc4random_uniform(5)) - 750
        }
        let dy = Int(arc4random_uniform(1000)) - 500
        nsingh.physicsBody!.velocity = CGVector(dx: dx, dy: dy)
        
        let rotationAction = SKAction.rotate(byAngle: CGFloat(Double.pi), duration:1)
        nsingh.run(SKAction.repeatForever(rotationAction))
        
        return nsingh
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: UITouch in touches {
            let location = touch.location(in: self)
            if (location.x > self.frame.midX) {
                let player2 = self.childNode(withName: "Player2")
                if ((location.y < self.frame.height - CGFloat(player2Height/2)) && (location.y > self.frame.origin.y + CGFloat(player2Height/2))) {
                    let moveAction = SKAction.move(to: CGPoint(x: player2!.position.x, y: location.y), duration: 0)
                    player2?.run(moveAction)
                }
            }
            else {
                let player1 = self.childNode(withName: "Player1")
                if ((location.y < self.frame.height - CGFloat(player2Height/2)) && (location.y > self.frame.origin.y + CGFloat(player2Height/2))) {
                    let moveAction = SKAction.move(to: CGPoint(x: player1!.position.x, y: location.y), duration: 0)
                    player1?.run(moveAction)
                }
            }
        }
    
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.finished) {
            self.finished = false
            let player1 = self.childNode(withName: "Player1 Score") as! SKLabelNode
            let player2 = self.childNode(withName: "Player2 Score") as! SKLabelNode
            if player1.text == SCORE_REQUIRED_TO_WIN {
                self.childNode(withName: "Player1 Wins")?.removeFromParent()
            }
            else {
                let label = self.childNode(withName: "Player2 Wins") as? SKLabelNode
                if label != nil {
                    label!.removeFromParent()
                }
            }
            let startLabel = self.childNode(withName: "startLabel") as! SKLabelNode?
            if startLabel != nil {
                startLabel!.removeFromParent()
            }
            player1.text = "0"
            player2.text = "0"
        }
    }
   
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
