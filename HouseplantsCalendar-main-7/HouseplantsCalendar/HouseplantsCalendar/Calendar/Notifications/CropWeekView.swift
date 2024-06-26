import SwiftUI

struct CropWeekView: View {
    
    var week: [DayModel]
    @Binding var today: Date
    
    var body: some View {
        VStack(spacing: 16) {
            let days: [String] = ["пн", "вт", "ср", "чт", "пт", "сб", "вс"]
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    AtypText(day, size: 16)
                        .frame(maxWidth: .infinity)
                }
            }
            HStack(spacing: 0) {
                ForEach(week, id: \.id) { day in
//                    Button {
//                        today = day.date ?? Date()
//                    } label: {
                        PrettyDate(date: day, day: today)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.black)
												
//										}
                }
            }
        }
        .frame(height: 96)
    }
}
