//
//  DateFormatterExtension.swift
//  Calendar
//
//  Created by Sasha on 12.09.18.
//  Copyright © 2018 Sasha. All rights reserved.
//

import Foundation

enum DateFormatType: String {
    case format24HWithSeconds    = "HH:mm:ss"
    case format12HWithoutSeconds = "hh:mma"
    case monthAndYear            = "MMMM yyyy"
    case month                   = "MMM"
    case fullWithSeconds         = "yyyy-MM-dd'T'H:mm:ss"
    case fullWithoutSeconds      = "dd-MM-yyyy'T'H:mm:ss"
    case full                    = "yyyy-MM-dd"
    case day                     = "EE"
}

extension DateFormatter {
    static var dateFormatter = DateFormatter()
    
    static func dateFormatter(with format: DateFormatType ) -> DateFormatter {
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter
    }
    
}
