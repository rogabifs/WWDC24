//
//  SwiftUIViewTeste.swift
//  Teste2SceneKit
//
//  Created by Ronald Gabriel on 22/02/24.
//

import SwiftUI

struct StorytellingView: View {
    @State var displayedText = ""
    @State var stanza = 1
    @State var isNextButtonVisible = false
    @State var currentTextIndex = 0
    
    let textClass = TextClass()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16.0) {
                VStack(spacing: 600.0) {
                    Text(displayedText)
                    if stanza < 2 {
                        Button("Iniciar") {
                            typeWriter()
                            stanza += 1
                        }
                    } else {
                        //
                    }
                    
                    if isNextButtonVisible {
                        if stanza == 8 {
                            Button("Ir para AR") {
                                //
                            }
                        } else {
                            Button("Próximo") {
                                typeWriter()
                                stanza += 1
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    func typeWriter() {
        guard currentTextIndex < 7 else { return }
        
        let newText: String
        switch stanza {
        case 1: newText = textClass.text1
        case 2: newText = textClass.text2
        case 3: newText = textClass.text3
        case 4: newText = textClass.text4
        case 5: newText = textClass.text5
        case 6: newText = textClass.text6
        case 7: newText = textClass.text7
        default: newText = ""
        }
        
        currentTextIndex += 1
        showText(text: newText)
    }
    
    func showText(text: String, position: Int = 0) {
        guard position < text.count else {
            isNextButtonVisible = true
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
            let nextChar = text[text.index(text.startIndex, offsetBy: position)]
            displayedText += String(nextChar)
            self.showText(text: text, position: position + 1)
        }
    }
}



#Preview {
    StorytellingView()
}

