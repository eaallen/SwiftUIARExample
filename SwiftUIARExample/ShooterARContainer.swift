//
//  ShooterARContainer.swift
//  SwiftUIARExample
//
//  Created by Eli Allen on 2/2/22.
//

import Foundation
import SwiftUI
import RealityKit
import ARKit
import Combine

struct Shooter: View {
    var eventHandler = EventHanlder()
    var body: some View{
        ZStack{
            ShooterARContainer(eventHanlder: eventHandler)
            VStack{
                Spacer()
                ZStack{
                    RoundedRectangle(cornerRadius: 3).frame(width: 80, height: 80)
                    Text("FIRE").foregroundColor(.white).font(.largeTitle)
                    
                }.onTapGesture {
                    eventHandler.run()
                }
                
            }.padding(50)
            
        }
    }
}

class EventHanlder {
    var run: ()-> Void
    
    init(){
        // set call to an empty method
        run = {
            print("EventHandler.run was not set")
        }
    }
    
    func setRun(_ callback: @escaping ()->Void){
        run = callback
    }
}


struct ShooterARContainer: UIViewRepresentable {
    var eventHanlder: EventHanlder
    var pointCollisionSubscription: Cancellable?
    func makeCoordinator() -> ShooterARCoordinator<Self>{
        ShooterARCoordinator<Self>(self)
    }
    
    
    func makeUIView(context: Context) -> ARGameView {
        // ar view only get intilized in the makeUIView!
        let arView = ARGameView(frame: .zero)
        
        // enable tap gesture
        arView.enableTapGesture(handler: ShooterTapHandler())
        
        // give the ARView to the coordinator
        context.coordinator.setARView(arView)
        
        // allow the UI to call the coordinator shoot method
        eventHanlder.setRun(context.coordinator.shoot)
        
        
        // create the AR model that the bullets will go to
        // box taken from https://stackoverflow.com/a/58401369/15034002
        let box = ModelEntity(
            mesh: MeshResource.generateBox(size: 0.05),
            materials: [SimpleMaterial(color: .clear, isMetallic: true)]
        )
        box.name = "box" // we give it a name so it will be easy to find later
        
        // set the box relative to the camera
        let cameraAnchor = AnchorEntity(.camera)
        cameraAnchor.addChild(box)
        arView.scene.addAnchor(cameraAnchor)
        
        
        // Move the box in front of the camera by 3 meters
        box.transform.translation = [0, 0, -3]
        
        return arView
    }
    func updateUIView(_ arView: ARGameView, context: Context) {
        // place the covid-19 model
        print("update the UIView!")
        if let modelEntity = try? ModelEntity.loadModel(named: "Covid19"){
            var layout = SIMD3<Float>()
            layout.x = 0
            layout.y = 0.5
            layout.z = -3
            let anchorEntity = AnchorEntity(world: layout)
            modelEntity.generateCollisionShapes(recursive: true) // this will let us shoot the object
            modelEntity.name = "COVID19"
            anchorEntity.addChild(modelEntity)
            arView.scene.anchors.append(anchorEntity)
        } else {
            print ("Unable to get Covid19 usdz model")
        }
    }
}

class ShooterARCoordinator<ARContainer: UIViewRepresentable>: NSObject, ARSessionDelegate {
    var arVC: ARContainer
    var arGameView : ARGameView?
    var box =  Laser()
    
    var count = 0.0
    
    var sub: Cancellable?
    
    init(_ control: ARContainer) {
        self.arVC = control
    }
    
    func setARView(_ arView: ARGameView){
        arGameView = arView // get access the arView
        arGameView?.session.delegate = self // give the coordinator access to the AR session (see session methods)
    }
    
    
    func shoot(){
        // if the target box is avaliable
        if let target = arGameView?.scene.findEntity(named: "box"){
            let bullet = ModelEntity(
                mesh: MeshResource.generateSphere(radius: 0.05),
                materials: [SimpleMaterial(color: .white, isMetallic: false)]
            )
            bullet.generateCollisionShapes(recursive: true) // will allow colission between the bullet and the covid
            
            // call the following method when the bullet has a collision
            sub = arGameView?.scene.publisher(for: CollisionEvents.Began.self, on: bullet).sink(receiveValue: collisionHanlder)
            
            // anchor the bullet to the camera
            let camera = AnchorEntity(.camera)
            camera.addChild(bullet)
            arGameView?.scene.addAnchor(camera)
            
            // offset it down a few centimeters
            bullet.position.y = -0.125
            
            // fire! (move the bullet to the target named "box")
            bullet.move(to: target.transform, relativeTo: target, duration: 0.4)
            
            Async.wait(0.4){
                bullet.removeFromParent()
            }
        }
    }
    
    func collisionHanlder(collisionData: CollisionEvents.Began){
        // entityA is the bullet, entityB is the first thing it hit.
        
        // if the first thing it hit was Covid-19
        if collisionData.entityB.name == "COVID19" {
            let ent = collisionData.entityB
            
            // roll it!
            let rollTransform = Transform(pitch: 0, yaw: 0, roll: 5)
            ent.move(to: rollTransform, relativeTo: ent, duration: Async.Constants.rollDuration)
            
            Async.wait(Async.Constants.rollDuration){
                // roll it backwords
                let rollTransform = Transform(pitch: 0, yaw: 0, roll: -5)
                ent.move(to: rollTransform, relativeTo: ent, duration: Async.Constants.rollDuration)
                
                Async.wait(Async.Constants.rollDuration){
                    // shrink it!
                    var transform = Transform()
                    transform.scale = SIMD3(0.1,0.1,0.1)
                    transform.translation = ent.position
                    
                    ent.move(to: transform, relativeTo: ent, duration: Async.Constants.shrinkDuration)
                    
                    Async.wait(Async.Constants.shrinkDuration - 0.1){
                        ent.removeFromParent()
                        
                        // place a new covid 19
                        
                    }
                }
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate anchors : [ARAnchor]) {}
    func session(_ session: ARSession, didUpdate frame: ARFrame) {}
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {}
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {}
}

struct Async {
    static func wait(_ duration: TimeInterval, callback: @escaping ()->Void){
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            callback()
        }
    }
    
    struct Constants {
        static let shrinkDuration: TimeInterval = 1
        static let rollDuration  : TimeInterval = 0.5
        static let totalDuration : TimeInterval = 2
    }
    
}
