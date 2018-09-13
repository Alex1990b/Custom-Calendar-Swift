//
//  ReusableView.swift
//  Calendar
//
//  Created by Sasha on 13.09.18.
//  Copyright © 2018 Sasha. All rights reserved.
//

import UIKit

protocol NibLoadableView: class {
    static var defaultReuseIdentifier: String { get }
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nibName: String {
        return String(describing: self)
    }
}
