//
//  ContentView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/05/30.
//

import SwiftUI

struct ContentView: View {
    @State private var isTrue: Bool = false
    @State private var yesLabel: String = YesSuggestion().random()
    @State private var currentDate: Date = Date()
    @State private var forceUpdate: Bool = false

    let yesSuggestion = YesSuggestion()

    var body: some View {
        Group {
            if isTrue {
                AchievedView()
            } else {
                HomeView(isTrue: $isTrue, yesLabel: $yesLabel)
            }
        }
        .onAppear {
            startTemporaryFalseReset()
            startYesLabelUpdate()
        }
    }

    func startTemporaryFalseReset() {
        let timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            isTrue = false
            forceUpdate.toggle()
        }
        RunLoop.current.add(timer, forMode: .common)
    }

    func startYesLabelUpdate() {
        let timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            yesLabel = yesSuggestion.random()
        }
        RunLoop.current.add(timer, forMode: .common)
    }
}


#Preview {
    ContentView()
}
