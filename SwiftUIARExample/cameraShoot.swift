//
//  cameraShoot.swift
//  SwiftUIARExample
//
//  Created by Eli Allen on 2/2/22.
//


import RealityKit
import ARKit

class CameraShoot : ARViewOnTapHandler{
    func success(results: [CollisionCastHit], rayResult: RayResult, tapLocation: CGPoint, arGameView: ARGameView ) {
        

        if let hit = results.first {
            let ent = hit.entity
            let cam = AnchorEntity(.camera)
            
            print("------>",ent.position)
            print(".......",hit.distance)
            

            print("ent?", cam.convert(
                position: cam.position,
                to: ent
            ))

            
            
            
            var transform = Transform()
            transform.translation = [0.25,0,-0.25]
            
            
            ent.move(to: transform, relativeTo: AnchorEntity(.camera), duration: 2)
//            ent.move
            
        }
    }
    
    func failure(rayResult: RayResult, tapLocation: CGPoint, arGameView: ARGameView ) {
        guard let raycastQuery = arGameView.makeRaycastQuery(
            from: tapLocation,
            allowing: .existingPlaneInfinite,
            alignment: .any
        ) else {
            print("unable to make raycastQuery")
            return
        }
        
        var worldTransform:simd_float4x4
        var anchorEntity: AnchorEntity
        
        if let raycastResult = arGameView.session.raycast(raycastQuery).first {
            worldTransform = raycastResult.worldTransform
            anchorEntity = AnchorEntity(world: [0,0,-0.5]) // AnchorEntity(raycastResult: raycastResult)
        } else {
            // articial world transform
            print("fail!")
            let a = AnchorEntity(world: [0,0,-0.5])
//            let a = AnchorEntity(world: rayResult.direction)
            worldTransform = a.transform.matrix
//            worldTransform = simd_float4x4(
//                [[0.89322066, 0.0, 0.44961852, 0.0],
//                 [0.0, 1.0, 0.0, 0.0],
//                 [-0.44961852, 0.0, 0.89322066, 0.0],
//                 [0.21048257, -0.22268523, -0.48695323, 1.0]]
//            )
            
            anchorEntity = AnchorEntity(world: worldTransform)
            
        }
        
        
//        print(worldTransform)
        
        
        let transformation = Transform(matrix: worldTransform) // puts it where you tapped (calcs the z)
        let box = Laser()
        box.generateCollisionShapes(recursive: true)
        
        box.transform = transformation
        
//        let raycastAnchor = AnchorEntity(raycastResult: result)
//        AnchorEntity(world: result.worldTransform)
        
        anchorEntity.addChild(box)
        arGameView.scene.addAnchor(anchorEntity)
        
        print("---- BOX POS ----",box.position)
        
        // MARK: --------------- BASIC ALGABRA TIME ----------------
        // get positions
        let x: Float = box.position.x
        let y: Float = box.position.y
        let z: Float = box.position.z
        
        // get the slop
        let m: Float = z/x
        
        // declare desired z
        let newZ: Float = -3
        let newX: Float = newZ / m
        
        
        
        

        var t = Transform(matrix: worldTransform)
//        t.translation = [rayResult.direction.x * 10,
//                         rayResult.direction.y * 10,
//                         rayResult.direction.z > 0
//                            ? rayResult.direction.z * -10
//                            : rayResult.direction.z * 10]
        t.translation = [ newX,
                          box.position.y,
                          newZ]
//        t.translation = [0,0,-2]
        
        box.move(to: t, relativeTo: nil, duration: 2)
        
//        wait(1.5){
//            arGameView.scene.removeAnchor(anchorEntity)
//        }
        
        // ------------------------------ debugging -----------------------------
        print("rayResult.direction")
        print(rayResult.direction)
        print("rayResult.origin")
        print(rayResult.origin)
        
        print("((((-----))))------>>>", newX, newZ)


    }
    
    func wait(_ duration: TimeInterval, callback: @escaping ()->Void){
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            callback()
        }
    }
}
