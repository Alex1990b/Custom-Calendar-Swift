//
//  OneDayCollectionViewCell.swift
//  Tourburst
//
//  Created by Olexandr Bondar on 10.05.18.
//  Copyright © 2018 inVeritaSoft. All rights reserved.
//

import UIKit

final class OneDayCollectionViewCell: UICollectionViewCell, NibLoadableView {

    @IBOutlet weak private var titleLabel: UILabel!
    
    var day: CalendarDayModel! {
        didSet {
            titleLabel.text = "\(day.number)"
            
            if day.isToday! {
                titleLabel.textColor =  .red
            } else if day.isSelected! {
                 titleLabel.textColor = day.isSelected == true ? .white : .black
            } else {
                 titleLabel.textColor = day.isAvaliable == true ? .black : .gray
            }
            
            let side = contentView.frame.height - 10
            let roundedView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: side, height: side)))
            roundedView.center = contentView.center
            roundedView.layer.cornerRadius = roundedView.frame.height / 2
            roundedView.clipsToBounds = true
            roundedView.backgroundColor = .lightGray
            
            if day.isSelected! {
                contentView.insertSubview(roundedView, belowSubview: titleLabel)
            } else {
                contentView.subviews.forEach { view in
                    if view != titleLabel {
                        view.removeFromSuperview()
                    }
                }
            }
            contentView.clipsToBounds = true
            isUserInteractionEnabled = day.isAvaliable == true ? true : false
        }
    }
}
