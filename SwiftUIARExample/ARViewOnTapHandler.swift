//
//  ARViewOnTapHandler.swift
//  SwiftUIARExample
//
//  Created by Gove Allen on 12/16/21.
//

import Foundation

import RealityKit
import ARKit
protocol ARViewOnTapHandler {
    typealias RayResult = (origin: SIMD3<Float>, direction: SIMD3<Float>)
    
    func success(results: [CollisionCastHit], rayResult: RayResult, tapLocation: CGPoint, arGameView: ARGameView ) -> Void
    
    func failure(rayResult: RayResult, tapLocation: CGPoint, arGameView: ARGameView ) -> Void
}


struct DefaultTapHandler : ARViewOnTapHandler{
    func success(results: [CollisionCastHit], rayResult: RayResult, tapLocation: CGPoint, arGameView: ARGameView ) {}
    
    func failure(rayResult: RayResult, tapLocation: CGPoint, arGameView: ARGameView ) {}
}
