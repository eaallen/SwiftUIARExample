//
//  DNAStand.swift
//  SwiftUIARExample
//
//  Created by Eli Allen on 2/7/22.
//

import Foundation
import ARKit
import RealityKit

struct DNAStand {
    static let platformDimensions = SIMD3<Float>(0.5,0.01,1.1)
    
    
    static func create(dnaType modelName: String, lable: String)-> ModelEntity?{
        guard  let modelEntity = try? ModelEntity.loadModel(named: modelName)else{return nil}
        
        modelEntity.generateCollisionShapes(recursive: true)
        // place a platform under the dna
        
        let platform = Rectangle(color: .white, dimensions: DNAStand.platformDimensions)
        
        platform.position = modelEntity.position
        platform.position.y -= 0.47
        platform.position.z -= 0.1
        
        modelEntity.addChild(platform)
        
        platform.orientation = simd_quatf(angle: .pi/2, axis: SIMD3<Float>(1,0,0))
        
        // place a lable
        let mesh = MeshResource.generateText(
            lable,
            extrusionDepth: 0.1,
            font: .systemFont(ofSize: 2),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail)
        
        let material = SimpleMaterial(color: .red, isMetallic: false)
        let label = ModelEntity(mesh: mesh, materials: [material])
        label.scale = SIMD3<Float>(0.05, 0.05, 0.05)
        
        platform.addChild(label)
        label.setPosition([-0.24,0,-0.47], relativeTo: label.parent)
        label.orientation = simd_quatf(angle: -.pi/2, axis: SIMD3<Float>(0,1,0))

        
        modelEntity.scale = [0.2,0.2,0.2]
        return modelEntity
    }
    
    
    
}
