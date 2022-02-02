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

struct ShooterARContainer: UIViewRepresentable {
            
    func makeUIView(context: Context) -> ARGameView {
        
        // ar view only get intilized in the makeUIView!
        let arView = ARGameView(frame: .zero)
        
        arView.enableTapGesture(handler: ShooterTapHandler())
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        // not all versions of ios support this feature
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh){
            config.sceneReconstruction = .mesh
        }
        arView.session.run(config, options: .resetTracking)
        
        return arView
    }
    func updateUIView(_ arView: ARGameView, context: Context) {
        print("Update the ARView")
        if let modelEntity = try? ModelEntity.loadModel(named: "Covid19"){
            let anchorEntity = AnchorEntity(.plane(.horizontal, classification: .floor, minimumBounds: [0,0]))
            modelEntity.generateCollisionShapes(recursive: true)
            anchorEntity.addChild(modelEntity)
            arView.scene.anchors.append(anchorEntity)
        } else {
            print ("Unable to get Covid19 usdz model")
        }
    }
}
