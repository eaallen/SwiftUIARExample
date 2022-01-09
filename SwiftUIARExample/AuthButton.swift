//
//  AuthButton.swift
//  SwiftUIARExample
//
//  Created by Eli Allen on 1/7/22.
//

import Foundation


import SwiftUI
import RealityKit
import ARKit





struct AuthButton: UIViewRepresentable {
    
    typealias TheView = ARGameView

    func makeCoordinator() -> AuthButtonCoordinator{
        AuthButtonCoordinator(self)
    }
    
    func makeUIView(context: Context) -> TheView {
        // Load the "Box" scene from the "Experience" Reality File
        let arView = ARGameView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)

        arView.enableTapGesture(handler: Covid19TapHandler())

        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }

        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages


        // not all versions of ios support this feature
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh){
            configuration.sceneReconstruction = .mesh
        }


        arView.session.run(configuration)

        arView.session.delegate = context.coordinator

        print("added the delegate")

        return arView
    }
    
    func updateUIView(_ arView: TheView, context: Context) {
        print("update the UIView!")
        if let modelEntity = try? ModelEntity.load(named: "button"){
            var layout = SIMD3<Float>()
            layout.x = 0
            layout.y = 0
            layout.z = -1
            let anchorEntity = AnchorEntity(world: layout)

            modelEntity.generateCollisionShapes(recursive: true)
            anchorEntity.addChild(modelEntity)
            arView.scene.anchors.append(anchorEntity)
        } else {
            print ("Unable to get Covid19 usdz model")
        }
        
        let anchorEntity = AnchorEntity(.image(group: "AR Resources", name: "imgAnchor"))
        print("-------------")
        print(anchorEntity)
    }
    
}

class AuthButtonCoordinator: NSObject, ARSessionDelegate {
    var arVC: AuthButton
        
    init(_ control: AuthButton) {
        self.arVC = control
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        print("WE DID UPDATE FRAME!!!!")
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        print("WE DDID ANCHOR!!!!", anchors)

        // filter image anchors for the right one
        let anchor = anchors.filter{
            $0.name == "imgAnchor"
        }.first

        // make sure this is a ARImageAnchor
        guard let imageAnchor = anchor as? ARImageAnchor else {return}

        let theAnchor = AnchorEntity(anchor: imageAnchor)

        guard let modelEntity = try? ModelEntity.load(named: "button") else {return}

        theAnchor.addChild(modelEntity)

//        self.arVC.arView.scene.addAnchor(theAnchor)
//        session.add(anchor: AR)
        
    }
    
}
