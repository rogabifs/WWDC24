//
//  Funcoes.swift
//  Teste2SceneKit
//
//  Created by Ronald Gabriel on 26/01/24.
//

import Foundation
import SceneKit

class ChladniFunc: Constantes {
//    override init(particles: Int, m: Float, n: Float, a: Float, b: Float, v: Float) {
//        super.init(particles: Int(), m: Float(), n: Float(), a: Float(), b: Float(), v: Float())
//        self.particles = particles
//        self.m = m
//        self.n = n
//        self.a = a
//        self.b = b
//        self.v = v
//    }
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
    
    
    func chladni(x:Float,y:Float) -> Float {
        
        
        let sin_nx: Float = sin(.pi * ChladniFunc.const_n * x)
        let sin_my: Float = sin(.pi * ChladniFunc.const_m * y)
        let sin_mx: Float = sin(.pi * ChladniFunc.const_m * x)
        let sin_ny: Float = sin(.pi * ChladniFunc.const_n * y)
        
        let result =  ChladniFunc.const_a * sin_nx * sin_my - ChladniFunc.const_b * sin_mx * sin_ny
//        print("\(Constantes.m) chladni m")
//        print("\(ChladniFunc.const_n) chladni n")
//        print("\(ChladniFunc.const_a) chladni a")
        return result
        
    }
    
    func chladniNew(x: Float, y:Float, R: Int) -> Float {
        let scaledX = x * 0.5 + ChladniFunc.TX
        let scaledY = y * 0.5 + ChladniFunc.TY
        
        let MX = ChladniFunc.const_m * scaledX + Float(R)
        let NX = ChladniFunc.n * scaledX + Float(R)
        let MY = ChladniFunc.const_m * scaledY + Float(R)
        let NY = ChladniFunc.const_n * scaledY + Float(R) 
        
        let X1 = (1 * scaledX + Float(R)) * .pi
        let N1 = 2 * scaledX + Float(R) * .pi


        var value = cos(NX) * cos(MY) - cos(MX) * cos(NY)
        
        value/=2
        value *= value < 0 ? -1 : 1
        
        
        return value
    }
}
