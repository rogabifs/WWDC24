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
    
    @IBOutlet weak var slider_v: UISlider!
    
    let scene = ChladniScene()
    

    override func viewDidLoad() {
        super.viewDidLoad()      
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        sceneView.addGestureRecognizer(pinchGesture)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Config dos Sliders
        sliderConfig(slider: slider_m, const: Constantes.m)
        sliderConfig(slider: slider_n, const: Constantes.n)
        sliderConfig(slider: slider_v, const: Constantes.v)
        
        // Create a new scene
        Scene(scene: scene)
        
        // Set the scene to the view
        sceneView.scene = scene
        
        SceneView(sceneView: sceneView, scene: scene)
        
        setupObservers()
        
      
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()


        // Run the view's session
        sceneView.session.run(configuration)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }

    
    private func sliderConfig(slider: UISlider, const: Float) {
        slider.minimumValue = 1.0
        slider.maximumValue = 10.0
        slider.value = Float(const)
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
            // Atualizar o valor de m com base no valor atual do slider
        
        switch sender {
            case slider_m:
            Constantes.m = Float(Int(sender.value))
            ChladniFunc.const_m = Constantes.m
            NotificationCenter.default.post(name: ChladniFunc.mDidChangeNotification, object: nil)
            
            case slider_n:
            Constantes.n = Float(Int(sender.value))
            ChladniFunc.const_n = Constantes.n
            NotificationCenter.default.post(name: ChladniFunc.nDidChangeNotification, object: nil)
        
            case slider_v:
            Constantes.v = Float(Int(sender.value))
            NotificationCenter.default.post(name: ChladniFunc.vDidChangeNotification, object: nil)
            
            default:
                break
            }
        }
    
    // Método para tratar as notificações
      func setupObservers() {
          NotificationCenter.default.addObserver(self, selector: #selector(chladniDidChange), name: ChladniFunc.mDidChangeNotification, object: nil)
          
          NotificationCenter.default.addObserver(self, selector: #selector(chladniDidChange), name: ChladniFunc.nDidChangeNotification, object: nil)
          
          NotificationCenter.default.addObserver(self, selector: #selector(chladniDidChange), name: Particles.zDidChangeNotification, object: nil)
                    
          NotificationCenter.default.addObserver(self, selector: #selector(chladniDidChange), name: ChladniFunc.vDidChangeNotification, object: nil)
   
      }
    
    // Método chamado quando os sliders mudam
    @objc func chladniDidChange() {
        // Chame a função chladni com os valores atualizados
        let chladni = ChladniFunc()
        scene.moveParticles(chladni: chladni)
        
    }
    
    @objc func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        if gestureRecognizer.state == .changed {
            // Atualiza a variável zoomScale multiplicando-a pelo fator de escala do gesto de pinça
            Particles.z /= Float(gestureRecognizer.scale)
            Particles.zisChange = true
            NotificationCenter.default.post(name: Particles.zDidChangeNotification, object: nil)
            // Redefine o fator de escala do gesto de pinça para evitar aumentos exponenciais
            gestureRecognizer.scale = 1.0

            // Faça algo com a variável zoomScale, por exemplo, atualize a escala de uma view

        }
    }
}
