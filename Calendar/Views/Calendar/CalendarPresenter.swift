//
//  CalendarServicePresenter.swift
//  Tourburst
//
//  Created by Olexandr Bondar on 10.05.18.
//  Copyright © 2018 inVeritaSoft. All rights reserved.
//



import Foundation

final class CalendarPresenter {
    
    private var updatableDelegate: CalendarView?
    private var currentIndex = 0
    
    private(set) var dataSourceMonts = [CalendarMonthModel]()
    
    var arrayDate: [Date]? {
        
        let selectedDays = dataSourceMonts[currentIndex].days.filter { $0.isSelected == true}
        if !selectedDays.isEmpty {
            let startDate = (selectedDays.first?.date)!
            let endDate = (selectedDays.last?.date)!
            let dates = Date.generateDatesArrayBetweenTwoDates(startDate: startDate, endDate: endDate)
            
            return dates.map { $0.dateToFull() }
        }
        
        return nil
    }
    
    var newDays: [CalendarDayModel]! {
        didSet {
            dataSourceMonts[currentIndex].days = newDays
        }
    }
    
    init(updatableDelegate: CalendarView) {
        self.updatableDelegate = updatableDelegate
        configureMonthsDataSource()
    }
  
    func updateToNextDate(completion: (_ date: Date, _ index: Int) -> ()) {
        
        resetSelectedDays()
        currentIndex += 1
        
        if currentIndex == dataSourceMonts.count {
            loadNextMonth(date: dataSourceMonts[currentIndex - 1].date)
        }
        
        completion( dataSourceMonts[currentIndex].date, currentIndex)
    }
    
    func updateToPreviousDate(completion: (_ date: Date, _ index: Int) -> ()) {
        
        resetSelectedDays()
        currentIndex -= 1
        
        if currentIndex < 0 {
            currentIndex = 0
            loadPreviousMonth(date: dataSourceMonts[currentIndex].date)
        }
      
        completion( dataSourceMonts[currentIndex].date, currentIndex)
    }
    
    func updateData() {
        updatableDelegate?.dataDidUpdate()
    }
    
    func resetSelectedDays() {
        
        for (index, _) in dataSourceMonts[currentIndex].days.enumerated() {
            dataSourceMonts[currentIndex].days[index].isSelected = false
        }
        
        updatableDelegate?.dataDidUpdate()
    }
}

private extension CalendarPresenter {
    
    func loadPreviousMonth(date: Date) {
        
        let previousMonth = CalendarMonthModel(date: date.prevoisMonthDate, stringDate: date.prevoisMonthDate.toString(), days: getDaysForMonth(at: date.prevoisMonthDate))
        if !dataSourceMonts.contains { $0.date == previousMonth.date}  {
            dataSourceMonts.insert(previousMonth, at: currentIndex)
        }
    }
    
    func loadNextMonth(date: Date)  {
        
        let nextMonth = CalendarMonthModel(date: date.nextMonthDate, stringDate: date.nextMonthDate.toString(), days: getDaysForMonth(at: date.nextMonthDate))
        if !dataSourceMonts.contains { $0.date == nextMonth.date} {
            dataSourceMonts.append(nextMonth)
        }
    }
    
    func configureMonthsDataSource() {
        
        let currentMonth = CalendarMonthModel(date: Date(), stringDate: Date().toString(), days: getDaysForMonth(at: Date()))
        let nextMonth = CalendarMonthModel(date: Date().nextMonthDate, stringDate: Date().nextMonthDate.toString(), days: getDaysForMonth(at: Date().nextMonthDate))
        dataSourceMonts = [currentMonth, nextMonth ]
    }
    
    func getDaysForMonth(at date: Date) -> [CalendarDayModel] {
        
        let countRowsHorizontaly = 7
        let countRowsVercitcaly = 6
        let allDaysCount = countRowsHorizontaly * countRowsVercitcaly
        var daysArray = [CalendarDayModel]()
        let currnetMonthInfo = date.getShortInfo()
        let currentDay = currnetMonthInfo.day
        let startOfWeekDayNumber = (date.getMonthStart().getNumberDayOfWeek())
        let previousMonthDateInfo = date.prevoisMonthDate.getShortInfo()
        var previousMontLastDate = previousMonthDateInfo.countDaysInMonth - (startOfWeekDayNumber - 1)
        
        var isToday = false
        var firstDayInNextMonth = 1
        var firstDayInCurrnetMonth = 1
        var startDate = date.getMonthStart()
       
        for number in 1...allDaysCount + 1  {
            
            switch number {
            case 1...startOfWeekDayNumber:
                
                previousMontLastDate += 1
                let day = CalendarDayModel(date: nil, number: previousMontLastDate, isAvaliable: false, isToday: isToday, isSelected: false)

                if number != startOfWeekDayNumber {
                       daysArray.append(day)
                }
                
            case startOfWeekDayNumber - 1...currnetMonthInfo.countDaysInMonth + startOfWeekDayNumber:
                
                if date.toString() == Date().toString() {
                     isToday = firstDayInCurrnetMonth == currentDay ? true : false
                }
                
               
                let day = CalendarDayModel(date: startDate, number: firstDayInCurrnetMonth, isAvaliable: true, isToday: isToday, isSelected: false)
             
                firstDayInCurrnetMonth += 1
                startDate = startDate.tomorrow
                daysArray.append(day)
                
            default:
                
                let day = CalendarDayModel(date: nil, number: firstDayInNextMonth, isAvaliable: false, isToday: isToday, isSelected: false)
                firstDayInNextMonth += 1
                daysArray.append(day)
            }
        }
        
    return daysArray
    }
}
