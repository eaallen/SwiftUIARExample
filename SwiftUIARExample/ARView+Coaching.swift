//
//  ARView+Coaching.swift
//  SwiftUIARExample
//
//  Created by Eli Allen on 1/7/22.
//

import Foundation
import RealityKit
import ARKit

// code from https://www.iosdevie.com/p/introduction-to-realitykit-on-ios
extension ARView: ARCoachingOverlayViewDelegate {
    func addCoaching(goal: ARCoachingOverlayView.Goal) {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.delegate = self
        coachingOverlay.session = self.session
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        coachingOverlay.goal = goal
        self.addSubview(coachingOverlay)
    }
    
    /// The delegate’s coachingOverlayViewDidDeactivate function gets triggered once the goal is met.
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView){}
}
