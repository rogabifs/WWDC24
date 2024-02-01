//
//  ViewController.swift
//  Teste2SceneKit
//
//  Created by Ronald Gabriel on 25/01/24.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var slider_m: UISlider!
    
    @IBOutlet weak var slider_n: UISlider!
    
    @IBOutlet weak var slider_a: UISlider!
    
    @IBOutlet weak var slider_b: UISlider!
    
    @IBOutlet weak var slider_v: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        
        // Config dos Sliders
        var consts = Constantes(particles: Int(), m: Float(), n: Float(), a: Float(), b: Float(), v: Float())
        let chladni = ChladniFunc(particles: 2000, m: 3.0, n: 3.0, a: 0.02, b: 0.002, v: 0.002)
        
        sliderConfig(slider: slider_m, const: consts.m)
        sliderConfig(slider: slider_n, const: consts.n)
        sliderConfig(slider: slider_a, const: consts.a)
        sliderConfig(slider: slider_b, const: consts.b)
        sliderConfig(slider: slider_v, const: consts.v)        
        
        // Create a new scene
        let scene = ChladniScene()
        Scene(scene: scene)
        
        // Set the scene to the view
        sceneView.scene = scene
        
        
        SceneView(sceneView: sceneView, scene: scene)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        let scene = ChladniScene()
        
        let const = Constantes(particles: Int(), m: Float(), n: Float(), a: Float(), b: Float(), v: Float())
        let chladni = ChladniFunc(particles: Int(), m: Float(), n: Float(), a: Float(), b: Float(), v: Float())
        

        // Run the view's session
        sceneView.session.run(configuration)
        sceneView.play {
            scene.moveParticles(chladni: chladni)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {     // PRECISA SER AJUSTADO
        // All future code will go inside this method if not stated otherwise
        
        
        
        guard let location = touches.first?.location(in: sceneView) else {
            // In a production app we should provide feedback to the user here
            print("Couldn't find a touch")
            return
        }
        
        let hitResults = sceneView.hitTest(location, options: [:])
        if hitResults.count > 0 {
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
           
        
        guard let query = sceneView.raycastQuery(from: location, allowing: .estimatedPlane, alignment: .horizontal) else {
            // In a production app we should provide feedback to the user here
            print("Couldn't create a query!")
            return
        }
        
        guard let result = sceneView.session.raycast(query).first else {
            print("Couldn't match the raycast with a plane.")
            return
        }
        
        let particleSystem = creatParticleSystemsLine()
        particleSystem.transform = SCNMatrix4(result.worldTransform)
        
        sceneView.scene.rootNode.addChildNode(particleSystem)

    }
    
    public func creatParticleSystemsLine() -> SCNNode {
        
        // Creating particles
        let particleSystem1 = SCNParticleSystem()
        particleSystem1.birthRate = 20
        particleSystem1.particleLifeSpan = 1
        particleSystem1.particleImage = UIImage(named: "Image")
//        particleSystem1.particleColor = .orange
        particleSystem1.particleSize = 0.05
        particleSystem1.particleVelocity = 0.01
//        particleSystem1.speedFactor = 7
        particleSystem1.emittingDirection = SCNVector3(0,0,1)
        particleSystem1.emitterShape = .some(SCNBox(width: 0, height: 1, length: 0, chamferRadius: 0.5))
        
        let particlesNode1 = SCNNode()
        particlesNode1.scale = SCNVector3(1,1,1)
        particlesNode1.position.z -= 1.5
        particlesNode1.addParticleSystem(particleSystem1)
        
        return particlesNode1
        
    }
    
    public func creatParticleSystemCircle() -> SCNNode {
        let particleSystem2 = SCNParticleSystem()
        
        particleSystem2.birthRate = 20
        particleSystem2.particleLifeSpan = 1
        particleSystem2.particleImage = UIImage(named: "Image")
//        particleSystem2.particleColor = .blue
        particleSystem2.particleSize = 0.05
        
        particleSystem2.particleVelocity = 0.01
//        particleSystem2.speedFactor = 0.01
        particleSystem2.emittingDirection = SCNVector3(0.5,0.5,0.5)
        particleSystem2.emitterShape = .some(SCNTorus(ringRadius: 0.5, pipeRadius: 0))
                
        let particlesNode2 = SCNNode()
        particlesNode2.scale = SCNVector3(0.5,0.5,0.5)
        particlesNode2.position.z -= 1.5
        particlesNode2.addParticleSystem(particleSystem2)
        
        return particlesNode2
    }
    
    private func createCubeNode() -> SCNNode {
        // create the basic geometry of the box (sizes are in meters)
        let boxGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)

        // give the box a material to make a little more realistic
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue
        material.specular.contents = UIColor(white: 0.6, alpha: 1.0)

        // create the node and give it the materials
        let boxNode = SCNNode(geometry: boxGeometry)
        boxNode.geometry?.materials = [material]

        return boxNode
    }
    
    private func sliderConfig(slider: UISlider, const: Float) {
        slider.minimumValue = 0.0
        slider.maximumValue = 1000.0
        slider.value = Float(const)
        
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        print("\(slider) was changed")
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
            // Atualizar o valor de m com base no valor atual do slider
        var consts = Constantes(particles: Int(), m: Float(), n: Float(), a: Float(), b: Float(), v: Float())
        switch sender {
            case slider_m:
            consts.m = Float(Int(sender.value))
            case slider_n:
            consts.n = Float(Int(sender.value))
            case slider_a:
            consts.a = Float(Int(sender.value))
            case slider_b:
            consts.b = Float(Int(sender.value))
            case slider_v:
            consts.v = Float(Int(sender.value))
            default:
                break
            }
        }
}
