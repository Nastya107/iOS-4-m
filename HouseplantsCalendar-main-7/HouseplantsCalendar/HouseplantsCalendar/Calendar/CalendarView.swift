import SwiftUI

struct CalendarView: View {
    
    @StateObject var model: CalendarViewModel = CalendarViewModel.shared
    @StateObject var plantModel: PlantViewModel = PlantViewModel.shared
    @StateObject var router: Router = Router.shared
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack {
                Background(height: 1)
                VStack {
                    ScrollView {
                        LazyVStack {
                            ForEach(0..<6) { index in
                                MonthView(model: model.dates[index])
                                    .onAppear {
                                        Task {
                                            await model.loadNotifications(plantModel.plants, for: index)
                                            //model.loadMoreDatesIfNeeded(for: index)
                                        }
                                    }
                            }
                        }
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, 13)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    AtypText("2024", size: 20)
                        .foregroundColor(.black)
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
            .toolbarRole(.navigationStack)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .choice:
                    ChoiceView()
                case .notifications(let nots, let day):
                    NotificationsView(plants: nots, today: day)
                case .setup(let plants, let type):
                    SetUpPlantView(plants: plants, type: type)
                }
            }
        }
    }
}

