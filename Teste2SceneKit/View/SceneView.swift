//
//  SceneView.swift
//  Teste2SceneKit
//
//  Created by Ronald Gabriel on 01/02/24.
//

import Foundation
import UIKit
import SceneKit

func Scene(scene: ChladniScene)  {    
    // Create a new scene
    scene.setupParticles(nParticles: Constantes.particles)
}

func SceneView(sceneView: SCNView, scene: ChladniScene) {
    // Set the scene to the view

    sceneView.scene = scene
    
    let view = SCNView(frame: CGRect(x: Double(PlaneNodeView.planeNode.position.x), y: Double(PlaneNodeView.planeNode.position.y), width: 0.5, height: 0.5))
    view.isOpaque = true
    let particleNode = Particles(x: .random(in: 0...1), y: .random(in: 0...1), z: Particles.z).node
    view.scene = scene
    view.allowsCameraControl = true
    view.backgroundColor = UIColor.clear
    sceneView.scene = scene
    sceneView.scene?.rootNode.addChildNode(particleNode)
    
    let light = SCNLight()
    light.type = .omni
    let lightNode = SCNNode()
    lightNode.light = light
    sceneView.pointOfView?.addChildNode(lightNode)
}

