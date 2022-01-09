//
//  ImageAnchorARContainer.swift
//  SwiftUIARExample
//
//  Created by Eli Allen on 1/8/22.
//

import Foundation
import SwiftUI
import RealityKit
import ARKit

struct ImageAnchorARContainer<ExpiranceScene: HasAnchoring> : UIViewRepresentable {
    
    typealias TheView = ARView
    
    let expiranceScene: () throws -> ExpiranceScene
    
    // creates the coordinator that is used in the context
    func makeCoordinator() -> ImageAnchorCoordinator<Self> {
        ImageAnchorCoordinator<Self>(self)
    }
    
    func makeUIView(context: Context) -> TheView {
        let arView = ARView(frame: .zero)
        if let anchor = try? expiranceScene(){
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
