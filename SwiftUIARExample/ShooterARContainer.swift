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
    @State var eventHandler = EventHanlder()
    var body: some View{
        ZStack{
            ShooterARContainer(eventHanlder: $eventHandler)
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
    @Binding var eventHanlder: EventHanlder
    var pointCollisionSubscription: Cancellable?
    func makeCoordinator() -> ShooterARCoordinator<Self>{
        ShooterARCoordinator<Self>(self)
    }
    
    
    func makeUIView(context: Context) -> ARGameView {
        // ar view only get intilized in the makeUIView!
        let arView = ARGameView(frame: .zero)
        
        arView.enableTapGesture(handler: ShooterTapHandler())
        
        context.coordinator.setARView(arView)
        arView.session.delegate = context.coordinator

        // from https://stackoverflow.com/a/58401369/15034002
        let box = ModelEntity(
            mesh: MeshResource.generateBox(size: 0.05),
            materials: [SimpleMaterial(color: .clear, isMetallic: true)]
        )
        box.name = "box"
        box.generateCollisionShapes(recursive: true)
    
        let cameraAnchor = AnchorEntity(.camera)
        cameraAnchor.addChild(box)
        arView.scene.addAnchor(cameraAnchor)
        
        eventHanlder.setRun(context.coordinator.shoot)
        
        // Move the box in front of the camera slightly
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
            modelEntity.generateCollisionShapes(recursive: true)
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
        self.arGameView = arView
        
    }
    
    
    func shoot(){
        if let target = arGameView?.scene.findEntity(named: "box"){
            let box = //BoxEntity(size: 0.05, color: .white, roughness: 1.0)
            ModelEntity(
                mesh: MeshResource.generateSphere(radius: 0.05),
                materials: [SimpleMaterial(color: .white, isMetallic: false)]
            )
            box.generateCollisionShapes(recursive: true)
//            boxCollisionSubscription = box.collision.publisher.sink{ collisionComponent in
//                print(collisionComponent.filter.group.rawValue)
//            }
            
            sub = arGameView?.scene.publisher(for: CollisionEvents.Began.self, on:box ).sink{ v in
                // if the first thing you hit was Covid-19
                if v.entityB.name == "COVID19" {
                    let ent = v.entityB
                    print("---->",ent.name)
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
            
            let camera = AnchorEntity(.camera)
            camera.addChild(box)
            arGameView?.scene.addAnchor(camera)
            
            box.position.y = -0.125
            
            box.move(to: target.transform, relativeTo: target, duration: 0.4)
            
            Async.wait(0.4){
                box.removeFromParent()
            }
            
        
        }
        
        
    }
    
    
    
    
    //    func session(_ session: ARSession, didUpdate anchors : [ARAnchor]) {
    ////        print("in session did update")
    //        if let arView = arGameView {
    //            guard let transform = arView.session.currentFrame?.camera.transform
    //            else { return }
    ////            print("???? ????")
    //
    //            let arkitAnchor = ARAnchor(transform: transform)
    //
    //            let anchor = AnchorEntity(anchor: arkitAnchor)
    //            anchor.addChild(box)
    //            arView.scene.addAnchor(anchor)
    //        }
    //    }
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        if let arView = arGameView {
            //            guard let transform = arView.session.currentFrame?.camera.transform
            //            else { return }
            //            print("???? ????", frame.camera.transform == transform)
            //
            ////            let arkitAnchor = ARAnchor(transform: transform)
            //
            //            let anchor = AnchorEntity(world: [0,0,-20])
            //
            //            print(transform.columns)
            //
            //            anchor.addChild(box)
            ////            box.position.z = Float(count)
            //            arView.scene.addAnchor(anchor)
//        }
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
//        print("ADDED an ANCHOR")
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
//        print("removed it!!!", anchors.first)
    }
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
