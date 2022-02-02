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
        arView.session.run(config, options: .resetTracking)
        
        return arView
    }
    func updateUIView(_ uiView: ARGameView, context: Context) {
    }
}
