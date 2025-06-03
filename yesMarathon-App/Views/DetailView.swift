//
//  DetailView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/06/01.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.modelContext) private var modelContext
    @State var matchingData: EachDayData
    
    @Environment(\.dismiss) private var dismiss

    // 取得したカレンダーのフォーマットを指定
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        return formatter
    }()

    var body: some View {
        NavigationStack {
            VStack {
                // 日付
                Text(matchingData.day, formatter: dateFormatter)
                    .padding()

                // YESタイトル
                Text(matchingData.yesTitle)
                    .font(.title)

                Divider()

                // コメント
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

                // YES評価の編集
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

                Divider()

                // 画像の表示と追加
                HStack {
                    Image(systemName: "photo")
                    Text("画像")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

                if let image = matchingData.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                        .padding()
                } else {
                    Text("画像はありません")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding()
                }

                Spacer()

                // 保存ボタン
                Button(action: saveChanges) {
                    Text("保存する")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("戻る")
                        }
                    }
                    .foregroundColor(.black)
                }
            }
        }
    }

    private func saveChanges() {
        do {
            try modelContext.save()
        } catch {
            print("データの保存に失敗しました: \(error.localizedDescription)")
        }
    }
}
