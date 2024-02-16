//
//  PlaneNodeView.swift
//  Teste2SceneKit
//
//  Created by Ronald Gabriel on 15/02/24.
//

import Foundation
import SceneKit
import ARKit


class PlaneNodeView {
    let darkOverlayPlaneGeometry = SCNPlane(width: 50.0 ,height:50.0)
    let darkOverlayMaterial = SCNMaterial()
    
    let planeGeometry = SCNPlane(width: 1.0, height: 1.0)
    static var planeNode = SCNNode()
    let material = SCNMaterial()
    
    init() {
        darkOverlayMaterial.diffuse.contents = UIColor.black.withAlphaComponent(0.9)
        darkOverlayPlaneGeometry.materials = [darkOverlayMaterial]  
        material.diffuse.contents = UIColor.white.withAlphaComponent(0.8)
        planeGeometry.materials = [material]
        PlaneNodeView.planeNode = SCNNode(geometry: planeGeometry)
    }
    
    func addPlaneNode(sceneView: ARSCNView) {
        
        //Torna a tela escura
        let darkOverlayPlaneNode = SCNNode(geometry: darkOverlayPlaneGeometry)
        sceneView.scene.rootNode.addChildNode(darkOverlayPlaneNode)
        darkOverlayPlaneNode.position.z = -2.5
        
        // Cria o plano no qual as particulas serão plotadas
        PlaneNodeView.planeNode.position.z = -2
        sceneView.scene.rootNode.addChildNode(PlaneNodeView.planeNode)
        
    }
}
