//
//  ARButton.swift
//  SwiftUIARExample
//
//  Created by Eli Allen on 1/8/22.
//

import Foundation
import SwiftUI
import RealityKit
import ARKit





struct ARButton: UIViewRepresentable {
    
    typealias TheView = ARView
    
    // creates the coordinator that is used in the context
    func makeCoordinator() -> ImageAnchorCoordinator<ARButton> {
        ImageAnchorCoordinator<ARButton>(self)
    }
    
    func makeUIView(context: Context) -> TheView {
        // Load the "Box" scene from the "Experience" Reality File
        let arView = ARView(frame: .zero)
        if let anchor = try? Experience.loadButton(){
            // Add the box anchor to the scene
            arView.scene.addAnchor(anchor)

            // Add delegate
            context.coordinator.setARView(arView)
            
            arView.session.delegate = context.coordinator // an instance of SwabBoxCoordinator
        }
        
        return arView
    }
    
    func updateUIView(_ arView: TheView, context: Context) {
        
    }
    
}
