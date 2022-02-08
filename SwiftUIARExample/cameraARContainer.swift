//
//  cameraARContainer.swift
//  SwiftUIARExample
//
//  Created by Eli Allen on 2/2/22.
//

import Foundation
import RealityKit
import ARKit
import SwiftUI
import Combine

struct CameraARContainer: UIViewRepresentable {
    
    func makeCoordinator() -> CameraARCoordinator<Self>{
        CameraARCoordinator<Self>(self)
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARGameView(frame: .zero)
        arView.setupGestures()
        
        let ent = CustomEntity(color: .white)
        let ent2 = CustomEntity(color: .blue)
        ent.generateCollisionShapes(recursive: true)
        ent2.generateCollisionShapes(recursive: true)
        
        let cameraAnchor = AnchorEntity()
        cameraAnchor.addChild(ent)
        cameraAnchor.addChild(ent2)
        arView.scene.addAnchor(cameraAnchor)
        ent.transform.translation.z = -2
        ent2.transform.translation = [2,0,-2]
        
        arView.installGestures(for: ent)
        arView.installGestures(for: ent2)
        
        // collision
        
        context.coordinator.subscriptions.append(
            arView.scene.publisher(for: CollisionEvents.Began.self, on: ent).sink{ value in
                print("COLLISION")
                guard let model = value.entityA as? CustomEntity else {return}
                model.model?.materials = [SimpleMaterial(color: .yellow, isMetallic: false)]
                
            }
        )
        context.coordinator.subscriptions.append(
            arView.scene.publisher(for: CollisionEvents.Began.self, on: ent2).sink{ value in
                print("COLLISION")
                guard let model = value.entityA as? CustomEntity else {return}
                model.model?.materials = [SimpleMaterial(color: .cyan, isMetallic: false)]
                
            }
        )
        
        // how to cancle a subscription
        //context.coordinator.subscriptions[0].cancel()
        
        // MARK: create a tower of power to sweet to be sour
        
        // create the anchor
        let anchor = AnchorEntity(.plane(.any, classification: .any, minimumBounds: [0.01,0.01]))
        
        for i in (0..<9){

            let xPosition: Float = Float(i % 3)
            let yPosition: Float = CustomEntity.size[1] * Float(i)
            let zPosition: Float = -3

            let box = CustomEntity(color: .random(), position: [xPosition, yPosition , zPosition])

            anchor.addChild(box)
        }

        arView.scene.addAnchor(anchor)
        

        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}


class ARCoordinator<ARContainer: UIViewRepresentable>: NSObject, ARSessionDelegate {
    var arVC: ARContainer
    var arGameView : ARGameView?
    var subscriptions: [Cancellable] = []
    
    init(_ control: ARContainer) {
        self.arVC = control
    }
    
    func makeSessionDelegate(for arView: ARGameView){
        arGameView = arView // get access the arView
        arGameView?.session.delegate = self // give the coordinator access to the AR session (see session methods)
    }
}


class CameraARCoordinator<ARContainer: UIViewRepresentable>: ARCoordinator<ARContainer> {
    
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}
