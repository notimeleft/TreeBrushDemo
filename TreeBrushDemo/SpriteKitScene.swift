//
//  SpriteKitScene.swift
//  TreeBrushDemo
//
//  Created by Jerry Wang on 12/12/18.
//  Copyright © 2018 Jerry Wang. All rights reserved.
//

import SpriteKit
import GameplayKit

class SpriteKitScene: SKScene {
    
    private var rain: SKEmitterNode?
    
    override func didMove(to view: SKView) {
        
        if let particle = SKEmitterNode(fileNamed: "Rain.sks"){
            rain = particle
            particle.position = CGPoint(x: 0 , y: self.frame.height / 2.0)
            particle.name = "rainParticle"
            particle.targetNode = self.scene
            particle.particlePositionRange = CGVector(dx: self.frame.width, dy: self.frame.height)
            self.addChild(particle)
        }
        
        
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        //if rain node already has the gamescene as its parent, simply move it. else, add rain node to parent.
//        if (rain?.parent != nil) {
//            rain?.position = touches.first?.location(in: self) ?? self.frame.origin
//        } else {
//            self.addChild(rain!)
//        }
//        
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        rain?.position = touches.first?.location(in: self) ?? self.frame.origin
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        rain?.removeFromParent()
//    }
    
}
