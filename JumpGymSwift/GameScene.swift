//
//  GameScene.swift
//  JumpGymSwift
//
//  Created by Mmachi Obiorah on 2/22/16.
//  Copyright (c) 2016 Mmachi Obiorah. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let gatorGroup: UInt32 = 0x1 << 0
    let obstacleGroup: UInt32 = 0x1 << 1
    let groundGroup: UInt32 = 0x1 << 2
    let openingGroup: UInt32 = 0x1 << 3
    let ceilingGroup: UInt32 = 0x1 << 4

    enum objectsZPositions: CGFloat{
        case background = 0
        case ground = 1
        case obstacles = 2
        case gator = 3
        case score = 4
        case gameOver = 5
    }
    
    var gator = SKSpriteNode()
    var ground = SKSpriteNode()
    var background = SKSpriteNode()
    var ceiling = SKSpriteNode()
    
    var movingGameObject = SKNode()
    
    var obstacleSpeed: NSTimeInterval = 7
    var obstacleSpawned: Int = 0
    
    var gameOver = false
    
    
    var scoreLabelNode = SKLabelNode()
    var score: Int = 0
    var lives: Int = 3
    
    var gameOverLabelNode = SKLabelNode()
    var gameOverStatusNode = SKLabelNode()
    var healthFactLabelNode = SKLabelNode()
    
    var liveNodes: [SKSpriteNode] = []
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0.0, -10.0)
        
        //Background
        createBackground()
        createGround()
        createCeiling()
        createGator()
        createLiveNodes()
        createScoreLabel()
        
        self.addChild(movingGameObject)
        
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "loadObstacles", userInfo: nil, repeats: true)
    
    }
    
    func createScoreLabel(){
        scoreLabelNode = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        scoreLabelNode.fontSize = 50
        scoreLabelNode.fontColor = SKColor.whiteColor()
        scoreLabelNode.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height - 50)
        scoreLabelNode.text = "0"
        scoreLabelNode.zPosition = objectsZPositions.score.rawValue
        self.addChild(scoreLabelNode)
        
    }
    
    func createGameOverLabel(){
        gameOverLabelNode = SKLabelNode(fontNamed: "Copperplate-Bold")
        gameOverLabelNode.fontSize = 50
        gameOverLabelNode.fontColor = SKColor.whiteColor()
        gameOverLabelNode.zPosition = objectsZPositions.gameOver.rawValue
        gameOverLabelNode.text = "Game Over"
        gameOverLabelNode.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(gameOverLabelNode)
        
    }
    
    func createRestartLabel(){
        let scaleUp = SKAction.scaleTo(1.5, duration: 2)
        let scale = SKAction.scaleTo(1, duration: 0.25)
        let scaleSequence = SKAction.sequence([scaleUp, scale])
        
        gameOverStatusNode = SKLabelNode(fontNamed: "Copperplate-Bold")
        gameOverStatusNode.fontSize = 50
        gameOverStatusNode.fontColor = SKColor.whiteColor()
        gameOverStatusNode.text = "Tap to restart"
        gameOverStatusNode.zPosition = objectsZPositions.gameOver.rawValue
        gameOverStatusNode.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) - gameOverStatusNode.frame.height - 20)
        self.addChild(gameOverStatusNode)
        let breathingText = SKAction.repeatActionForever(scaleSequence)
        
        gameOverStatusNode.runAction(breathingText)
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == openingGroup || contact.bodyB.categoryBitMask == openingGroup{
            score += 1
            scoreLabelNode.text = "\(score)"
        }else if contact.bodyA.categoryBitMask == obstacleGroup || contact.bodyB.categoryBitMask == obstacleGroup{
            if lives == 0{
                movingGameObject.speed = 0
                gameOver = true
                gator.removeActionForKey("gatorRun")
                gator.removeFromParent()
                createDeadGator(gator.position.x)
                
                createGameOverLabel()
                createRestartLabel()

                displayHealthFacts()
     
            }else{
                lives -= 1
                liveNodes[lives].removeFromParent()
            }
   
        }
    }
    
    func displayHealthFacts(){
        
        let healthFacts: [String] = [
            "Jumping helps improve your flexibility and posture",
            "Jumping helps increase your heart strength and efficiency",
            "Jumping helps improve your coordination and agility",
            "Jumping helps you build stronger bones",
            "Jumping helps improve your balance",
            "Jumping helps increase your attention span",
            "Jumping helps tone your muscles and improves your skin",
            "Jumping helps improve both upper and lower body strength"]
        
        let randomHealthFact = Int(arc4random_uniform(UInt32(healthFacts.count)))
        
        healthFactLabelNode = SKLabelNode(fontNamed: "Copperplate-Bold")
        healthFactLabelNode.fontSize = 25
        healthFactLabelNode.fontColor = SKColor.whiteColor()
        healthFactLabelNode.zPosition = objectsZPositions.gameOver.rawValue
        healthFactLabelNode.text = healthFacts[randomHealthFact]
        healthFactLabelNode.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) + 150)
        self.addChild(healthFactLabelNode)
    }
    
    func createDeadGator(x: CGFloat){
        let deadGatorTexture1 = SKTexture(imageNamed: "deadGator1")
        let deadGatorTexture2 = SKTexture(imageNamed: "deadGator2")
        let deadGatorTexture3 = SKTexture(imageNamed: "deadGator3")
        
        let runningAnimation = SKAction.animateWithTextures([deadGatorTexture1, deadGatorTexture2, deadGatorTexture3], timePerFrame: 0.1)
        let runforever = SKAction.repeatActionForever(runningAnimation)

        gator = SKSpriteNode(texture: deadGatorTexture1)
        gator.position = CGPoint(x: x, y: CGRectGetMaxY(ground.frame))
        gator.setScale(0.5)
        gator.zPosition = objectsZPositions.score.rawValue
        gator.runAction(runforever, withKey: "gatorRun")
        addChild(gator)

    }
    
    func createLiveNodes(){
        let liveNodesTexture = SKTexture(imageNamed: "heart1")

        for var i: Int = 0; i < 3; i++ {
            liveNodes.append(SKSpriteNode(texture: liveNodesTexture))
            liveNodes[i].position = CGPoint(x: CGRectGetMidX(self.frame) + CGFloat(i) * liveNodes[i].size.width, y: self.frame.height - 100)
            liveNodes[i].setScale(2)
            liveNodes[i].zPosition = objectsZPositions.score.rawValue
            self.addChild(liveNodes[i])

            
        }
    }
    
    func createGator(){
        
        let gatorTexture1 = SKTexture(imageNamed: "gator1")
        let gatorTexture2 = SKTexture(imageNamed: "gator2")
        let gatorTexture3 = SKTexture(imageNamed: "gator3")
        let gatorTexture4 = SKTexture(imageNamed: "gator4")
        let gatorTexture5 = SKTexture(imageNamed: "gator5")
        let gatorTexture6 = SKTexture(imageNamed: "gator6")
        let gatorTexture7 = SKTexture(imageNamed: "gator7")
        let gatorTexture8 = SKTexture(imageNamed: "gator8")
        
        let runningAnimation = SKAction.animateWithTextures([gatorTexture1, gatorTexture2, gatorTexture3, gatorTexture4, gatorTexture5, gatorTexture6, gatorTexture7, gatorTexture8], timePerFrame: 0.1)
        let runforever = SKAction.repeatActionForever(runningAnimation)
        
        gator = SKSpriteNode(texture: gatorTexture1)
        gator.position = CGPoint(x: self.frame.size.width * 0.35, y: CGRectGetMaxY(ground.frame))
        gator.setScale(0.5)
        gator.zPosition = objectsZPositions.gator.rawValue
        
        // control collision
        gator.runAction(runforever, withKey: "gatorRun")
        
        
        gator.physicsBody = SKPhysicsBody(circleOfRadius:gator.size.height/4)
        gator.physicsBody?.categoryBitMask = gatorGroup
        gator.physicsBody?.contactTestBitMask = obstacleGroup | openingGroup | groundGroup | ceilingGroup
        gator.physicsBody?.collisionBitMask =  groundGroup | ceilingGroup

        
        // do you want it to move
        gator.physicsBody?.dynamic = true
        gator.physicsBody?.allowsRotation = false
        
        self.addChild(gator)
    
    }
    

    
    func loadObstacles(){
        obstacleSpawned += 1
        if obstacleSpawned % 10 == 0{
            obstacleSpeed -= 0.5
        }
        let obstacleTexture = SKTexture(imageNamed: "obstacle1")
        
        let obstacleTexture1 = SKTexture(imageNamed: "obstacle2")

        let obstacleTexture2 = SKTexture(imageNamed: "obstacle3")
        
        
       //randomly select one of the obstacle textures
        let randomY: Int = Int(arc4random_uniform(3))
        
        let allObstacles: [SKTexture] = [obstacleTexture, obstacleTexture1, obstacleTexture2]
      
        let obstacle = SKSpriteNode(texture: allObstacles[randomY])
        
        
        obstacle.position = CGPoint(x: self.frame.width + obstacle.size.width, y: ground.size.height)
        obstacle.physicsBody =  SKPhysicsBody(rectangleOfSize: obstacle.size)
        obstacle.physicsBody?.dynamic = false
        obstacle.physicsBody?.allowsRotation = false
        obstacle.physicsBody?.categoryBitMask = obstacleGroup
        obstacle.physicsBody?.contactTestBitMask = gatorGroup
        //obstacle.physicsBody?.collisionBitMask = gatorGroup
        
        obstacle.zPosition = objectsZPositions.obstacles.rawValue
        movingGameObject.addChild(obstacle)
        
        let moveObstacle = SKAction.moveToX(-obstacle.size.width, duration: obstacleSpeed)
        let removeObstacle = SKAction.removeFromParent()
        obstacle.runAction(SKAction.sequence([moveObstacle, removeObstacle]))
        
        let passage = SKNode()
        passage.position = CGPoint(x: obstacle.position.x + obstacle.size.width * 0.75, y: CGRectGetMidY(self.frame))
        passage.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(1, self.frame.height))
        passage.physicsBody?.dynamic = false
        passage.physicsBody?.categoryBitMask = openingGroup
        passage.physicsBody?.contactTestBitMask = gatorGroup
        passage.runAction(SKAction.sequence([moveObstacle, removeObstacle]))
        movingGameObject.addChild(passage)
        
        
        }
    
    func createBackground(){
        let BKTexture = SKTexture(imageNamed: "background")
        BKTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        background = SKSpriteNode(texture: BKTexture)
        background.position = CGPoint(x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.5)
        let moveBackground  = SKAction.moveByX(-background.size.width,y: 0, duration: 12)
        let replaceBackground = SKAction.moveByX( background.size.width,y: 0, duration: 0)
        let BackgroundSequence = SKAction.sequence([moveBackground, replaceBackground])
        let moveBackgroundForever = SKAction.repeatActionForever(BackgroundSequence)
        
        for var i: CGFloat = 0; i < 3; i++ {
            self.background = SKSpriteNode(texture: BKTexture)
            background.position = CGPoint(x: background.size.width * 0.5 + i * background.size.width, y: CGRectGetMidY(self.frame))
            background.size.height = self.frame.height
            background.zPosition = objectsZPositions.background.rawValue
            background.runAction(moveBackgroundForever)
            movingGameObject.addChild(background)
            
        }
    
    }
    
    func createGround(){
        let GroundTexture = SKTexture(imageNamed: "Ground")
        ground = SKSpriteNode(texture: GroundTexture)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(ground.size.width, ground.size.height))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.allowsRotation = false
        ground.position = CGPoint(x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.05)
        ground.zPosition = objectsZPositions.ground.rawValue
        ground.physicsBody?.categoryBitMask = groundGroup
        //ground.physicsBody?.collisionBitMask = gatorGroup
        ground.physicsBody?.contactTestBitMask = gatorGroup
        
        
        
        let moveground  = SKAction.moveByX(-ground.size.width,y: 0, duration: 12)
        let replaceground = SKAction.moveByX( ground.size.width,y: 0, duration: 0)
        let groundSequence = SKAction.sequence([moveground, replaceground])
        let movegroundForever = SKAction.repeatActionForever(groundSequence)
        
        for var i: CGFloat = 0; i < 4; i++ {
            self.ground = SKSpriteNode(texture: GroundTexture)
            ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(ground.size.width, ground.size.height))
            ground.physicsBody?.dynamic = false
            ground.physicsBody?.allowsRotation = false
            ground.zPosition = objectsZPositions.ground.rawValue
            ground.physicsBody?.categoryBitMask = groundGroup
            //ground.physicsBody?.collisionBitMask = gatorGroup
            ground.physicsBody?.contactTestBitMask = gatorGroup

            ground.position = CGPoint(x: ground.size.width * 0.5 + i * ground.size.width, y: CGRectGetMinY(self.frame))
            ground.size.height = self.frame.height/5
            ground.zPosition = objectsZPositions.ground.rawValue
            ground.runAction(movegroundForever)
            movingGameObject.addChild(ground)
            
        }
        
    }
    
    
    func createCeiling(){
        ceiling.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(ground.size.width, 1))
        ceiling.physicsBody?.dynamic = false
        ceiling.physicsBody?.allowsRotation = false
        ceiling.position = CGPoint(x: self.frame.size.width * 0.5, y: self.frame.size.height)
        ceiling.zPosition = objectsZPositions.ground.rawValue
        ceiling.physicsBody?.categoryBitMask = ceilingGroup
        //ceiling.physicsBody?.collisionBitMask = gatorGroup
        ceiling.physicsBody?.contactTestBitMask = gatorGroup
        self.addChild(ceiling)
        
    }

    
    

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        if gameOver == false{
    
            // control collision
            gator.physicsBody?.velocity = CGVectorMake(0, 0)
            gator.physicsBody?.applyImpulse(CGVectorMake(0, 60))


        }else {
            /*initialize the scene again*/
            if let scene = GameScene(fileNamed:"GameScene") {
                // Configure the view.
                let skView = self.view as SKView! //we unwrapped it! what!
                skView.showsFPS = false
                skView.showsNodeCount = false
                //skView.showsPhysics = true
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .AspectFit
                
                skView.presentScene(scene)
            }
            
        }
        

    }
   
    
    override func update(currentTime: CFTimeInterval) {
            }
    


}
