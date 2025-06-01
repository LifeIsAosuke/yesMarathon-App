//
//  YesCalendarView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/06/01.
//

import SwiftUI

struct YesCalendarView: View {
    // 現在の日付を取得
    @State private var displayedDate: Date = Date()
    // 現在のカレンダーを取得
    let calendar = Calendar.current
    
    // 取得したカレンダーのフォーマットを指定
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        return formatter
    }()

    var body: some View {
        VStack {
            HStack {
                // 先月のカレンダー情報を取得するボタン
                Button(action: { changeMonth(by: -1) }) {
                    Text("<")
                }
                Spacer()
                // 現在の年月
                Text(displayedDate, formatter: dateFormatter)
                    .font(.title)
                    .bold()
                Spacer()
                // 来月のカレンダー情報を取得するボタン
                Button(action: { changeMonth(by: 1) }) {
                    Text(">")
                }
            }
            .foregroundColor(.black)
            .padding()
            
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .bold()
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 8)
            
            GeometryReader { geometry in
                // セルの大きさを取得
                let cellSize = geometry.size.width / 7
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 0) {
                    ForEach(generateDates(for: displayedDate), id: \.self) { date in
                        if let date = date {
                            Text("\(date)")
                                .frame(width: cellSize, height: cellSize)
                        } else {
                            Spacer()
                                .frame(width: cellSize, height: cellSize)
                        }
                    }
                }
            }
            .frame(height: 300) // 高さを固定
        }
        .padding()
        .animation(.easeInOut, value: displayedDate) // アニメーションを追加
    }
    
    // 表示する月の変更
    private func changeMonth(by offset: Int) {
        if let newDate = calendar.date(byAdding: .month, value: offset, to: displayedDate) {
            displayedDate = newDate
        }
    }
    
    // 指定した月の日付を生成し、空白セルを含む配列として返す関数
    private func generateDates(for date: Date) -> [Int?] {
        // 現在の月の日数を取得
        let range = calendar.range(of: .day, in: .month, for: date)!
        
        // 月初の日付を取得
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        
        // 月初の曜日を取得 (1: 日曜, 2: 月曜, ...)
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        // 先頭の空白セルを生成
        let leadingEmptyDays = Array(repeating: Optional<Int>.none, count: firstWeekday - 1)
        
        // 現在の月の日付を生成
        let days = range.map { $0 }
        
        // 必要なセル数を計算
        let totalCells = leadingEmptyDays.count + days.count
        let trailingEmptyDaysCount = (7 - (totalCells % 7)) % 7
        
        // 末尾の空白セルを生成
        let trailingEmptyDays = Array(repeating: Optional<Int>.none, count: trailingEmptyDaysCount)
        
        // 先頭の空白セル、日付、末尾の空白セルを結合して返す
        return leadingEmptyDays + days + trailingEmptyDays
    }
}
#Preview {
    YesCalendarView()
}
