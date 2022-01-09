//
//  ExampleImageAnchor.swift
//  SwiftUIARExample
//
//  Created by Eli Allen on 1/7/22.
//

import Foundation
import SwiftUI
import ARKit
import RealityKit

struct ExampleImageView : View {
    
    @State private var anchorEntity = AnchorEntity()
    @State private var model = ModelEntity()
    var body: some View {
        MyARViewContainer(anchorEntity: $anchorEntity, model: $model)
    }
}

struct MyARViewContainer: UIViewRepresentable {
    
    @Binding var anchorEntity : AnchorEntity
    @Binding var model : ModelEntity
    func makeCoordinator() -> MyARCoordinator {
        MyARCoordinator(self, anchor: $anchorEntity, model: $model)
    }
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        let config = ARImageTrackingConfiguration()
        if let images = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main){
            config.trackingImages = images
            config.maximumNumberOfTrackedImages = images.count
        }
        arView.session.run(config)
        arView.session.delegate = context.coordinator
        
        arView.scene.addAnchor(anchorEntity)
        return arView
    }
    func updateUIView(_ uiView: ARView, context: Context) {}
}



class MyARCoordinator : NSObject , ARSessionDelegate {
    @Binding var anchorEntity : AnchorEntity
    @Binding var model : ModelEntity
    var MyarViewContainer : MyARViewContainer
    var customModel = CustomBox(color:.brown)
    init(_ control : MyARViewContainer , anchor : Binding<AnchorEntity> , model : Binding<ModelEntity> ){
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
                MyarViewContainer.anchorEntity.addChild(theAnchor)
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
