//
//  ARViewConfig.swift
//  Teste2SceneKit
//
//  Created by Ronald Gabriel on 14/02/24.
//

import Foundation
import ARKit
import UIKit


public class ARViewConfig: ARSCNView, ARSCNViewDelegate, ARCoachingOverlayViewDelegate {
    
    var tapLabel: UILabel!
    var floorNode: SCNNode!
    var addTapGest: UITapGestureRecognizer!
    
    public override init(frame: CGRect) {
        super.init(frame: frame, options: nil)
        delegate = self
        alpha = 0
        
        // The first steps view
        
        let coachingView = ARCoachingOverlayView(frame: bounds)
        coachingView.delegate = self
        coachingView.activatesAutomatically = true
        coachingView.goal = .verticalPlane
        coachingView.session = session
        addSubview(coachingView)
        
      
        
        NSLayoutConstraint.activate([
            coachingView.topAnchor.constraint(equalTo: topAnchor),
            coachingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            coachingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            coachingView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Add Earth tap gesture
        addTapGest = UITapGestureRecognizer(target: self, action: #selector(getter: scene))
        addTapGest.isEnabled = false
        addGestureRecognizer(addTapGest)
        
        tapLabel = UILabel(frame: CGRect(x: 0, y: bounds.height-(bounds.height/25)-(bounds.height/15), width: bounds.width, height: bounds.height/25))
        tapLabel.text = "Tap anywhere to add the Chladni Particles"
//        tapLabel.setupLabel(color: .white, fontWeight: .Bold)
        tapLabel.alpha = 0
        
        addSubview(tapLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var keepObservingFloor = true
    
    /**
     Add the Earth node to the AR Scene responding to the tap gesture.
     */
//    @objc func addNode() {
//        if floorNode != nil {
//            keepObservingFloor = false
//            
//            UIView.animate(withDuration: 0.7) {
//                self.tapLabel.alpha = 0
//            }
//            
//            // Get node from the SceneKit scene and scale it to match real world size
//            let earthNode = (superview as! MainView).sceneView.earthNode
//            earthNode.removeFromParentNode()
//            earthNode.position = floorNode.position
//            earthNode.position.y += Float(earthNode.boundingBox.max.y - earthNode.boundingBox.min.y)/6
//            earthNode.scaleParticles(scale: 0.25)
//            earthNode.scale = SCNVector3Make(0.27, 0.27, 0.27)
//            
//            // Removing and deinitlizing the floor
//            floorNode.parent?.addChildNode(earthNode)
//            
//            floorNode.removeFromParentNode()
//            floorNode = nil
//            
//            
//        }
//    }
    
    /**
     Creates and returns the floor node based on renderer anchor
     - parameters:
     - anchor: the renderer anchor point
     */
    func createFloor(anchor: ARPlaneAnchor) -> SCNPlane {
        
        let material = SCNMaterial()
        
        material.lightingModel = .physicallyBased
        material.diffuse.contents = UIColor.white.withAlphaComponent(0.8)
        material.isDoubleSided = false
        
        let floor = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        floor.materials = [material]
        
        return floor
    }
    
    // MARK: - ARSCNViewDelegate
    
    public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let anchor = anchor as? ARPlaneAnchor else {
            return
        }
        
        // Add the floor node to the scene
        if floorNode == nil && keepObservingFloor {
            floorNode = SCNNode(geometry: createFloor(anchor: anchor))
            floorNode.opacity = 0
            floorNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
            
            node.addChildNode(floorNode)
        }
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let anchor = anchor as? ARPlaneAnchor else {
            return
        }
        
        // Update the floor's position and dimension
        if floorNode != nil {
            floorNode.geometry = createFloor(anchor: anchor)
        }
    }
    
    // MARK: - ARCoachingOverlayViewDelegate
    
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        addTapGest.isEnabled = true
        
        if floorNode != nil {
            floorNode.opacity = 1
        }
        
        UIView.animate(withDuration: 0.7) {
            self.tapLabel.alpha = 1
        }
        
        // Removing and deinitlizing the CoachingView
        coachingOverlayView.delegate = nil
        coachingOverlayView.removeFromSuperview()
    }
}

