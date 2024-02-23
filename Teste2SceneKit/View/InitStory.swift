//
//  InitStory.swift
//  Teste2SceneKit
//
//  Created by Ronald Gabriel on 22/02/24.
//

import SwiftUI

struct InitStory: View {
    let storytelling = StorytellingView()
    var body: some View {
        NavigationView {
            VStack {
                Text("Attention! ")
                    .font(.largeTitle)
                Text("Open this message urgently!")
                    .font(.title)
                NavigationLink(destination: StorytellingView()) {
                    Text("View Message")
                        .font(.title2)
                }
                .padding()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .padding()
    }
}

#Preview {
    InitStory()
}
