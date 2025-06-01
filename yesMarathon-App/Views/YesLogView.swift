import SwiftUI
import SwiftData

struct YesLogView: View {
    @Query private var eachDayDatas: [EachDayData] // SwiftDataからYES情報を取得
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Text("8日連続達成！！")
                    .font(.largeTitle)
                    .bold()
                
                YesCalendarView()
                    
            }
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
}
//
//#Preview {
//    let modelContainer = ModelContainer(for: EachDayData.self, inMemory: true)
//
//    let mockData = [
//        EachDayData(yesTitle: "モックタイトル1", day: Date(), comment: "これはテストコメントです1", yesEvaluation: 3),
//        EachDayData(yesTitle: "モックタイトル2", day: Date(), comment: "これはテストコメントです2", yesEvaluation: 5),
//        EachDayData(yesTitle: "モックタイトル3", day: Date(), comment: "これはテストコメントです3", yesEvaluation: 1)
//    ]
//
//    for data in mockData {
//        modelContainer.viewContext.insert(data)
//    }
//
//    YesLogView()
//        .modelContainer(modelContainer)
//}
