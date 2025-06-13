//
//  DetailView.swift
//  yesMarathon-App
//
//  Created by A S on 2025/06/01.
//

import SwiftUI
import SwiftData
import PhotosUI

struct DetailView: View {
    @Environment(\.modelContext) private var modelContext
    @State var matchingData: EachDayData
    
    @Environment(\.dismiss) private var dismiss
    
    // 編集画面を管理する変数
    @State var isEditing: Bool = false
    
    //---編集中に使う変数-------------------------------
    @State private var comment: String = ""
    @State private var stars: [Int] = [1, 1, 1, 0, 0]
    @State private var yesEvaluation: Int = 3
    @State private var selectedItem: PhotosPickerItem?
    @State private var imageData: Data?
    //-----------------------------------------------
    
    // 取得したカレンダーのフォーマットを指定
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // 日付
                    Text(matchingData.day, formatter: dateFormatter)
                        .padding()
                    
                    // YESタイトル
                    Text(matchingData.yesTitle)
                        .font(.title)
                        .padding()
                        .shadow(radius: 1)
                    
                    Divider()
                    
                    // コメント
                    HStack {
                        Image(systemName: "text.justify.left")
                            .frame(width: 25, height: 25)
                        Text("コメント")
                            .font(.system(size: 14))
                            .bold()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    if !isEditing {
                        if !matchingData.comment.isEmpty {
                            Text(matchingData.comment)
                                .frame(minHeight: 40)
                                .padding()
                        } else {
                            Text("コメントはありません")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding()
                        }
                    } else { // 編集画面
                        ZStack {
                            
                            TextEditor(text: $comment)
                                .scrollContentBackground(Visibility.hidden)
                            
                            if comment.isEmpty {
                                HStack {
                                    Text("今日のYESな瞬間を記録")
                                        .opacity(0.3)
                                    
                                    Spacer()
                                }
                                
                            }
                        }
                        .padding()
                    }
                    
                    Divider()
                    
                    // YES評価の編集
                    VStack {
                        HStack {
                            Image(systemName: "star")
                            Text("YES評価")
                                .font(.system(size: 14))
                                .bold()
                                
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        
                        if !isEditing {
                            HStack {
                                
                                Spacer()
                                
                                // 色塗りスターの表示
                                ForEach(0..<matchingData.yesEvaluation, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(Color.yesYellow)
                                        .font(.system(size: 25))
                                }
                                
                                // 外縁スターの表示
                                ForEach(0..<5-matchingData.yesEvaluation, id: \.self) { _ in
                                    Image(systemName: "star")
                                        .font(.system(size: 25))
                                }
                                
                                Spacer()
                            }
                            .padding()
                            
                        } else { // 編集画面
                            HStack(alignment: .top) {
                                ForEach(0..<5) { index in
                                    Button(action: {
                                        for i in 0...index {
                                            stars[i] = 1
                                        }
                                        for i in (index+1)..<5 {
                                            stars[i] = 0
                                        }
                                        yesEvaluation = index + 1
                                    }) {
                                        VStack {
                                            Image(systemName: stars[index] == 1 ? "star.fill" : "star")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(stars[index] == 1 ? Color.yesYellow : .gray)
                                            if index == 0 { Text("イマイチ").font(.caption) }
                                            if index == 2 { Text("イイネ!").font(.caption) }
                                            if index == 4 { Text("バチイケ!!").font(.caption) }
                                        }
                                        .foregroundColor(.black)
                                    }
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    
                    Divider()
                    
                    // 画像の表示と追加
                    if !isEditing {
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
                    } else { // 編集画面
                        // 画像追加
                        if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(10)
                                .padding()
                        } else {
                            PhotosPicker(selection: $selectedItem) {
                                HStack {
                                    HStack {
                                        Image(systemName: "photo")
                                        Text("画像を追加")
                                        
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                        
                                    
                                    Image(systemName: "chevron.right")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                .frame(minHeight: 40)
                                .padding()
                            }
                            .foregroundColor(.black)
                            .onChange(of: selectedItem) { newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        imageData = data
                                    }
                                }
                            }
                        }
                        
                        if isEditing {
                            Button {
                                saveChanges()
                                isEditing.toggle()
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .fill(Color.yesOrange)
                                        .frame(height: 60)
                                        .cornerRadius(10)
                                    Text("保存する")
                                        .font(.system(size: 20))
                                        .bold()
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    
                }
                .padding()
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if !isEditing {
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
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if !isEditing{
                            Button {
                                isEditing.toggle()
                            } label: {
                                Text("編集")
                                    .foregroundColor(.black)
                            }
                        } else {
                            Button {
                                isEditing.toggle()
                            } label: {
                                Text("キャンセル")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func saveChanges() {
        
        matchingData.comment = comment
        matchingData.yesEvaluation = yesEvaluation
        matchingData.imageData = imageData
        
        do {
            try modelContext.save()
        } catch {
            print("データの保存に失敗しました: \(error.localizedDescription)")
        }
    }
}
