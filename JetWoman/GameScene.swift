   //
   //  GameScene.swift
   //  JetWoman
   //
   //  Created by Guilherme B V Bahia on 16/06/17.
   //  Copyright © 2017 Planet Bang. All rights reserved.
   //
   
   import SpriteKit
   import GameplayKit
   
   class GameScene: SKScene, SKPhysicsContactDelegate {
      
      private let characteres = ["0":29,"1":18,"2":19,"3":20,"4":21,"5":23,"6":22,"7":26,"8":28,"9":25,"A":0,"B":11,"C":8,"D":2,"E":14,"F":3,"G":5]
      
      private let gravity = -0.25
      private let increase : CGFloat = 0.05
      
      private var currentCharacter : String?
      private var currentKey : Int?
      
      private var scoreLabel : SKLabelNode?
      private var highLabel : SKLabelNode?
      private var letterLabel : SKLabelNode?
      private var jatWoman : SKSpriteNode?
      private var startButton : SKSpriteNode?
      private var fireSpark : SKNode?
      
      private var score = 0;
      
      override func didMove(to view: SKView) {
         self.physicsWorld.contactDelegate = self
        
         // Get label node from scene and store it for use later
         self.scoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode
         self.scoreLabel?.text = "Score: \(score)"
         self.jatWoman = self.childNode(withName: "jatWoman") as? SKSpriteNode
         self.startButton = self.childNode(withName: "button") as? SKSpriteNode
         self.highLabel = self.childNode(withName: "highLabel") as? SKLabelNode
         self.letterLabel = self.childNode(withName: "letterLabel") as? SKLabelNode
         letterLabel?.alpha = 0.0;
         fillHighScore()
         self.fireSpark = self.childNode(withName: "fireSpark") as? SKNode
         
      }
      
      func jatImpulse() {
         if let jat = self.jatWoman {
            jat.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 200));
            score += 1
         }
         self.scoreLabel?.text = "Score: \(score)"
         let yGravity = self.physicsWorld.gravity.dy
         self.physicsWorld.gravity = CGVector(dx: 0.0, dy: yGravity - increase)
      }
      
      
      override func mouseDown(with event: NSEvent) {
         let point = event.location(in: self)
         let nodesPoint = nodes(at: point)
         for node in nodesPoint {
            if node.name == "button" {
               if let jat = self.jatWoman {
                  jat.position = CGPoint(x: 0.0, y: 80.0)
                  jat.physicsBody?.pinned = false
                  node.removeFromParent()
                  self.physicsWorld.gravity = CGVector(dx: 0.0, dy: gravity)
                  self.score = 0
                  self.scoreLabel?.text = "Score: \(score)"
                  letterLabel?.alpha = 1.0;
                  chooseNextKey()
                  fillHighScore()
                  jat.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100));
               }
            }
         }
      }
      
      override func keyDown(with event: NSEvent) {
         if let keyCode = currentKey {
            switch event.keyCode {
            case UInt16(keyCode):
               jatImpulse()
               chooseNextKey()
            default:
               print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
            }
         }
      }
      
      func chooseNextKey() {
         let count = UInt32(characteres.count)
         let inx = Int(arc4random_uniform(count))
         currentCharacter = ([String] (characteres.keys))[inx]
         currentKey = ([Int] (characteres.values))[inx]
         letterLabel?.text = currentCharacter
      }
      
      func didBegin(_ contact: SKPhysicsContact) {
         if contact.bodyA.collisionBitMask == contact.bodyB.collisionBitMask {
            print("Ran into spikes")
            if let startBt = self.startButton {
               if startBt.parent != self {
                  addChild(startBt)
                  currentCharacter = nil
                  currentKey = nil
                  letterLabel?.alpha = 0.0;
                  saveHighScore()
                  fillHighScore()
               }
            }
         }
      }
      
      func saveHighScore() {
         let highScore = UserDefaults.standard.integer(forKey: "highscore")
         if score > highScore {
            UserDefaults.standard.set(score, forKey: "highscore")
         }
      }
      
      func fillHighScore() {
         let highScore = UserDefaults.standard.integer(forKey: "highscore")
         highLabel?.text = "High: \(highScore)"
      }
      
      override func update(_ currentTime: TimeInterval) {
         // Called before each frame is rendered
      }
   }
