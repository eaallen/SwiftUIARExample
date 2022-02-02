//
//  cameraShoot.swift
//  SwiftUIARExample
//
//  Created by Eli Allen on 2/2/22.
//


import RealityKit
import ARKit

struct CameraShoot : ARViewOnTapHandler{
    func success(results: [CollisionCastHit], rayResult: RayResult, tapLocation: CGPoint, arGameView: ARGameView ) {
       if let ent = results.first?.entity{
            ent.removeFromParent()
        }
    }
    
    func failure(rayResult: RayResult, tapLocation: CGPoint, arGameView: ARGameView ) {
        guard let raycastQuery = arGameView.makeRaycastQuery(from: tapLocation,
                                                       allowing: .existingPlaneInfinite,
                                                             alignment: .any) else {
                                                        
                                                        print("failed first")
                                                        return
        }
        
        guard let result = arGameView.session.raycast(raycastQuery).first else {
            print("failed")
            return
        }
        
        let transformation = Transform(matrix: result.worldTransform) // puts it where you tapped (calcs the z)
//        let transformation = Transform(matrix: simd_float4x4( // puts it in the same place in the scene
//            SIMD4<Float>(1, 0, 0, 0),
//            SIMD4<Float>(0, 1, 0, 0),
//            SIMD4<Float>(0, 0, 1, 0),
//            SIMD4<Float>(0, 0, 0, 1)
//        ))
        let box = Laser()
        box.generateCollisionShapes(recursive: true)
        
        box.transform = transformation
        
        let raycastAnchor = AnchorEntity(raycastResult: result)
        raycastAnchor.addChild(box)
        arGameView.scene.addAnchor(raycastAnchor)
        
//        var t = box.transform
//        t.translation = [0,0,-10]
//
//        box.move(to: t, relativeTo: box, duration: 2)
        
//        wait(1.5){
//            arGameView.scene.removeAnchor(raycastAnchor)
//        }
    }
    
    func wait(_ duration: TimeInterval, callback: @escaping ()->Void){
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            callback()
        }
    }
}
