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
    
    // その月の月をInt型の配列で返す関数
    private func generateDates(for date: Date) -> [Int?] {
        let range = calendar.range(of: .day, in: .month, for: date)!
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let leadingEmptyDays = (1..<firstWeekday).map { _ in Optional<Int>.none }
        let days = range.map { $0 }
        let currentCellCount = leadingEmptyDays.count + days.count
        let trailingEmptyDays = (currentCellCount < 42 ? (1...(42 - currentCellCount)).map { _ in Optional<Int>.none } : [])
        return leadingEmptyDays + days + trailingEmptyDays
    }
}
#Preview {
    YesCalendarView()
}
