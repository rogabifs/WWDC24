////
////  CoachingOverlayView.swift
////  Teste2SceneKit
////
////  Created by Ronald Gabriel on 11/02/24.
////
//
//import Foundation
//import UIKit
//import SceneKit
//import ARKit
//import RealityKit
//
//class CoachingOverlayView: ARView {
//    var anchorEntity: AnchorEntity!
//    
//    enum goal {
//          case horizontalPlane
//          case verticalPlane
//          case anyPlane
//          case tracking
//      }
//    
//    required init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        let config = ARWorldTrackingConfiguration()
//        config.planeDetection = [.horizontal]
//        session.run(config, options: [])
//        
//        anchorEntity = AnchorEntity(plane: .vertical)
//        anchorEntity.name = "anchor"
//        scene.addAnchor(anchorEntity)
//
//        addCoaching()
//    }
//    
//    @objc required dynamic init?(coder decorder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func addCoaching() {
//        let coachingOverlay = ARCoachingOverlayView()
//        coachingOverlay.session = session
//        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        coachingOverlay.goal = .verticalPlane
//        self.addSubview(coachingOverlay)
//    }
//
//}
