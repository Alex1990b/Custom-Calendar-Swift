//
//  ViewController.swift
//  Calendar
//
//  Created by Sasha on 12.09.18.
//  Copyright © 2018 Sasha. All rights reserved.
//

import UIKit


final class ViewController: UIViewController {

    @IBOutlet private weak var calendarView: CalendarView!
    @IBOutlet private weak var datesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.configure()
    }
  
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calendarView.updateCalendarPositionIfNeeded()
    }
}

private extension ViewController {
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        
        let from = calendarView.selectedDays?.first?.toString(dateFormat: .full)
        let to = calendarView.selectedDays?.last?.toString(dateFormat: .full)
        datesLabel.text = "You selected date from \(from ?? "")  to \(to ?? "")"
    }
    
    @IBAction func multiSelectionButtonTapped(_ sender: UIButton) {
        calendarView.selectionStyle = .multiSelection
    }
    
    @IBAction func rangeButtonTapped(_ sender: UIButton) {
        calendarView.selectionStyle = .rangeSelection
    }
}

