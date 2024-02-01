//
//  SetupParticles.swift
//  Teste2SceneKit
//
//  Created by Ronald Gabriel on 26/01/24.
//

import Foundation
import SceneKit

class ChladniScene: SCNScene {
    var particles: [Particles] = []
    
    func setupParticles(nParticles: Int) {
        for _ in 0..<nParticles {
            let particle = Particles(x: .random(in: 0...1), y: .random(in: 0...1)) // Arrumar
            particles.append(particle) // Arrumar
            rootNode.addChildNode(particle.node)
        }
    }
    
    func moveParticles(chladni: ChladniFunc) {
        for particle in particles {
            particle.mov(chladni: chladni)
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
        
//        let scene = SCNScene()
        let sphere = SCNSphere(radius: 0.05)
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position.z -= 1.5
        
        
        
        let sequenceAction = SCNAction.sequence(actions)
        sphereNode.runAction(sequenceAction)
        rootNode.addChildNode(sphereNode)
    }
}

