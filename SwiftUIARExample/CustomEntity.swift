//
//  CustomEntity.swift
//  SwiftUIARExample
//
//  Created by Eli Allen on 2/4/22.
//

import SwiftUI
import RealityKit
import Combine

class CustomEntity: Entity, HasModel, HasCollision {
    
    var collisionSubs: [Cancellable] = []
    
    static let size: SIMD3<Float> = [0.5,0.5,0.5]
    
    required init(color: UIColor) {
        super.init()
        
        self.components[CollisionComponent.self] = CollisionComponent(
            shapes: [.generateBox(size: CustomEntity.size)],
            mode: .trigger,
          filter: .sensor
        )
        
        self.components[ModelComponent.self] = ModelComponent(
            mesh: .generateBox(size: CustomEntity.size),
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

class Rectangle: Entity, HasModel, HasCollision{
    var collisionSubs: [Cancellable] = []
    let dimensions:  SIMD3<Float>
    
    
    required init(color: UIColor, dimensions: SIMD3<Float>?) {
        self.dimensions = dimensions ?? SIMD3<Float>(0.5,0.5,0.5)
        super.init()
        
        
        self.components[CollisionComponent.self] = CollisionComponent(
            shapes: [.generateBox(size: self.dimensions)],
            mode: .trigger,
          filter: .sensor
        )
        
        self.components[ModelComponent.self] = ModelComponent(
            mesh: .generateBox(size: self.dimensions),
            materials: [SimpleMaterial(
                color: color,
                isMetallic: false)
            ]
        )
    }
    
    convenience init(color: UIColor, position: SIMD3<Float>) {
        self.init(color: color, dimensions: nil)
        self.position = position
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}



