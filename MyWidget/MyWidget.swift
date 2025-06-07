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
    @Query private var dayChangeManager: [DayChangeManager]
    @State private var currentManager: DayChangeManager?
    //-----------------------------------------------------
    
    // 本日のYES表示用
    @State private var yesLabel: String = "Hello world"
    
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            
            HStack {
                ZStack {
                    
                    Circle()
                        .frame(width: 83)
                        .foregroundColor(.black)
                    
                    Circle()
                        .frame(width: 80)
                        .foregroundColor(.white)
                    
                    
                    
                    Image("achievedIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                        .clipShape(Circle())
                }
                
                VStack() {
                    HStack {
                        Text("2")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .bold()
                        Text("日目 🔥🔥")
                            .font(.system(size: 15))
                    }
                    
                    Divider()
                        .frame(height: 0.3) // Dividerの太さを設定
                        .background(Color.black) // Dividerの色を指定
                        .padding(.bottom,5)
                    
                    Text("本日のYES")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 11))
                        .foregroundColor(.white)
                        .bold()
                        .padding(.bottom, 1)
                    Text("\(yesLabel)")
                        .bold()
                }
            }
        }
        .onAppear {
            currentManager = dayChangeManager.first
            yesLabel = currentManager?.showYesTitle() ?? "さぁ、YESマラソンへ旅立とう！"
        }
        .onChange(of: currentManager) { _ in
            yesLabel = currentManager?.showYesTitle() ?? "更新に失敗しているよ"
        }
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
                    .modelContainer(for: [DayChangeManager.self])
            } else {
                MyWidgetEntryView(entry: entry)
                    .padding()
                    .background()
                    .modelContainer(for: [DayChangeManager.self])
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

