import SwiftUI

struct MonthView: View {
    
    var model: MonthModel
    @StateObject var router: Router = Router.shared
    
    var body: some View {
        VStack(spacing: 20) {
            AtypText(model.firstDate.month, size: 20)
            
            VStack(spacing: 12) {
                let days: [String] = ["пн", "вт", "ср", "чт", "пт", "сб", "вс"]
                HStack(spacing: 0) {
                    ForEach(days, id: \.self) { day in
                        AtypText(day, size: 16)
                            .frame(maxWidth: .infinity)
                    }
                }
                let columns = Array(repeating: GridItem(.flexible()), count: 7)
                LazyVGrid(columns: columns) {
                    ForEach(model.dates, id: \.id) { date in
                        Button {
                            if let day = date.date {
                                router.showNotifications(plants: date.notifications, today: day)
                            }
                        } label: {
                            PrettyDate(date: date)
                        }
                        .foregroundColor(.black)
                    }
                }
            }
        }
    }
}
