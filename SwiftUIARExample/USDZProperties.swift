//
//  USDZProperties.swift
//  SwiftUIARExample
//
//  Created by Eli Allen on 2/7/22.
//

import Foundation
import ARKit
import RealityKit
import SwiftUI

struct USDZPropertiesARContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
                
        let anchorEntity = AnchorEntity(.plane(.any, classification: .any, minimumBounds: [0.01,0.01]))
        
        if let dnaStand = DNAStand.create(dnaType: "bean-dna", lable: "Bean-Variant DNA" ) {
            anchorEntity.addChild(dnaStand)
        }
        
        if let dnaStand = DNAStand.create(dnaType: "delta-variant", lable: "Delta-Variant DNA" ) {
            anchorEntity.addChild(dnaStand)
            dnaStand.position.z += DNAStand.platformDimensions.z / 4
        }

        
        anchorEntity.transform.rotation = simd_quatf(angle: .pi/2, axis: SIMD3<Float>(0,1,0))
        
        arView.scene.addAnchor(anchorEntity)
        

        
        return arView
    }
    func updateUIView(_ uiView: ARView, context: Context) {}
}



class USDZPropertiesCoordinator : NSObject , ARSessionDelegate {
    @Binding var anchorEntity : AnchorEntity
    @Binding var model : ModelEntity
    var MyarViewContainer : USDZPropertiesARContainer
    var customModel = CustomBox(color:.brown)
    init(_ control : USDZPropertiesARContainer , anchor : Binding<AnchorEntity> , model : Binding<ModelEntity> ){
        _anchorEntity = anchor
        _model = model
        self.MyarViewContainer = control
    }
    
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        
        for anchor in anchors {
            if let imageAnchor = anchor as? ARImageAnchor {
                //                model = customModel.creatModel(anchor: imageAnchor)
                //                model.name = imageAnchor.referenceImage.name!
                
                let theAnchor = AnchorEntity(anchor: imageAnchor)
                theAnchor.addChild(model)
                //                MyarViewContainer.anchorEntity.addChild(theAnchor)
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
        for anchor in anchors {
            if let imageAnchor = anchor as? ARImageAnchor {
                
                let imageName = imageAnchor.referenceImage.name!
                for item in anchorEntity.children {
                    if imageName == item.name {
                        item.transform.matrix = imageAnchor.transform
                        item.transform.translation.x += 0.05
                    }
                }
            }
        }
    }
}
