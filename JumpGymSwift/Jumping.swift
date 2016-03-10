//
//  Jumping.swift
//  JumpGymSwift
//
//  Created by Mmachi Obiorah on 3/6/16.
//  Copyright © 2016 Mmachi Obiorah. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Jumping: GKState {
    
    let game: GameScene
    
    
    init(game: GameScene) {
        self.game = game
    }
    
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        
        jumpingGator()
    }
    
    
    override func willExitWithNextState(nextState: GKState) {
        //        guard let associatedNode = associatedNode else { return }
        
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        switch stateClass{
        case is Falling.Type, is DeadGator.Type:
            return true
        default:
            return false
        }
    }
    
    func jumpingGator(){
        
        game.gator.removeFromParent()
        
        let gatorTexture1 = SKTexture(imageNamed: "jump5")
        let jumpGator = SKAction.setTexture(gatorTexture1)
        
        let jumpG = SKAction.repeatAction(jumpGator, count: 1)
        
        // control collision
        game.gator.runAction(jumpG, withKey: "gatorRun")
        game.addChild(game.gator)
        
    }
}

