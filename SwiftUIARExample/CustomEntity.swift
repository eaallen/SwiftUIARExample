//
//  CustomEntity.swift
//  SwiftUIARExample
//
//  Created by Eli Allen on 2/4/22.
//

import SwiftUI
import RealityKit
import Combine

class CustomEntity: Entity, HasModel, HasAnchoring, HasCollision {
    
    var collisionSubs: [Cancellable] = []
    
    required init(color: UIColor) {
        super.init()
        
        self.components[CollisionComponent.self] = CollisionComponent(
            shapes: [.generateBox(size: [0.5,0.5,0.5])],
            mode: .trigger,
          filter: .sensor
        )
        
        self.components[ModelComponent.self] = ModelComponent(
            mesh: .generateBox(size: [0.5,0.5,0.5]),
            materials: [SimpleMaterial(
                color: color,
                isMetallic: false)
            ]
        )
    }
    
    convenience init(color: UIColor, position: SIMD3<Float>) {
        self.init(color: color)
        self.position = position
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
