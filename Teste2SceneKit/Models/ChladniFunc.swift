//
//  Funcoes.swift
//  Teste2SceneKit
//
//  Created by Ronald Gabriel on 26/01/24.
//

import Foundation
import SceneKit

class ChladniFunc: Constantes {

    static var const_a = Float()
    static var const_b = Float()
    static var const_m = Float()
    static var const_n = Float()
    static var TX: Float = .random(in: 0...1) * 1
    static var TY: Float =  .random(in: 0...1) * 1
    
    // Adiciona uma notificação para cada slider
        static let mDidChangeNotification = Notification.Name("mDidChange")
        static let nDidChangeNotification = Notification.Name("nDidChange")
        static let vDidChangeNotification = Notification.Name("vDidChange")
    
    
    func chladni(x: Float, y:Float, R: Int) -> Float {
        let scaledX = x * 0.5 + ChladniFunc.TX
        let scaledY = y * 0.5 + ChladniFunc.TY
        
        let MX = ChladniFunc.const_m * scaledX + Float(R)
        let NX = ChladniFunc.n * scaledX + Float(R)
        let MY = ChladniFunc.const_m * scaledY + Float(R)
        let NY = ChladniFunc.const_n * scaledY + Float(R) 
        
        var value = cos(NX) * cos(MY) - cos(MX) * cos(NY)
        
        value/=2
        value *= value < 0 ? -1 : 1
        
        
        return value
    }
}
