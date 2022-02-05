//
//  ContentView.swift
//  SwiftUIARExample
//
//  Created by Gove Allen on 12/15/21.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    @State var text = "nope"
    
    let arViews: [ARViewData] = [
        ARViewData(name: "Auth Button", view: AnyView(AuthButton())),
        ARViewData(name: "Covid 19", view: AnyView(Covid19ARContainer())),
        ARViewData(name: "Place Boxes!", view: AnyView(BoxPlacer())),
        ARViewData(name: "Swab Box", view: AnyView(ImageAnchorARContainer<Experience.Box>(expiranceScene: Experience.loadBox))),
        ARViewData(name: "Basic Button", view: AnyView(ImageAnchorARContainer<Experience.Button>(expiranceScene: Experience.loadButton))),
        ARViewData(
            name: "Theremometer",
            view: AnyView(AnyAnchorARContainer<Experience.Theremometer>(expiranceScene: Experience.loadTheremometer, coachingGoal: .horizontalPlane))
        ),
        ARViewData(name: "Shooter", view: AnyView(Shooter())),
//        ARViewData(name: "camera stuck", view: AnyView(CameraARContainer())),
    ]
    
    
    var body: some View {
        NavigationView{
            List(arViews){ ar in
                NavigationLink(ar.name){
                    ar.view.ignoresSafeArea()
                }
            }.navigationTitle("Home")

        }
    }
}


struct ARViewData: Identifiable {
    let name : String
    let view : AnyView
    let id = UUID()
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
