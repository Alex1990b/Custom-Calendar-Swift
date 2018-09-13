//
//  CalendarUICollectionViewCell.swift
//  Tourburst
//
//  Created by Olexandr Bondar on 10.05.18.
//  Copyright © 2018 inVeritaSoft. All rights reserved.
//

import UIKit

enum SelectionStyle {
    case rangeSelection
    case multiSelection
}

final class OneMonthCollectionViewCell: UICollectionViewCell, NibLoadableView {
    
    @IBOutlet weak private var numberDaysCollectionView: UICollectionView!
    
    private var dataSource = [CalendarDayModel]()
    
    private var cellSide: CGFloat {
        get {
            let countWeekDays: CGFloat = 7
            return frame.width / countWeekDays 
        }
    }
    
    var month: CalendarMonthModel! {
        didSet {
            dataSource = month.days
            numberDaysCollectionView.reloadData()

        }
    }
    
    var selectionStyle: SelectionStyle = .rangeSelection
    
    var dataSourceDidUpdate: ((_ days: [CalendarDayModel]) -> ())?
    
    override func draw(_ rect: CGRect) {
        
        numberDaysCollectionView.delegate = self
        numberDaysCollectionView.dataSource = self
        (numberDaysCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing = 0
        (numberDaysCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing = 0
        numberDaysCollectionView.register(OneDayCollectionViewCell.self)
        numberDaysCollectionView.isScrollEnabled = false
        numberDaysCollectionView.showsHorizontalScrollIndicator = false
    }
}

extension OneMonthCollectionViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        dataSource[indexPath.row].isSelected = true
        let selectedDays = dataSource.filter { $0.isSelected == true }
        
        
        if selectionStyle == .rangeSelection {
            if selectedDays.count == 2 {
                
                let firsDay = selectedDays.map { $0.number }.min() ?? 0
                let lastDay = selectedDays.map { $0.number }.max() ?? 0
                let firsDayIndex = dataSource.index(where: { $0.number == firsDay && $0.isAvaliable == true}) ?? 0
                let lastDayIndex = dataSource.index(where: { $0.number == lastDay && $0.isAvaliable == true}) ?? 0
                
                let secondIndex = firsDayIndex > lastDayIndex ? firsDayIndex : lastDayIndex
                let firstIndex = firsDayIndex < lastDayIndex ? firsDayIndex : lastDayIndex
                
                for (index, _) in dataSource.enumerated() {
                    
                    switch index {
                    case firstIndex...secondIndex:
                        dataSource[index].isSelected = true
                    default: break
                    }
                }
                
            } else {
                for (index, _) in dataSource.enumerated() {
                    dataSource[index].isSelected = false
                }
                dataSource[indexPath.row].isSelected = true
            }
            
        } else {
            for (index, _) in dataSource.enumerated() {
                dataSource[index].isSelected = false
            }
            dataSource[indexPath.row].isSelected = true
        }
        
        
        dataSourceDidUpdate?(dataSource)
        collectionView.reloadData()
    }
    
}

extension OneMonthCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OneDayCollectionViewCell = numberDaysCollectionView.dequeueReusableCell(for: indexPath)
        
        cell.day = dataSource[indexPath.row]
        
        return cell
    }
}

extension OneMonthCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellSide, height: cellSide)
    }
}
