//
//  YesLogView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/05/30.
//

import SwiftUI

struct YesLogView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("戻る")
                }
                .foregroundColor(.black)
            }
        }
    }
}

#Preview {
    YesLogView()
}
