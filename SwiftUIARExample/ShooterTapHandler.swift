//
//  ShooterTapHandler.swift
//  SwiftUIARExample
//
//  Created by Eli Allen on 2/2/22.
//

import Foundation
import RealityKit
import ARKit

class ShooterTapHandler : ARViewOnTapHandler{
    var isRecharging = false
    func success(results: [CollisionCastHit], rayResult: RayResult, tapLocation: CGPoint, arGameView: ARGameView ) {
        // we shot somthing
    }
    
    func failure(rayResult: RayResult, tapLocation: CGPoint, arGameView: ARGameView ) {
        // we missed
        if(!isRecharging){
            isRecharging = true
            let config = ARWorldTrackingConfiguration()
            arGameView.session.run(config, options: .resetTracking)
            // create projectile
            let box = Laser()
            let anchor = AnchorEntity(world: rayResult.origin)
            anchor.addChild(box)
            
            // add prjectile to scene
            arGameView.scene.addAnchor(anchor)
            
            print(rayResult.direction)
            print(rayResult.origin)
            // fire!
            var t = Transform()
            t.translation = [rayResult.direction.x * 10,
                             rayResult.direction.y * 10,
                             rayResult.direction.z > 0
                                ? rayResult.direction.z * -10
                                : rayResult.direction.z * 10]
            box.move(to: t, relativeTo: AnchorEntity(.camera), duration: 2)
            
            wait(1.5){
                arGameView.scene.removeAnchor(anchor)
                self.isRecharging = false
            }
        }
        
    }
    
    func wait(_ duration: TimeInterval, callback: @escaping ()->Void){
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            callback()
        }
    }
}

class Laser: Entity, HasModel, HasAnchoring, HasCollision {

    required init() {
        super.init()
        self.components[ModelComponent.self] = ModelComponent(
            mesh: MeshResource.generateBox(size: [0.05,0.05,0.1]),
            materials: [SimpleMaterial(
                color: .red,
                isMetallic: false)
            ]
        )
    }
    
}
