//
//  Covid19ARContainer.swift
//  SwiftUIARExample
//
//  Created by Eli Allen on 1/5/22.
//

import Foundation
import SwiftUI
import RealityKit
import ARKit


struct Covid19ARContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARGameView {
        print("making the View!")
        let arView = ARGameView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        
        arView.enableTapGesture(handler: Covid19TapHandler())
       
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        // not all versions of ios support this feature
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh){
            config.sceneReconstruction = .mesh
        }
        
        arView.session.run(config)

        return arView
    }
    
    func updateUIView(_ arView: ARGameView, context: Context) {
        print("update the UIView!")
        if let modelEntity = try? ModelEntity.loadModel(named: "Covid19"){
            var layout = SIMD3<Float>()
            layout.x = 0
            layout.y = 0.5
            layout.z = -3
            let anchorEntity = AnchorEntity(world: layout)
            modelEntity.generateCollisionShapes(recursive: true)
            anchorEntity.addChild(modelEntity)
            arView.scene.anchors.append(anchorEntity)
        } else {
            print ("Unable to get Covid19 usdz model")
        }
    }
    
}
