////
////  InitCoachingOverlay.swift
////  Teste2SceneKit
////
////  Created by Ronald Gabriel on 12/02/24.
////
//
//import Foundation
//import SceneKit
//import RealityKit
//import ARKit
//
//func initCoachingOverlay(coachingOverlay: CoachingOverlayView, scene: SCNS) {
//    coachingOverlay.session = scene.session
//    coachingOverlay.delegate = self
//    coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
//    view.addSubview(coachingOverlay)
//    
//    NSLayoutConstraint.activate([
//        coachingOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//        coachingOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//        coachingOverlay.widthAnchor.constraint(equalTo: view.widthAnchor),
//        coachingOverlay.heightAnchor.constraint(equalTo: view.heightAnchor)
//    ])
//    
//    coachingOverlay.activatesAutomatically = true
//    coachingOverlay.goal = .horizontalPlane
//    coachingOverlay.showsActiveGoal = true
//}
import Foundation
import ARKit
import RealityKit

public func makeARView() -> ARView {
    let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
    arView.addCoaching()
    
    let config = ARWorldTrackingConfiguration()
            config.planeDetection = .horizontal
           
            if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
                config.frameSemantics.insert(.personSegmentationWithDepth)
            }
            arView.session.run(config, options: [])
    
    return arView
}

extension ARView: ARCoachingOverlayViewDelegate {
    func addCoaching() {
        
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.delegate = self
        coachingOverlay.session = session
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        coachingOverlay.goal = .anyPlane
        self.addSubview(coachingOverlay)
    }
    
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        //Ready to add entities next?
    }
}
