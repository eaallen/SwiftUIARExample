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
        ARViewData(name: "Example Image Tracking", view: AnyView(ExampleImageView())),
        ARViewData(name: "Auth Button", view: AnyView(AuthButton())),
        ARViewData(name: "Covid 19", view: AnyView(Covid19ARContainer())),
        ARViewData(name: "Place Boxes!", view: AnyView(BoxPlacer())),
        ARViewData(name: "Swab Box", view: AnyView(ImageAnchorARContainer<Experience.Box>(expiranceScene: Experience.loadBox))),
        ARViewData(name: "Basic Button", view: AnyView(ImageAnchorARContainer<Experience.Button>(expiranceScene: Experience.loadButton))),
        ARViewData(
            name: "Theremometer",
            view: AnyView(AnyAnchorARContainer<Experience.Theremometer>(expiranceScene: Experience.loadTheremometer))
        ),
    ]
    
    
    var body: some View {
        // input data
 
        return NavigationView{
            List(arViews){ ar in
                NavigationLink(ar.name){
                    ar.view
                }
//                NavigationLink("Auth Button"){
//                    AuthButton()
//                }
//                NavigationLink("Covid 19"){
//                    Covid19ARContainer()
//                }
//                NavigationLink("Place a box with text"){
//                    ARViewContainer(overlayText: $text)
//                }
//                NavigationLink("cool box"){
//                    ImageAnchorARContainer<Experience.Box>(expiranceScene: Experience.loadBox)
//                }
//                NavigationLink("Button"){
//                    ImageAnchorARContainer<Experience.Button>(expiranceScene: Experience.loadButton)
//                }
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
