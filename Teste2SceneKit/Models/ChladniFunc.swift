//
//  Funcoes.swift
//  Teste2SceneKit
//
//  Created by Ronald Gabriel on 26/01/24.
//

import Foundation
import SceneKit
import Accelerate

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
    

    

    func calculateValuesForParticles(xValues: [Float], yValues: [Float], R: Float) -> [Float] {
        let count = vDSP_Length(xValues.count)
        
        // Preparar os arrays para armazenar os resultados
        var results = [Float](repeating: 0, count: xValues.count)
        var NX = [Float](repeating: 0, count: xValues.count)
        var MY = [Float](repeating: 0, count: xValues.count)
        var MX = [Float](repeating: 0, count: xValues.count)
        var NY = [Float](repeating: 0, count: xValues.count)
        
        // Calcular os valores escalares necessários
        var scaledXValues = [Float](repeating: 0, count: xValues.count)
        var scaledYValues = [Float](repeating: 0, count: xValues.count)
        
        var const_m = ChladniFunc.const_m
        var const_n = ChladniFunc.const_n
        
        vDSP_vsadd(xValues, 1, [ChladniFunc.TX], &scaledXValues, 1, count)
        vDSP_vsadd(yValues, 1, [ChladniFunc.TY], &scaledYValues, 1, count)
        
        vDSP_vsmul(scaledXValues, 1, &const_m, &MX, 1, count)
        vDSP_vsmul(scaledYValues, 1, &const_n, &NY, 1, count)
        
        vDSP_vsadd(MX, 1, [R], &MX, 1, count)
        vDSP_vsadd(NX, 1, [R], &NX, 1, count)
        vDSP_vsadd(MY, 1, [R], &MY, 1, count)
        vDSP_vsadd(NY, 1, [R], &NY, 1, count)
        
        // Calcular os valores finais
        var cosNX = [Float](repeating: 0, count: xValues.count)
        var cosMY = [Float](repeating: 0, count: xValues.count)
        var cosMX = [Float](repeating: 0, count: xValues.count)
        var cosNY = [Float](repeating: 0, count: xValues.count)
        
        vvcosf(&cosNX, NX, [Int32(xValues.count)])
        vvcosf(&cosMY, MY, [Int32(xValues.count)])
        vvcosf(&cosMX, MX, [Int32(xValues.count)])
        vvcosf(&cosNY, NY, [Int32(xValues.count)])
        
        // Calcular os valores finais da equação
        for i in 0..<xValues.count {
            results[i] = (cosNX[i] * cosMY[i] - cosMX[i] * cosNY[i]) / 2
            results[i] *= results[i] < 0 ? -1 : 1
        }
        
        return results
    }


    
}
