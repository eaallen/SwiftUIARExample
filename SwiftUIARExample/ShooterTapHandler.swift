//
//  ShooterTapHandler.swift
//  SwiftUIARExample
//
//  Created by Eli Allen on 2/2/22.
//

import Foundation
import RealityKit
import ARKit

class ShooterTapHandler : ARViewOnTapHandler {
    var isRecharging = false
    func success(results: [CollisionCastHit], rayResult: RayResult, tapLocation: CGPoint, arGameView: ARGameView ) {
        // we shot somthing
        //        if let ent = results.first?.entity{
        //            if(!isRecharging){
        //                isRecharging = true
        //                let config = ARWorldTrackingConfiguration()
        //                arGameView.session.run(config, options: .resetTracking)
        //                // create projectile
        //                let box = Laser()
        //                box.generateCollisionShapes(recursive: true)
        //                let anchor = AnchorEntity(world: rayResult.origin)
        //                anchor.addChild(box)
        //
        //                // add prjectile to scene
        //                arGameView.scene.addAnchor(anchor)
        //
        //                print(rayResult.direction)
        //                print(rayResult.origin)
        //                // fire!
        //                var t = Transform()
        //                t.translation = [rayResult.direction.x * 10,
        //                                 rayResult.direction.y * 10,
        //                                 rayResult.direction.z > 0
        //                                    ? rayResult.direction.z * -10
        //                                    : rayResult.direction.z * 10]
        //                box.move(to: t, relativeTo: AnchorEntity(.camera), duration: 2)
        //
        //                wait(1.5){
        //                    arGameView.scene.removeAnchor(anchor)
        //                    self.isRecharging = false
        //                    ent.removeFromParent()
        //                }
        //            }
        //
        //        }
        if let first = results.first?.entity{            
            let box = ModelEntity(
                mesh: MeshResource.generateSphere(radius: 0.05),
                materials: [SimpleMaterial(color: .white, isMetallic: false)]
            )
            box.generateCollisionShapes(recursive: true)
            
            let camera = AnchorEntity(.camera)
            camera.addChild(box)
            arGameView.scene.addAnchor(camera)
                        
            if let target = arGameView.scene.findEntity(named: "box"){
                box.move(to: target.transform, relativeTo: target, duration: 0.4)
            }
            
        }
    }
    
    func failure(rayResult: RayResult, tapLocation: CGPoint, arGameView: ARGameView ) {
        // we missed
        //        let box = Laser()
        //        box.generateCollisionShapes(recursive: true)
        //
        //        let cameraAnchor = AnchorEntity(.camera)
        //
        //        cameraAnchor.addChild(box)
        //        arGameView.scene.addAnchor(cameraAnchor)
        
        
        
        if let box = arGameView.scene.findEntity(named: "box")?.name {
            
        }
        
        
        //        var t = Transform()
        //        t.translation = [ 0,0, -2]
        //
        //        box.move(to: t, relativeTo: nil, duration: 2)
        
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
            mesh: .generateSphere(radius: 0.05),
            materials: [SimpleMaterial(
                color: .red,
                isMetallic: false)
                       ]
        )
    }
    
}
