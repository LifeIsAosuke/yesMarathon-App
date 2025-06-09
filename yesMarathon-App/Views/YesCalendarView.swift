//
//  YesCalendarView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/06/01.
//

import SwiftUI
import SwiftData

struct YesCalendarView: View {
    
    
    // SwiftDataからEachData型のインスタンスを全て取得
    @Query private var eachDayDatas: [EachDayData]
    
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
        ZStack {
            
            Color.background
                .ignoresSafeArea()
            
            VStack {
                
                if calculateAchievedDays() >= 2{
                    HStack() {
                        Text("\(calculateAchievedDays())")
                            .font(.system(size: 70))
                            .foregroundColor(Color.yesOrange)

                        Text("日連続達成！！")
                            .font(.system(size: 35))
                            .alignmentGuide(.bottom) { dimension in dimension[.bottom]}
                    }
                    .bold()
                }
                
                // 一言コメント表示
                Text(showDayAchievedLabel())
                    .padding()
                
                //----------------------------------------------------------------------
                
                //ここからカレンダー表示部分
                
                // ボタンと年月表示ヘッダー
                VStack {
                    HStack {
                        // 先月のカレンダー情報を取得するボタン
                        Button(action: { changeMonth(by: -1) }) {
                            Image(systemName: "chevron.left")
                                .bold()
                        }
                        Spacer()
                        // 現在の年月
                        Text(displayedDate, formatter: dateFormatter)
                            .bold()
                        Spacer()
                        // 来月のカレンダー情報を取得するボタン
                        Button(action: { changeMonth(by: 1) }) {
                            Image(systemName: "chevron.right")
                                .bold()
                        }
                    }
                    .foregroundColor(.black)
                    .padding()
                    
                    // 曜日ヘッダー
                    HStack {
                        ForEach(["日", "月", "火", "水", "木", "金", "土"], id: \.self) { day in
                            Text(day)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.black)
                                .opacity(0.4)
                        }
                    }
                    .padding(.bottom, 8)
                    
                    Divider()
                    
                    // カレンダーの各セル
                    GeometryReader { geometry in
                        // セルの大きさを取得
                        let cellSize = geometry.size.width / 7
                        
                        //　カレンダーの各セルを表示
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 0) {
                            ForEach(Array(generateDates(for: displayedDate).enumerated()), id: \.offset) { index, date in
                                if let date = date {
                                    // Find matching EachDayData for this date
                                    let matchingData = eachDayDatas.first { eachDayData in
                                        calendar.isDate(eachDayData.day, inSameDayAs: date)
                                    }
                                    
                                    if let data = matchingData {
                                        // yesを達成した日は詳細画面に飛べるようにする
                                        NavigationLink(destination: DetailView(matchingData: data)) {
                                            VStack {
                                                ZStack {
                                                    Circle()
                                                        .frame(width: 40, height: 40)
                                                        .foregroundColor(Color.yesOrange)
                                                        .opacity(0.8)
                                                    
                                                    Text("\(calendar.component(.day, from: date))")
                                                        .font(.headline)
                                                        .foregroundColor(.white)
                                                }
                                            }
                                            .frame(width: cellSize, height: cellSize)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    } else {
                                        // それ以外は日付ラベル
                                        Text("\(calendar.component(.day, from: date))")
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                            .frame(width: cellSize, height: cellSize)
                                    }
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
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            .padding()
            .animation(.easeInOut, value: displayedDate) // アニメーションを追加
        }
    }
    
    // 表示する月の変更
    private func changeMonth(by offset: Int) {
        if let newDate = calendar.date(byAdding: .month, value: offset, to: displayedDate) {
            displayedDate = newDate
        }
    }
    
    // 指定した月の日付を生成し、空白セルを含む配列として返す関数
    private func generateDates(for date: Date) -> [Date?] {
        // 現在の月の日数を取得
        let range = calendar.range(of: .day, in: .month, for: date)!
        
        // 月初の日付を取得
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        
        // 月初の曜日を取得 (1: 日曜, 2: 月曜, ...)
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        // 先頭の空白セルを生成
        let leadingEmptyDays = Array(repeating: Optional<Date>.none, count: firstWeekday - 1)
        
        // 現在の月の日付を生成
        let days = range.map { day -> Date in
            calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)!
        }
        
        // 必要なセル数を計算
        let totalCells = leadingEmptyDays.count + days.count
        let trailingEmptyDaysCount = (7 - (totalCells % 7)) % 7
        
        // 末尾の空白セルを生成
        let trailingEmptyDays = Array(repeating: Optional<Date>.none, count: trailingEmptyDaysCount)
        
        // 先頭の空白セル、日付、末尾の空白セルを結合して返す
        return leadingEmptyDays + days.map { Optional($0) } + trailingEmptyDays
    }
    
    // 連続YES達成日数を計算する関数
    private func calculateAchievedDays() -> Int {
        // 現在の日付を取得し、時間をクリアして日付のみにする
        var currentDay = calendar.startOfDay(for: Date())
        var consecutiveCount = 0
        
        // 日付順にソートした達成データを取得
        let achievedData = eachDayDatas.sorted { $0.day > $1.day }
        
        for data in achievedData {
            // 現在のチェック日付とデータの日付を比較
            if calendar.isDate(currentDay, inSameDayAs: data.day) {
                consecutiveCount += 1
                // 次の日を過去に1日進める
                if let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDay) {
                    currentDay = previousDay
                }
            } else {
                break
            }
        }
        
        return consecutiveCount
    }
    
    private func showDayAchievedLabel() -> String {
        
        let yesAchievedDays = calculateAchievedDays()
        var showLabel: String = ""
        
        switch yesAchievedDays {
        case 0...100:
            showLabel = motivationalComments[yesAchievedDays]
            break
            case 101...:
            showLabel = "101日以上達成です！おめでとう！"
            break
        default:
            print("コメントの表示に失敗しました")
            break
        }
        
        return showLabel
        
    }
}
#Preview {
    YesCalendarView()
        .modelContainer(for: [DayChangeManager.self, EachDayData.self])
}

extension DateFormatter {
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}
