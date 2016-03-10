//
//  DeadGator.swift
//  JumpGymSwift
//
//  Created by Mmachi Obiorah on 3/7/16.
//  Copyright © 2016 Mmachi Obiorah. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class DeadGator: GKState {
    let game: GameScene
    
    
    
    init(game: GameScene) {
        self.game = game
        
    }
    
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        
        deadGator()
    }
    
    
    override func willExitWithNextState(nextState: GKState) {
        //        guard let associatedNode = associatedNode else { return }
        
    }
    
    
    func deadGator(){
        
        let x = game.gator.position.x
        game.gator.removeActionForKey("gatorRun")
        game.gator.removeFromParent()
        
        let deadGatorTexture1 = SKTexture(imageNamed: "deadGator1")
        let deadGatorTexture2 = SKTexture(imageNamed: "deadGator2")
        let deadGatorTexture3 = SKTexture(imageNamed: "deadGator3")
        
        let runningAnimation = SKAction.animateWithTextures([deadGatorTexture1, deadGatorTexture2, deadGatorTexture3], timePerFrame: 0.1)
        let runforever = SKAction.repeatActionForever(runningAnimation)
        
        game.gator = SKSpriteNode(texture: deadGatorTexture1)
        game.gator.position = CGPoint(x: x, y: CGRectGetMaxY(game.ground.frame))
        game.gator.setScale(0.5)
        game.gator.zPosition = 5
        game.gator.runAction(runforever, withKey: "gatorRun")
        game.addChild(game.gator)
        
    }}
