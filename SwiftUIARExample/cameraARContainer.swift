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

struct CameraARContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARGameView(frame: .zero)
        
        arView.enableTapGesture(handler: CameraShoot())
        
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
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}
