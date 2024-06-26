import SwiftUI

class CalendarViewModel: ObservableObject {
    
    static let shared: CalendarViewModel = CalendarViewModel()
    
    @Published var dates: [MonthModel] = [MonthModel]()
    private var offset: Int = 2
    var calendar = Calendar.current
    let batchSize: Int = 5
    
    init() {
        for i in 0...batchSize {
            let newDate = Date().startOfMonth.addMonth(n: i)
            dates.append(loadMonth(newDate))
        }
    }
    
    func loadMoreDatesIfNeeded(for index: Int) {
        
        if index == batchSize * 2 {
            let newDate = Date().startOfMonth.addMonth(n: dates.count - offset)
            offset -= 1
            dates.remove(at: 0)
            dates.append(loadMonth(newDate))
        }
        
        if index == 0,
           dates.count > batchSize {
            let newDate = Date().startOfMonth.addMonth(n: -offset - 1)
            offset += 1
            dates.remove(at: dates.count - 1)
            dates.insert(loadMonth(newDate), at: 0)
        }
    }
    
    private func loadMonth(_ day: Date) -> MonthModel {
        return MonthModel(day)
    }
    
    func loadNotifications(_ plants: [PlantModel], for ind: Int) async {
        DispatchQueue.main.async {
            var result: MonthModel = self.dates[ind]
            for i in 0..<result.dates.count {
                var res = [PlantModel]()
                for plant in plants {
                    var pl = plant
                    pl.watering = nil
                    pl.wateringDate = nil
                    pl.fertilizer = nil
                    pl.fertilizerDate = nil
                    if let wat = plant.watering,
                       let watD = plant.wateringDate,
                       let date = result.dates[i].date {
                        if self.calendar.numberOfDaysBetween(date, and: watD) % wat == 0 {
                            pl.watering = wat
                            pl.wateringDate = watD
                        }
                    }
                    if let wat = plant.fertilizer,
                       let watD = plant.fertilizerDate,
                       let date = result.dates[i].date {
                        if self.calendar.numberOfDaysBetween(date, and: watD) % wat == 0 {
                            pl.fertilizer = wat
                            pl.fertilizerDate = watD
                        }
                    }
                    if pl.watering != nil || pl.fertilizer != nil {
                        res.append(pl)
                    }
                }
                result.dates[i] = DayModel(date: result.dates[i].date, notifications: res)
            }
            self.dates[ind] = result
        }
    }
    
    func loadWeek(_ plants: [PlantModel],
                  for day: Date,
                  completion: @escaping ([DayModel]) -> Void ) async {
        DispatchQueue.main.async {
            var result: [DayModel] = [DayModel]()
            for month in self.dates {
                for daymodel in month.dates {
                    if let date = daymodel.date {
                        if self.calendar.numberOfDaysBetween(date, and: day) == day.weekDay - result.count {
                            result.append(daymodel)
                        }
                    }
                    if result.count == 7 {
                        break
                    }
                }
                if result.count == 7 {
                    break
                }
            }
            completion(result)
        }
    }
    
}


