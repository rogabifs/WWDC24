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
    //        let scene = SCNScene()
    
//    let scene = ChladniScene()
    let chladni = ChladniFunc(particles: 2000, m: 3.0, n: 3.0, a: 0.02, b: 0.002, v: 0.002)
    scene.setupParticles(nParticles: 4)
    scene.moveParticles(chladni: chladni)
    //        scene.movFromEq(duration: 60.0, timeStep: 0.05)
}

func SceneView(sceneView: SCNView, scene: ChladniScene) {
    // Set the scene to the view
    sceneView.scene = scene
    
    
    let view = SCNView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
    view.isOpaque = true
    let particleNode = Particles(x: .random(in: 0...1), y: .random(in: 0...1)).node
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
    
//    let newNode = PlaneNode(frameSize: CGSize(width: 0.75, height: 0.375), xyCount: CGSize(width: 100, height: 50), diffuse: creatParticleSystemsLine())
//    newNode.position.z -= 1
//        sceneView.scene.rootNode.addChildNode(newNode)
    
//        let particleSystem1 = self.creatParticleSystemsLine()
//        let particleSystem2 = self.creatParticleSystemCircle()
    
//        sceneView.scene.rootNode.addChildNode(particleSystem1)
//        sceneView.scene.rootNode.addChildNode(particleSystem2)
}
