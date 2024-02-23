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

//    public func findMN(forW w: Double) -> (Int, Int)? {
//        let maxMN = 10 // Valor máximo para m e n
//        let tolerance = 0.01 // Tolerância para comparar valores
//        
//        for m in 1...maxMN {
//            for n in 1...maxMN {
//                let calculatedW = Double.pi * sqrt(Double(1000*(m * m + n * n)))
//                if abs(calculatedW - w) < tolerance {
//                    return (m, n)
//                }
//            }
//        }
//        
//        return nil // Se nenhum valor for encontrado dentro da tolerância
//    }
    
//    public func findMN(forW w: Double) -> (Int, Int)? {
//        let maxMN = max(1,Int(sqrt(w / (.pi * 1000)))) // Limita o intervalo de busca com base em w
//        let tolerance = 0.01 // Tolerância para comparar valores
//        
//        for m in 1...maxMN {
//            let tempValue = (w / (.pi * 1000)) - Double(m * m)
//            let nStart: Int
//            if tempValue >= 0 {
//                nStart = max(1, Int(sqrt(tempValue)))
//            } else {
//                nStart = 1 // Define nStart como 1 se o valor dentro da raiz quadrada for negativo
//            }
//            for n in nStart...maxMN {
//                let calculatedW = Double.pi * sqrt(Double(1000 * (m * m + n * n)))
//                if abs(calculatedW - w) < tolerance {
//                    return (m, n)
//                }
//            }
//        }
//        
//        return nil // Se nenhum valor for encontrado dentro da tolerância
//    }
    

    public func findMN(forW w: Double) -> (Int, Int)? {
        let maxMN = max(1, Int(sqrt(w / (.pi * 1000)))) // Limita o intervalo de busca com base em w
        let tolerance = 100.0 // Tolerância para comparar valores
        
        var mValues = [Double](repeating: 0, count: maxMN)
        for i in 0..<maxMN {
            mValues[i] = Double(i + 1) // Preenche o vetor mValues com os valores de m
        }
        
        var mSquared = [Double](repeating: 0, count: maxMN)
        var nStart = [Double](repeating: 0, count: maxMN)
        
        // Calcula o quadrado de cada valor de m
        vDSP_vsqD(mValues, 1, &mSquared, 1, vDSP_Length(maxMN))
        
        // Calcula w / (.pi * 1000)
        var tempValue = w / (.pi * 1000)
        var tempCopy = tempValue
        // Subtrai os quadrados de mValues de tempValue
        vDSP_vsaddD(mSquared, 1, &tempValue, &tempCopy, vDSP_Stride(vDSP_Length(Int(maxMN))), vDSP_Length(Int(maxMN)))


        // Calcula a raiz quadrada de tempValue para obter nStart
        vvsqrt(&nStart, &tempValue, [Int32(maxMN)])
        
        for i in 0..<maxMN {
            nStart[i] = max(nStart[i], 1) // Define nStart como 1 se o valor dentro da raiz quadrada for negativo
        }
        
        for m in 1...maxMN {
            for n in Int(nStart[m-1])...maxMN {
                let mSquared = Double(m * m)
                let nSquared = Double(n * n)
                let sumSquared = mSquared + nSquared
                let multipliedSum = 1000 * sumSquared
                let squaredResult = sqrt(multipliedSum)
                let calculatedW = Double.pi * squaredResult
                if abs(calculatedW - w) < tolerance {
                    return (m, n)
                }
            }
        }
        
        return nil // Se nenhum valor for encontrado dentro da tolerância
    }
    
    func chooseRandom(value_1: Int, value_2: Int) -> Int {
        let randomIndex = Int.random(in:0...1)
        if randomIndex == 0 {
            return value_1
        } else {
            return value_2
        }
    }
    
    func atributeToParamt(value_1: Int, value_2: Int) {
        ChladniFunc.const_m = Float(chooseRandom(value_1: value_1, value_2: value_2))
        if  ChladniFunc.const_m == Float(value_2) {
            ChladniFunc.const_n = Float(value_1)
        } else {
            ChladniFunc.const_n = Float(value_2)
        }
    }
    
    func chladniAtribute(frequency: Double) {
        if frequency >= 0 && frequency <= 200 {
            atributeToParamt(value_1: 1, value_2: 1)
        } else if frequency >= 201 && frequency <= 400 {
            atributeToParamt(value_1: 2, value_2: 2)
        } else if frequency >= 401 && frequency <= 600 {
            atributeToParamt(value_1: 4, value_2: 4)
        } else if frequency >= 601 && frequency <= 800 {
            atributeToParamt(value_1: 5, value_2: 5)
        } else if frequency >= 801 && frequency <= 1000 {
            atributeToParamt(value_1: 6, value_2: 6)
        }
    }  
}
