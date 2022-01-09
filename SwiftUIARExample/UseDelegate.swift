//
//  UseDelegate.swift
//  SwiftUIARExample
//
//  Created by Eli Allen on 1/6/22.
//

import Foundation
import SwiftUI
import ARKit
import RealityKit


struct BoxPlacer:View {
    @State private var text = "Hello World"
    var body: some View {
        ARViewContainer(overlayText: $text).ignoresSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @Binding var overlayText: String
    
    func makeCoordinator() -> ARViewCoordinator{
        ARViewCoordinator(self, overlayText : $overlayText)
    }
    
    func makeUIView(context: Context) -> ARView {
        
        // ar view only get intilized in the makeUIView!
        let arView = ARView(frame: .zero)
//        arView.addCoaching()
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        arView.session.run(config, options: [])
        
        arView.setupGestures()
        arView.session.delegate = context.coordinator
        
        return arView
    }
    func updateUIView(_ uiView: ARView, context: Context) {
    }
}



class ARViewCoordinator: NSObject, ARSessionDelegate {
    var arVC: ARViewContainer
    
    @Binding var overlayText: String
    
    init(_ control: ARViewContainer, overlayText: Binding<String>) {
        self.arVC = control
        _overlayText = overlayText
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
    }
}


extension ARView{
    
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        guard let touchInView = sender?.location(in: self) else { return }
        
        rayCastingMethod(point: touchInView)
        
        //to find whether an entity exists at the point of contact
        _ = self.entities(at: touchInView)
    }
    
    func rayCastingMethod(point: CGPoint) {
        
        
        guard let coordinator = self.session.delegate as? ARViewCoordinator else{ print("GOOD NIGHT"); return }
        
        guard let raycastQuery = self.makeRaycastQuery(from: point,
                                                       allowing: .existingPlaneInfinite,
                                                       alignment: .horizontal) else {
                                                        
                                                        print("failed first")
                                                        return
        }
        
        guard let result = self.session.raycast(raycastQuery).first else {
            print("failed")
            return
        }
        
        let transformation = Transform(matrix: result.worldTransform)
        let box = CustomBox(color: .yellow)
        self.installGestures(.all, for: box)
        box.generateCollisionShapes(recursive: true)
        
        let mesh = MeshResource.generateText(
            "\(coordinator.overlayText)",
            extrusionDepth: 0.1,
            font: .systemFont(ofSize: 2),
            containerFrame: .zero,
            alignment: .left,
            lineBreakMode: .byTruncatingTail)
        
        let material = SimpleMaterial(color: .red, isMetallic: false)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.scale = SIMD3<Float>(0.03, 0.03, 0.1)
        
        box.addChild(entity)
        box.transform = transformation
        
        entity.setPosition(SIMD3<Float>(0, 0.05, 0), relativeTo: box)
        
        let raycastAnchor = AnchorEntity(raycastResult: result)
        raycastAnchor.addChild(box)
        self.scene.addAnchor(raycastAnchor)
    }
}

class CustomBox: Entity, HasModel, HasAnchoring, HasCollision {

    required init(color: UIColor) {
        super.init()
        self.components[ModelComponent.self] = ModelComponent(
            mesh: .generateBox(size: 0.1),
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
