//
//  ContentView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/05/30.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // データベースから情報を取得
//    @Query private var dayChangeManager: [DayChangeManager]
    @Environment(\.modelContext) private var modelContext
    
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
            
            let dayChangeManager = DayChangeManager(isTrue: isTrue)
            modelContext.insert(dayChangeManager)
            
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
