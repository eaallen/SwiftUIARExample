//
//  ARView+Coaching.swift
//  SwiftUIARExample
//
//  Created by Eli Allen on 1/7/22.
//

import Foundation
import RealityKit
import ARKit

// taken from https://www.iosdevie.com/p/introduction-to-realitykit-on-ios
extension ARView: ARCoachingOverlayViewDelegate {
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.delegate = self
        coachingOverlay.session = self.session
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        coachingOverlay.goal = .anyPlane
        self.addSubview(coachingOverlay)
    }
    
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        //Ready to add entities next?
    }
}
