//
//  DetailView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/06/01.
//

import SwiftUI

struct DetailView: View {
    
    //　その日の日付
    let displayedDate: Date
    
    // 対応するデータを取得
    let matchingData: EachDayData!
    
    // 現在のカレンダーを取得
    let calendar = Calendar.current

    // 取得したカレンダーのフォーマットを指定
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月DD日"
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(displayedDate, formatter: dateFormatter)
                    .padding()
                
                Text(matchingData.yesTitle)
                    .font(.title)
                
                Divider()
                
                Group {
                    HStack {
                        Image(systemName: "text.justify.left")
                            .frame(width: 25, height: 25)
                        Text("コメント")
                            .font(.system(size: 14))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    Text(matchingData.comment)
                        .frame(height: 40)
                        .padding()
                }
                
                Divider()
                
                // YES評価
                VStack {
                    HStack {
                        Image(systemName: "star")
                        Text("YES評価")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    HStack {
                        // 色塗りスターの表示
                        ForEach(0..<matchingData.yesEvaluation, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(Color(red: 253 / 255.0, green: 202 / 255.0, blue: 0 / 255.0))
                        }
                        
                        // 外縁スターの表示
                        ForEach(0..<5-matchingData.yesEvaluation, id: \.self) { _ in
                            Image(systemName: "star")
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    
                }
                .foregroundColor(.black)
                
                Divider()
                
                HStack {
                    Image(systemName: "photo")
                    Text("画像")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
            }
        }
    }
}
