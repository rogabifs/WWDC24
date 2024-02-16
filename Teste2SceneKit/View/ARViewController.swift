//
//  ARViewController.swift
//  Teste2SceneKit
//
//  Created by Ronald Gabriel on 15/02/24.
//

import Foundation
import ARKit
import RealityKit

class ARViewController: UIViewController, ARSessionDelegate {
    @IBOutlet weak var arView: ARView!
    let scene = ChladniScene()
    
    override func viewDidLoad() {
      super.viewDidLoad()
   
      arView.session.delegate = self
      
      overlayCoachingView()
      setupARView()
        Scene(scene: scene)
        
      
      
  }

  //Overlay coaching view "adjust iphone scan"
  func overlayCoachingView () {
      
      let coachingView = ARCoachingOverlayView(frame: CGRect(x: 0, y: 0, width:
   arView.frame.width, height: arView.frame.height))
      
      coachingView.session = arView.session
      coachingView.activatesAutomatically = true
      coachingView.goal = .verticalPlane
      
      view.addSubview(coachingView)
      
      
  }//end overlay
      

  func setupARView(){
      arView.automaticallyConfigureSession = false
      let configuration = ARWorldTrackingConfiguration()
      configuration.planeDetection = [.horizontal, .vertical]
      configuration.environmentTexturing = .automatic
      arView.session.run(configuration)
  }
}
