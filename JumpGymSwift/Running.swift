//
//  Running.swift
//  JumpGymSwift
//
//  Created by Mmachi Obiorah on 3/4/16.
//  Copyright © 2016 Mmachi Obiorah. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class Running: GKState {
    
    let game: GameScene
    
    
    
    init(game: GameScene) {
        self.game = game

    }
    

    override func didEnterWithPreviousState(previousState: GKState?) {
        
        runningGator()
    }
    
    
    override func willExitWithNextState(nextState: GKState) {
//        guard let associatedNode = associatedNode else { return }
        
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        switch stateClass{
        case is Jumping.Type, is DeadGator.Type:
                return true
        default:
            return false
        }
    }
    
    func runningGator(){
        
        game.gator.removeFromParent()
        
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

        // control collision
        game.gator.runAction(runforever, withKey: "gatorRun")
        game.addChild(game.gator)
        
        
    }

}

