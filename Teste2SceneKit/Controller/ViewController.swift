//
//  ViewController.swift
//  Teste2SceneKit
//
//  Created by Ronald Gabriel on 25/01/24.
//

import UIKit
import SceneKit
import ARKit


class ViewController: UIViewController, ARSCNViewDelegate{

    @IBOutlet var sceneView: ARSCNView!

    var count = 0
    
    @IBAction func button_Count(_ sender: UIButton) {
        count += 1
        if count < 3 {
            button_nextAnomaly.isHidden = true
            print(count)
        } else {
            button_nextAnomaly.isHidden = false
        }
    }
    
    
    @IBOutlet weak var button_nextAnomaly: UIButton!

    @IBOutlet weak var slider_m: UISlider!
    
    @IBOutlet weak var slider_n: UISlider!
    
    @IBOutlet weak var slider_v: UISlider!
    
    @IBOutlet weak var button_m: UIButton!
    
    @IBOutlet weak var button_n: UIButton!
    
    @IBOutlet weak var button_v: UIButton!
    
    @IBOutlet weak var button_f: UIButton!
    
    @IBOutlet weak var slider_f: UISlider!
    
    
    @IBOutlet weak var resetPlanSymbol: UIImageView!
    
    
    @IBOutlet weak var resetPlanButton: UIButton!
    
    
    @IBOutlet weak var changeColorSymbol: UIImageView!
    
    
    @IBOutlet weak var changeColorButton: UIButton!
    
    
    @IBOutlet weak var blueColorButton: UIButton!
    
    @IBOutlet weak var blackColorButton: UIButton!
    
    @IBOutlet weak var whiteColorButton: UIButton!
    
    @IBOutlet weak var redColorButton: UIButton!
    
    @IBOutlet weak var yellowColorButton: UIButton!
    
    @IBOutlet weak var text: UILabel!
    
    let scene = ChladniScene()
    
    var slidersisActive = true
    
    var initialAngle: CGFloat = 0.0
    
    var isTwoFingerPan = false
    
    var aux = 0
    
    var willchangeColor = true
    
    var nextAnomaly = false {
        didSet {
            if nextAnomaly {
                AnomalyView.weakAnomaly = false
                AnomalyView.strogAnomay = true
                isActiveCoaching = true
                count = 0
                DispatchQueue.main.async {
                    self.loadViewIfNeeded()
                    self.resetScene()
                    self.viewDidLoad()
                }
            }
        }
    }
    
    var isActiveCoaching = true  {
        didSet {
            if !isActiveCoaching && aux < 2 {
                DispatchQueue.main.async {
                    self.loadViewIfNeeded()
                    self.viewDidLoad()
                }
            }
        }
    }
    
    var isChladniScene = false {
        didSet {
            if !isChladniScene {
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) {_ in 
                    DispatchQueue.main.async {
                        self.updateSlidersButtonVisibility()
                    }
                }
            }
        }
    }
    
    var resetPlane = false {
        didSet {
            if resetPlane {
                isActiveCoaching = true
                DispatchQueue.main.async {
                    self.loadViewIfNeeded()
                    self.resetScene()
                    self.viewDidLoad()
                }
            }
        }
    }
    
    let planeScene = PlaneNodeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        if nextAnomaly {
            AnomalyView.weakAnomaly = false
            AnomalyView.strogAnomay = true
        } else {
            AnomalyView.weakAnomaly = true
            AnomalyView.strogAnomay = false
        }
       
        if isActiveCoaching {
            planeScene.addPlaneNode(sceneView: sceneView)
            isHidenColorButtons()
            let planNodeGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanPlanNode(_:)))
            sceneView.addGestureRecognizer(planNodeGesture)
            let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleHandleTap(_:)))
            doubleTapGesture.numberOfTapsRequired = 2
            sceneView.addGestureRecognizer(doubleTapGesture)
        } else {
            resetScene()
            isChladniScene = true
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
            sceneView.addGestureRecognizer(pinchGesture)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            tapGesture.numberOfTouchesRequired = 1
            sceneView.addGestureRecognizer(tapGesture)
            
            let panGestureTranslation = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            panGestureTranslation.maximumNumberOfTouches = 1
            sceneView.addGestureRecognizer(panGestureTranslation)
            
            //        let panRotation = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRotation(_:)))
            //        panRotation.minimumNumberOfTouches = 2
            //        panRotation.maximumNumberOfTouches = 2
            //        sceneView.addGestureRecognizer(panRotation)
            //
            
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
            resetPlanButton.addTarget(self, action: #selector(tapResetPlane), for: .touchUpInside)
            changeColorButton.addTarget(self, action: #selector(isShowChangeColor), for: .touchUpInside)
            selectColor(colorButton: blueColorButton)
            selectColor(colorButton: blackColorButton)
            selectColor(colorButton: whiteColorButton)
            selectColor(colorButton: redColorButton)
            selectColor(colorButton: yellowColorButton)
            button_nextAnomaly.addTarget(self, action: #selector(nextAnomalyfunc), for: .touchUpInside)
        }
        
        updateSlidersButtonVisibility()
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Ajusta o tamanho da sceneView
        sceneView.frame = view.bounds
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
    
    
    func resetScene() {
        // Remove todos os nodes da cena
        sceneView.scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
        
        // Aqui você pode adicionar qualquer configuração adicional necessária para reiniciar a cena
    }

    
    private func sliderConfig(slider: UISlider, const: Float) {
        slider.minimumValue = 1.0
        slider.maximumValue = 10.0
        slider.value = Float(const)
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
    }
    
    func updateSlidersButtonVisibility() {
        slider_m.isHidden = isActiveCoaching || nextAnomaly == true
        slider_n.isHidden = isActiveCoaching || nextAnomaly == true
        slider_f.isHidden = isActiveCoaching || nextAnomaly == false
        slider_v.isHidden = isActiveCoaching
        button_m.isHidden = isActiveCoaching || nextAnomaly == true
        button_n.isHidden = isActiveCoaching || nextAnomaly == true
        button_f.isHidden = isActiveCoaching || nextAnomaly == false
        button_v.isHidden = isActiveCoaching
        resetPlanButton.isHidden = isActiveCoaching
        resetPlanSymbol.isHidden = isActiveCoaching
        changeColorButton.isHidden = isActiveCoaching
        changeColorSymbol.isHidden = isActiveCoaching
        text.isHidden = !isActiveCoaching
        button_nextAnomaly.isHidden = isActiveCoaching || (count < 3)
        
    }
    
    func isHidenColorButtons() {
        blueColorButton.isHidden = !willchangeColor || isActiveCoaching
        whiteColorButton.isHidden = !willchangeColor || isActiveCoaching
        blackColorButton.isHidden = !willchangeColor || isActiveCoaching
        redColorButton.isHidden = !willchangeColor || isActiveCoaching
        yellowColorButton.isHidden = !willchangeColor || isActiveCoaching
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
            // Atualizar o valor de m com base no valor atual do slider
        if slidersisActive == true {
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
    
    @objc func nextAnomalyfunc() {
        nextAnomaly = true
        aux = 0
        
    }
    
    @objc func tapResetPlane(){
        resetPlane = true
        aux = 0
    }
    
    @objc func isShowChangeColor(){
        if !willchangeColor {
            willchangeColor = true
            isHidenColorButtons()
        } else {
            willchangeColor = false
            isHidenColorButtons()
        }
    }
    
    func selectColor(colorButton: UIButton) {
        colorButton.addTarget(self, action: #selector(setColorButton), for: .touchUpInside)
    }
    
    @objc func setColorButton(colorButton: UIButton) {
        if colorButton == blueColorButton {
            for particle in ChladniScene.particles {
                particle.node.geometry?.firstMaterial?.diffuse.contents = UIColor.systemBlue
            }
        } else if colorButton == whiteColorButton {
            for particle in ChladniScene.particles {
                particle.node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
            }
        } else if colorButton == blackColorButton {
            for particle in ChladniScene.particles {
                particle.node.geometry?.firstMaterial?.diffuse.contents = UIColor.black
            }
        } else if colorButton == redColorButton {
            for particle in ChladniScene.particles {
                particle.node.geometry?.firstMaterial?.diffuse.contents = UIColor.systemRed
            }
        } else {
            for particle in ChladniScene.particles {
                particle.node.geometry?.firstMaterial?.diffuse.contents = UIColor.systemYellow
            }
        }
    }
    
//    func changeColor() {
//        for particle in ChladniScene.particles {
//            particle.node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
//        }
//    }
    
//    func setColor()
    
    @objc func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        if gestureRecognizer.state == .changed {
            // Atualiza a variável zoomScale multiplicando-a pelo fator de escala do gesto de pinça
            Particles.z /= Float(gestureRecognizer.scale)
            Particles.zisChange = true
            NotificationCenter.default.post(name: Particles.zDidChangeNotification, object: nil)
            // Redefine o fator de escala do gesto de pinça para evitar aumentos exponenciais
            gestureRecognizer.scale = 1.0


        }
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        // Obtém o ponto de toque na SceneView
        let location = gesture.location(in: sceneView)
        
        // Realiza uma busca por nodes na posição do toque
        let hitResults = sceneView.hitTest(location, options: [:])
        
        var anySphereSelected = false
        
        // Itera sobre todas as partículas e as seleciona
        for particle in ChladniScene.particles {
            particle.isSelected = false // Reseta a seleção de todas as partículas
        }
        
        // Seleciona as partículas atingidas
        for hitResult in hitResults {
                if let node = hitResult.node as? SCNNode,
                   let particle = ChladniScene.particles.first(where: { $0.node == node }) {
                   selectAllParticles()
                    anySphereSelected = true
            }
        }
        
        deselect(anySphereSelected: anySphereSelected)
    }
    
    @objc func doubleHandleTap(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            isActiveCoaching = false
            aux = 2
        }
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        // Obtém o movimento do gesto de pan
        if isTwoFingerPan == false {
            let translation = gesture.translation(in: sceneView)
            
            // Atualiza a posição das partículas selecionadas
            for particle in ChladniScene.particles {
                if particle.isSelected {
                    particle.node.position.x += Float(translation.x) * 0.1
                    particle.node.position.y -= Float(translation.y) * 0.1
                    particle.x = particle.node.position.x
                    particle.y = particle.node.position.y
                    
                }
            }
            
            // Reseta a tradução do gesto de pan
            gesture.setTranslation(.zero, in: sceneView)
        }
    }
    
    @objc func handlePanPlanNode(_ gesture: UIPanGestureRecognizer) {
        // Obtém o movimento do gesto de pan
        if isTwoFingerPan == false {
            let translation = gesture.translation(in: sceneView)
            
            // Atualiza a posição das partículas selecionadas
            PlaneNodeView.planeNode.position.x += Float(translation.x) * 0.01
            PlaneNodeView.planeNode.position.y -= Float(translation.y) * 0.01

            // Reseta a tradução do gesto de pan
            gesture.setTranslation(.zero, in: sceneView)
        }
    }
    
//
//    @objc func handlePanGestureRotation(_ gesture: UIPanGestureRecognizer) {
//            switch gesture.state {
//            case .began:
//                if gesture.numberOfTouches == 2 {
//                    isTwoFingerPan = true
//                    let location1 = gesture.location(ofTouch: 0, in: sceneView)
//                    let location2 = gesture.location(ofTouch: 1, in: sceneView)
//                    initialAngle = atan2(location2.y - location1.y, location2.x - location1.x)
//                }
//            case .changed:
//                if isTwoFingerPan {
//                    if gesture.numberOfTouches == 2 {
//                        let location1 = gesture.location(ofTouch: 0, in: sceneView)
//                        let location2 = gesture.location(ofTouch: 1, in: sceneView)
//                        let currentAngle = atan2(location2.y - location1.y, location2.x - location1.x)
//                        let angleDelta = currentAngle - initialAngle
//                        for particle in ChladniScene.particles {
//                          if particle.isSelected {
//                              particle.node.eulerAngles.y += Float(angleDelta)
//                              particle.x = cos(particle.node.eulerAngles.y * .pi / 180)
//                              particle.zAxis = sin(particle.node.eulerAngles.y * .pi / 180)
//                              Particles.z = particle.zAxis
//                              print(particle.node.eulerAngles.y)
//                          }
//                      }
//                    initialAngle = currentAngle
//                    } else {
//                        isTwoFingerPan = false
//                    }
//                }
//            case .ended, .cancelled:
//                isTwoFingerPan = false
//            default:
//                break
//            }
//        }
//
    
    private func selectAllParticles() {
        for particle in ChladniScene.particles {
            particle.isSelected = true
            particle.node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
            slidersisActive = false
        }
    }
    
    private func deselect(anySphereSelected: Bool) {
        if !anySphereSelected {
            for particle in ChladniScene.particles {
                particle.isSelected = false
                particle.node.geometry?.firstMaterial?.diffuse.contents = UIColor.black
                slidersisActive = true
            }
        }
    }
}
