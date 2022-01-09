//
//  AnyAnchorARContainer.swift
//  SwiftUIARExample
//
//  Created by Eli Allen on 1/8/22.
//

import Foundation
import SwiftUI
import RealityKit
import ARKit

struct AnyAnchorARContainer<ExpiranceScene: HasAnchoring> : UIViewRepresentable {
    
    typealias TheView = ARView
    
    let expiranceScene: () throws -> ExpiranceScene
    let coachingGoal: ARCoachingOverlayView.Goal?
    
    init(expiranceScene: @escaping () throws -> ExpiranceScene, coachingGoal: ARCoachingOverlayView.Goal? = nil ){
        self.coachingGoal = coachingGoal
        self.expiranceScene = expiranceScene
    }
    
    func makeUIView(context: Context) -> TheView {
        let arView = ARView(frame: .zero)
        
        if let goal = coachingGoal {
            arView.addCoaching(goal: goal)
        }
        
        if let anchor = try? expiranceScene(){
            // Add the box anchor to the scene
            arView.scene.addAnchor(anchor)
        }else{
            // handle error
        }
        
        return arView
    }
    
    func updateUIView(_ arView: TheView, context: Context) {
        
    }
    
}
