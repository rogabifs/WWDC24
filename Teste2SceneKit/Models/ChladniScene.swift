//
//  SetupParticles.swift
//  Teste2SceneKit
//
//  Created by Ronald Gabriel on 26/01/24.
//

import Foundation
import SceneKit
import RealityKit

class ChladniScene: SCNScene {
    static var particles: [Particles] = []
    
    func setupParticles(nParticles: Int) {
        if AnomalyView.strogAnomay == false && AnomalyView.weakAnomaly == true {
            for _ in 0..<nParticles {
                let particle = Particles(x: .random(in: PlaneNodeView.planeNode.position.x-0.5...(PlaneNodeView.planeNode.position.x + 0.5)) * Constantes.offset,
                                         y: .random(in: (PlaneNodeView.planeNode.position.y-0.5)...PlaneNodeView.planeNode.position.y + 0.5) * Constantes.offset,
                                         z: -( Float(10) * Particles.z))
                ChladniScene.particles.append(particle)
                rootNode.addChildNode(particle.node)
            }
        } else if AnomalyView.strogAnomay == true && AnomalyView.weakAnomaly == false {
            for _ in 0..<nParticles {
                let particle = Particles(x: 0,
                                         y: .random(in: (PlaneNodeView.planeNode.position.y-0.5)...PlaneNodeView.planeNode.position.y + 0.5) * Constantes.offset,
                                         z: -( Float(10) * Particles.z))
                ChladniScene.particles.append(particle)
                rootNode.addChildNode(particle.node)
            }
        }
    }
    
    public func moveParticles(chladni: ChladniFunc)  {
        for particle in ChladniScene.particles {
            var actions: [SCNAction] = []
            for _ in stride(from: 0.0, to: 3.0, by: 1.5) {
                let updatedPosition = particle.mov(chladni: chladni)
                let moveAction = SCNAction.move(to: SCNVector3(x: updatedPosition.x,
                                                               y: updatedPosition.y,
                                                               z: -(Float(10) * Particles.z)),
                                                duration: 0.5)
                actions.append(moveAction)
            }
            let sequenceAction = SCNAction.sequence(actions)
            particle.node.runAction(sequenceAction)
            rootNode.addChildNode(particle.node)
            }
        }
    
    private func equationFunction(time: Double) -> (x: Double, y: Double, z: Double) {
        let radius = 1.0
        let x = radius * cos(time)
        let y = radius * sin(time)
        let z = 0.0
        return (x, y, z)
    }

    
    public func movFromEq(duration: Double, timeStep: Double) {
        var actions: [SCNAction] = []
        
        for t in stride(from: 0.0, to: duration, by: timeStep) {
            let position = equationFunction(time: t)
            let moveAction = SCNAction.move(to: SCNVector3(position.x, position.y, position.z), duration: timeStep)
            actions.append(moveAction)
        }
        
        let sphere = SCNSphere(radius: 0.05)
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position.z -= 1.5
        
        let sequenceAction = SCNAction.sequence(actions)
        sphereNode.runAction(sequenceAction)
        rootNode.addChildNode(sphereNode)
    }
}

