//
//  SwabBoxARContainer.swift
//  SwiftUIARExample
//
//  Created by Eli Allen on 1/5/22.
//

import Foundation
import SwiftUI
import RealityKit
import ARKit





struct SwabBoxARContainer: UIViewRepresentable {
    
    typealias TheView = ARView
    
    // creates the coordinator that is used in the context
    func makeCoordinator() -> ImageAnchorCoordinator<SwabBoxARContainer> {
        ImageAnchorCoordinator<SwabBoxARContainer>(self)
    }
    
    func makeUIView(context: Context) -> TheView {
        // Load the "Box" scene from the "Experience" Reality File
        let arView = ARView(frame: .zero)
        if let boxAnchor = try? Experience.loadBox(){


            // Add the box anchor to the scene
            arView.scene.addAnchor(boxAnchor)

            // Add delegate
            context.coordinator.setARView(arView)
            
            arView.session.delegate = context.coordinator // an instance of SwabBoxCoordinator
        }
        
        return arView
    }
    
    func updateUIView(_ arView: TheView, context: Context) {
        
    }
    
}
