//
//  AchievedView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/05/29.
//

import SwiftUI

struct AchievedView: View {
    var body: some View {
        VStack {
            Text("本日のYES達成！")
                .font(.title)
//                .frame(maxWidth: .infinity, alignment: .leading)
                .bold()
                .padding()
            Image("achievedIcon")
                .resizable()
                .frame(width: 237, height: 258)
                .padding()
            Text("また明日も頑張ろう")
                .bold()
                .padding()
        }
        .padding()
    }
}

#Preview {
    AchievedView()
}
