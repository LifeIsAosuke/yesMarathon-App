//
//  YesCalenderView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/06/01.
//

import SwiftUI

struct YesCalenderView: View {
    
    // 今日の日付を取得
    @State private var displayedDate: Date = Date()
    
    // 現在のカレンダー情報を取得
    let calendar = Calendar.current
    
    // 表示するカレンダーのフォーマットを指定
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        return formatter
    } ()
    
    
    var body: some View {
        
        VStack {
            HStack {
                // 前月のカレンダーを表示するボタン
                Button(action: showPreviousMonth) {
                    Text("<")
                }
                
                Spacer()
                
                // 現在の年月を表示
                Text(displayedDate, formatter: dateFormatter)
                
                Spacer()
                
                // 来月のカレンダーを表示するボタン
                Button(action: showNextMonth) {
                    Text(">")
                }
            }
            .foregroundColor(.black)
            .font(.title)
            .bold()
            .padding()
            
            // 曜日ヘッダー
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Stu"], id: \.self) { day in
                    Text(day)
                        .bold()
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
            
            // 日付グリッド
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(generateDates(for: displayedDate), id: \.self) { date in
                    if let date = date {
                        Text("\(date)")
                            .frame(width: 40, height: 40)
                    } else {
                        Spacer()
                            .frame(width: 40, height: 40)
                    }
                }
            }
        }
        .padding()
    }
    
    // 先月のカレンダー情報を取得
    private func showPreviousMonth() {
        if let previousMonth = calendar.date(byAdding: .month, value: -1, to: displayedDate) {
            displayedDate = previousMonth
        }
    }
    
    // 来月のカレンダー情報を取得
    private func showNextMonth() {
        if let nextMonth = calendar.date(byAdding: .month, value: 1, to: displayedDate) {
            displayedDate = nextMonth
        }
    }
    
    // 今月のカレンダー情報を取得
    private func generateDates(for date: Date) -> [Int?] {
        
        // その月が何日までなのかの情報を取得
        let range = calendar.range(of: .day, in: .month, for: date)!
        
        // 月初の日にちを取得
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        
        // 月初の曜日情報をInt型で取得
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        // 前月分の空白セル
        let leadingEmptyDays = (1..<firstWeekday).map {_ in Optional<Int>.none}
        
        // 今月の表示セル
        let days = range.map {$0}
        
        // 来月分の空白セル
        let trailingCount = (7 - (leadingEmptyDays.count + days.count) % 7)
        let trailingEmptyDays = (trailingCount < 7 ? (1...trailingCount).map {_ in Optional<Int>.none} : [])
        
        // 全体の配列を作成
        return leadingEmptyDays + days + trailingEmptyDays
    }
}

#Preview {
    YesCalenderView()
}
