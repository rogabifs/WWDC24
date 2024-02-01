//
//  PlaneNode.swift
//  Teste2SceneKit
//
//  Created by Ronald Gabriel on 29/01/24.
//

import Foundation
import SceneKit

class PlaneNode: SCNNode {
    private var xyCount: CGSize
    private var geometrySize: CGSize
    private var vertex: [SCNVector3]
    private var index: SCNGeometryElement
    var material = SCNMaterial()
    private var textureCoord: SCNGeometrySource
    
    public init(frameSize: CGSize, xyCount: CGSize, diffuse: Any? = UIColor.white) {
        let (vertx, textureMap, indx) = SCNGeometry.PlaneParts(size: frameSize, xyCount: xyCount)
        self.xyCount = xyCount
        self.geometrySize = frameSize
        self.vertex = vertx
        self.index = indx
        self.material.diffuse.contents = diffuse
        self.textureCoord = textureMap
        super.init()
        self.updateGeometry()
    }
    
    private func updateGeometry() {
        let src = SCNGeometrySource(vertices: vertex)
        let geo = SCNGeometry(sources: [src, self.textureCoord], elements: [self.index])
        geo.materials = [self.material]
        self.geometry = geo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
