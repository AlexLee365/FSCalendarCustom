//
//  ViewController.swift
//  FSCalendarCustom
//
//  Created by 행복한 개발자 on 14/07/2019.
//  Copyright © 2019 Alex Lee. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    // MARK: - UI Properties
    let containerView = UIView()
    let topTextLabel = UILabel()
    let refreshBtn = UIButton()
    var weekdayLabel = UILabel()
    let seperateLineViewTop = UIView()
    let seperateLineViewBottom = UIView()
    let resultBtn = UIButton()
    
    private weak var calendar: FSCalendar!
    
    // MARK: - Properties
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    
    var selectDatesArray = [Date]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setCalendar()
        setAutoLayout()
        configureViewsOptions()
    }
    
    private func setAutoLayout() {
        let safeGuide = view.safeAreaLayoutGuide
        
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 100).isActive = true
        containerView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -200).isActive = true
        
        containerView.addSubview(topTextLabel)
        topTextLabel.translatesAutoresizingMaskIntoConstraints = false
        topTextLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15).isActive = true
        topTextLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        containerView.addSubview(refreshBtn)
        refreshBtn.translatesAutoresizingMaskIntoConstraints = false
        refreshBtn.centerYAnchor.constraint(equalTo: topTextLabel.centerYAnchor).isActive = true
        refreshBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -3).isActive = true
        refreshBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        refreshBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let weekDays = ["일", "월", "화", "수", "목", "금", "토"]
        var leadingConst:CGFloat = 20
        let containerViewWidth = UIScreen.main.bounds.width - 20
        for i in 0...6 {
            let label = UILabel()
            containerView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.topAnchor.constraint(equalTo: topTextLabel.bottomAnchor, constant: 15).isActive = true
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leadingConst).isActive = true
            label.text = weekDays[i]
            label.textColor = #colorLiteral(red: 0.1990053952, green: 0.1978290677, blue: 0.1999138892, alpha: 0.8544252997)
            label.font = .systemFont(ofSize: 11, weight: .regular)
            
            leadingConst += ( (containerViewWidth-40) / 6 )
            ( i == 6 ) ? (weekdayLabel = label) : ()
        }
        containerView.addSubview(seperateLineViewTop)
        seperateLineViewTop.translatesAutoresizingMaskIntoConstraints = false
        seperateLineViewTop.topAnchor.constraint(equalTo: weekdayLabel.bottomAnchor, constant: 5).isActive = true
        seperateLineViewTop.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        seperateLineViewTop.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        seperateLineViewTop.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        containerView.addSubview(calendar)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.topAnchor.constraint(equalTo: seperateLineViewTop.bottomAnchor, constant: 0).isActive = true
        calendar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        calendar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        calendar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -50).isActive = true
        
        containerView.addSubview(seperateLineViewBottom)
        seperateLineViewBottom.translatesAutoresizingMaskIntoConstraints = false
        seperateLineViewBottom.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 2).isActive = true
        seperateLineViewBottom.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        seperateLineViewBottom.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        seperateLineViewBottom.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        containerView.addSubview(resultBtn)
        resultBtn.translatesAutoresizingMaskIntoConstraints = false
        resultBtn.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        resultBtn.centerYAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -25).isActive = true
        resultBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        resultBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func configureViewsOptions() {
        containerView.backgroundColor = .clear
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(red:0.09, green:0.51, blue:0.54, alpha:0.4).cgColor
        containerView.layer.cornerRadius = 10
        
        topTextLabel.text = "날짜 선택"
        topTextLabel.textAlignment = .center
        topTextLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        topTextLabel.textColor = #colorLiteral(red: 0.1990053952, green: 0.1978290677, blue: 0.1999138892, alpha: 0.8544252997)
        
        refreshBtn.setTitle("지우기", for: .normal)
        refreshBtn.setTitleColor(UIColor(red:0.09, green:0.51, blue:0.54, alpha:1.0), for: .normal)
        refreshBtn.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        refreshBtn.addTarget(self, action: #selector(refreshBtnDidTap(_:)), for: .touchUpInside)
        refreshBtn.isEnabled = false
        refreshBtn.layer.opacity = 0.5
        
        seperateLineViewTop.backgroundColor = #colorLiteral(red: 0.7327679992, green: 0.7284137607, blue: 0.7361161113, alpha: 0.4171660959)
        seperateLineViewBottom.backgroundColor = #colorLiteral(red: 0.7327679992, green: 0.7284137607, blue: 0.7361161113, alpha: 0.4171660959)
        
        resultBtn.setTitle("결과 보기", for: .normal)
        resultBtn.setTitleColor(UIColor(red:0.09, green:0.51, blue:0.54, alpha:1.0), for: .normal)
        resultBtn.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        
        
    }
    
    private func setCalendar() {
        let calendar = FSCalendar(frame: .zero)
        calendar.dataSource = self
        calendar.delegate = self
        calendar.pagingEnabled = false
        calendar.scrollDirection = .vertical
        calendar.allowsMultipleSelection = true
        
        calendar.today = nil
        
        calendar.appearance.headerDateFormat = "M"
        calendar.headerHeight = 35
        calendar.appearance.headerTitleFont = .systemFont(ofSize: 13, weight: .semibold)
        calendar.appearance.headerTitleColor = .black
        
        calendar.weekdayHeight = 15
        calendar.appearance.weekdayTextColor = .clear
        
        calendar.appearance.titleFont = .systemFont(ofSize: 13, weight: .semibold)
        calendar.appearance.titleDefaultColor = #colorLiteral(red: 0.1990053952, green: 0.1978290677, blue: 0.1999138892, alpha: 0.8544252997)
        calendar.appearance.titlePlaceholderColor = #colorLiteral(red: 0.7327679992, green: 0.7284137607, blue: 0.7361161113, alpha: 0.4171660959)
        calendar.appearance.selectionColor = UIColor(red:0.09, green:0.51, blue:0.54, alpha:1.0)
        
//        calendar.appearance.todayColor = .clear
//        calendar.appearance.titleTodayColor = #colorLiteral(red: 0.1990053952, green: 0.1978290677, blue: 0.1999138892, alpha: 0.8544252997)
       
//        calendar.swipeToChooseGesture.isEnabled = true

        view.addSubview(calendar)
        self.calendar = calendar
    }
    
    @objc func refreshBtnDidTap(_ sender: UIButton) {
        print("didTap")
        topTextLabel.text = "날짜 선택"
        selectDatesArray.forEach{
            calendar.deselect($0)
        }
        selectDatesArray.removeAll()
        sender.isEnabled = false
        sender.layer.opacity = 0.5
    }
    
    private func todayDate() ->  Date {
        var components = Calendar.current.dateComponents([.year, .day, .month, .hour, .minute], from: Date())
        //        components.day = components.day! - 1
        components.hour = 00
        components.minute = 00
        components.second = 00
        let testDate = Calendar.current.date(from: components)!
        print("🔵🔵🔵 todayDate: ", testDate)
        return testDate
    }
    
    private func lastDayOfMonth(date: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        let range = calendar.range(of: .day, in: .month, for: date)!
        components.day = range.upperBound - 1
        return calendar.date(from: components)!
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("--------------------------[viewDidLaoutSubviews]--------------------------")
       
    }
    
    
    
}

extension ViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        print("--------------------------[ShouldSelect]--------------------------")
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        let selectDateString = dateFormatter.string(from: date)
        print("selectDateString: ", selectDateString)
        
        
        
        dateFormatter.dateFormat = "MM.dd"
        let currentDay = dateFormatter.string(from: currentDate)
        let selectDay = dateFormatter.string(from: date)
        print("currentDay: ", currentDay)
        print("selectDay: ", selectDay)
        
      
        
        if currentDay == selectDay {
//            return false
        }
        
        
        return true
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return currentDate
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        let laterDate = Calendar.current.date(byAdding: .month, value: 2, to: currentDate)!
        let lastDayMonth = lastDayOfMonth(date: laterDate)
        
        return lastDayMonth
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("--------------------------[DidSelect]--------------------------")
        refreshBtn.isEnabled = true
        refreshBtn.layer.opacity = 1
        
        switch selectDatesArray.count {
        case 0:
            print("currentCount: ", selectDatesArray.count)
            selectDatesArray.append(date)
            topTextLabel.text = setTextFromDate()
            print(selectDatesArray)
        case 1:
            // 이미 1개가 선택되어있을때
            print("currentCount: ", selectDatesArray.count)
            selectDatesArray.append(date)
            selectDatesArray.sort()
            
            let timeGap = selectDatesArray[1].timeIntervalSince(selectDatesArray[0])
            let oneDayValue: TimeInterval = 3600 * 24
            let daysGap = Int(timeGap / oneDayValue)
            
            for i in 1...daysGap {
                let day = Calendar.current.date(byAdding: .day, value: i, to: selectDatesArray[0])
                selectDatesArray.append(day!)
                calendar.select(day)
            }
            
            selectDatesArray.removeLast()
            selectDatesArray.sort()
            topTextLabel.text = setTextFromDate()
            print(selectDatesArray)
        case 2...:
            // 눌렀을때 이미 2개이상이 선택되있는 상황일때
            print("currentCount: ", selectDatesArray.count)
            selectDatesArray.forEach{
                calendar.deselect($0)
            }
            selectDatesArray.removeAll()
            selectDatesArray.append(date)
            topTextLabel.text = setTextFromDate()
            print(selectDatesArray)
        default : break
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("--------------------------[DidDeselect]--------------------------")
        if selectDatesArray.contains(date) {
            selectDatesArray.forEach{
                calendar.deselect($0)
            }
            selectDatesArray.removeAll()
            calendar.select(date)
            selectDatesArray.append(date)
            topTextLabel.text = setTextFromDate()
        }
        print(selectDatesArray)
    }
    
    private func setTextFromDate() -> String{
        var dayString = ""

        let componentsStartDay = Calendar.current.dateComponents([.month, .day], from: selectDatesArray.first!)
        
        if selectDatesArray.count > 1 {
            let componentsEndDay = Calendar.current.dateComponents([.month, .day], from: selectDatesArray.last!)
            dayString = "\(componentsStartDay.month!)월 \(componentsStartDay.day!)일 ~ \(componentsEndDay.month!)월 \(componentsEndDay.day!)일"
            return dayString
        }
        dayString = "\(componentsStartDay.month!)월 \(componentsStartDay.day!)일"
        return dayString
    }
}
