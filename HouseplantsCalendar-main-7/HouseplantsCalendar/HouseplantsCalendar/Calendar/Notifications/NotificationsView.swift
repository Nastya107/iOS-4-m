import SwiftUI

struct NotificationsView: View {
    
    @StateObject var model: CalendarViewModel = CalendarViewModel.shared
    @StateObject var router: Router = Router.shared
    @State var plants: [PlantModel]
    @State var week: [DayModel] = [DayModel]()
    @State var today: Date
    let calendar = Calendar.current
    
    var body: some View {
        ZStack(alignment: .center) {
            Background()
            
            VStack(spacing: 12) {
                CropWeekView(week: week, today: $today)
                    .onAppear(perform: {
                        Task {
                            await model.loadWeek(plants, for: today) { week in
                                self.week = week
                            }
                        }
                    })
                    .padding(.top, 32)
                let dateString = calendar.startOfDay(for: today) == calendar.startOfDay(for: Date()) ? "сегодня" : today.dateAsStringFull
                AtypText("Уведомления " + dateString, size: 22)
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, maxHeight: 48, alignment: .leading)
                    .background(.white)
                    .cornerRadius(10)
                ScrollView {
                    VStack(spacing: 12) {
												if week.count == 7 {
                            ForEach(week[today.weekDay].notifications, id: \.id) { plant in
                                NotificationCardView(model: plant, today: today)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 13)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    router.back()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                        if week.count == 7 {
                            if let startMonth = week[0].date?.month,
                               let endMonth = week[6].date?.month {
                                if startMonth == endMonth {
                                    AtypText(startMonth, size: 20)
                                        .foregroundColor(.black)
                                } else {
                                    AtypText(startMonth + "/" + endMonth.lowercased(), size: 20)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    router.showChoice()
                } label: {
                    Image(systemName: "plus.app.fill")
                        .foregroundColor(Color("GrayActive"))
                        .font(.system(size: 33))
                }
            }
        }
    }
}
