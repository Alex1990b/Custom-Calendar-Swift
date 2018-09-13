//
//  CalendarDayModel.swift
//  Tourburst
//
//  Created by Olexandr Bondar on 10.05.18.
//  Copyright © 2018 inVeritaSoft. All rights reserved.
//

import Foundation

struct CalendarDayModel {
    
    var date: Date?
    var number: Int
    private(set) var isAvaliable: Bool
    var isToday: Bool?
    var isSelected: Bool?
}


