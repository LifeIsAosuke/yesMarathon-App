//
//  MyWidget.swift
//  MyWidget
//
//  Created by A S on 2025/06/05.
//

import WidgetKit
import SwiftUI

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
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
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
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            
            Text("YESマラソン")
                .font(.caption)
                .foregroundColor(.white)
                .bold()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            HStack {
                ZStack {
                    
                    Circle()
                        .frame(width: 60)
                        .foregroundColor(.white)
                        .border(Color.black, width: 2)
                        .cornerRadius(10)
                    
                    Image("achievedIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                        .clipShape(Circle())
                }
                
                VStack() {
                    HStack {
                        Text("\(sampleData.achievedCount)")
                        Text("日目 🔥")
                    }
                    Text("本日のYES")
                        .frame(width: .infinity, alignment: .leading)
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                        .bold()
                    Text(sampleData.yesLabel)
                }
                .padding()
            }
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
                //                    .containerBackground(.fill.tertiary, for: .widget)
                    .containerBackground(Color.yesOrange, for: .widget)
            } else {
                MyWidgetEntryView(entry: entry)
                    .padding()
                    .background()
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

