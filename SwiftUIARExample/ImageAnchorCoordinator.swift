//
//  ImageAnchorCoordinator.swift
//  SwiftUIARExample
//
//  Created by Eli Allen on 1/8/22.
//

import Foundation
import ARKit
import RealityKit
import SwiftUI

// This coordinator will be our delegate!
class ImageAnchorCoordinator<ARContainer: UIViewRepresentable> : NSObject, ARSessionDelegate {
    var arVC: ARContainer
    var imageAnchorToEntity: [ARImageAnchor: AnchorEntity] = [:]
    var arView : ARView?
    init(_ control: ARContainer) {
        self.arVC = control
    }
    
    func setARView(_ arView: ARView){
        self.arView = arView
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        anchors.compactMap { $0 as? ARImageAnchor }.forEach {
            // only do the following if we have the tardis and an arview
            
            if let arView = arView {
                
                let anchorEntity = AnchorEntity()
                
                for anchor in arView.scene.anchors {
                    for child in anchor.children{
                        anchorEntity.addChild(child)
                    }
                }
                
                arView.scene.addAnchor(anchorEntity)
                
                anchorEntity.transform.matrix = $0.transform
                
                imageAnchorToEntity[$0] = anchorEntity
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        anchors.compactMap { $0 as? ARImageAnchor }.forEach {
            let anchorEntity = imageAnchorToEntity[$0]
            anchorEntity?.transform.matrix = $0.transform
        }
    }
}
