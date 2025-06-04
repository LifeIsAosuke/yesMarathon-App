import SwiftUI
import SwiftData

struct YesLogView: View {
    // SwiftDataからYES情報を取得
    @Query private var eachDayDatas: [EachDayData]
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
                            Text("ホームに戻る")
                        }
                    }
                    .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    YesLogView()
        .modelContainer(for: [DayChangeManager.self, EachDayData.self])
}
