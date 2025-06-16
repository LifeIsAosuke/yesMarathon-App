//
//  MyWidget.swift
//  MyWidget
//
//  Created by A S on 2025/06/05.
//

import WidgetKit
import SwiftUI
import SwiftData

// ウィジェットに表示するデータ構造
struct yesData: Identifiable {
    var id: UUID
    var yesLabel: String
    var achievedCount: Int
}

// ここのデータは実際はyesMarathonAppから持ってくる
let sampleData: yesData = yesData(id: UUID(), yesLabel: "自分らしくないことをやってみる", achievedCount: 13)


struct Provider: TimelineProvider {
    // widgetの初読み込み時やデータの取得中の時に表示される
    func placeholder(in context: Context) -> SimpleEntry {
        // 初期化時に酔い込まれるデータ
        SimpleEntry(date: .now, yesData: sampleData)
    }
    
    // widget追加時に表示するサンプルデータを生成
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: .now, yesData: sampleData)
        completion(entry)
    }
    
    // タイムラインのデータを生成
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: 15, to: .now)!
            let entry = SimpleEntry(date: .now, yesData: sampleData)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    //    func relevances() async -> WidgetRelevances<Void> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}

// ウィジェットに表示するためのデータの一つの状態
struct SimpleEntry: TimelineEntry {
    let date: Date
    let yesData: yesData
}

// ウィジェットの見た目
struct MyWidgetEntryView : View {
    
    // DayChangeManagerの情報を取得--------------------------
    @Query private var eachDayDatas: [EachDayData]
    //-----------------------------------------------------
    
    @ObservedObject private var dayChangeManager = DayChangeManager()
    
    // 本日のYES表示用
    @State private var yesLabel: String = "Hello world"
    
    var entry: Provider.Entry
    
    // 現在の日付を取得
    @State private var displayedDate: Date = Date()
    // 現在のカレンダーを取得
    let calendar = Calendar.current
    
    var body: some View {
        ZStack {
            
            Text("YESマラソン")
                .foregroundStyle(.white)
                .bold()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .font(.system(size:10))
            
            VStack() {
                if dayChangeManager.isTrue { // 達成されていたら
                    HStack {
                        Text("本日のYES達成！")
                            .font(.system(size: 15))
                        Text("\(calculateAchievedDays())")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .bold()
                        Text("日目!!")
                            .font(.system(size: 15))
                    }
                } else { // 達成していなかったら
                    Text("本日のYES")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .bold()
                }
                
                Divider()
                    .frame(height: 0.3) // Dividerの太さを設定
                    .background(Color.black) // Dividerの色を指定
                    .padding(.bottom,5)
 
                if dayChangeManager.isTrue { // 達成されていたら
                    Text("また明日もYESな1日を！🔥🔥")
                        .foregroundColor(.white)
                        .bold()
                        .shadow(radius: 5)
                } else { // 達成していなかったら
                    Text("\(yesLabel)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                        .bold()
                        .shadow(radius: 5)
                }
            }
            
        }
        .onAppear {
            yesLabel = dayChangeManager.yesTitle
        }
        
    }
    
    // 連続ログイン日数を記録してくれる関数
    func calculateAchievedDays() -> Int {
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
}

// ウィジェット本体
struct MyWidget: Widget {
    let kind: String = "MyWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                MyWidgetEntryView(entry: entry)
                    .containerBackground(Color.yesOrange, for: .widget)
                    .modelContainer(for: [EachDayData.self])
            } else {
                MyWidgetEntryView(entry: entry)
                    .padding()
                    .background()
                    .modelContainer(for: [EachDayData.self.self])
            }
        }
        .configurationDisplayName("YESマラソン")
        .description("本日のYESと連続達成日を表示します")
    }
}


#Preview(as: .systemMedium) { // widgetのサイズを指定
    MyWidget()
} timeline: {
    SimpleEntry(date: .now, yesData: sampleData)
}

