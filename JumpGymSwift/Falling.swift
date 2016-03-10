//
//  Falling.swift
//  JumpGymSwift
//
//  Created by Mmachi Obiorah on 3/7/16.
//  Copyright © 2016 Mmachi Obiorah. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Falling: GKState {
    
    let game: GameScene
    
    
    init(game: GameScene) {
        self.game = game
    }
    
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        
        fallingGator()
    }
    
    
    override func willExitWithNextState(nextState: GKState) {
        //        guard let associatedNode = associatedNode else { return }
        
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        switch stateClass{
        case is Running.Type, is DeadGator.Type:
            return true
        default:
            return false
        }

    }
    
    func fallingGator(){
        
        game.gator.removeFromParent()
        
        let gatorTexture1 = SKTexture(imageNamed: "jump6")
        let fallGator = SKAction.setTexture(gatorTexture1)
        
        let fallG = SKAction.repeatAction(fallGator, count: 1)
        
        // control collision
        game.gator.runAction(fallG, withKey: "gatorRun")
        game.addChild(game.gator)

    
    }
}