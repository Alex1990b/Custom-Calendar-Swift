//
//  CalendarView.swift
//  Tourburst
//
//  Created by Olexandr Bondar on 10.05.18.
//  Copyright © 2018 inVeritaSoft. All rights reserved.
//

import UIKit

final class CalendarView: UIView {
    
    private var presenter: CalendarPresenter!
    private var collectionView: UICollectionView!
    private var daysCollectionView: UICollectionView!
    private var collectionViewLayout: UICollectionViewFlowLayout!
    private var titleLabel = UILabel()
    private var headerView = UIView()
    private var isUpdateEnable = true
    
    var selectedDays: [Date]? {
        return presenter.arrayDate
    }
    
    var selectionStyle: SelectionStyle = .rangeSelection {
        didSet {
            collectionView.reloadData()
        }
    }
    
    func configure() {
        
        presenter = CalendarPresenter(updatableDelegate: self)
        
        addHeaderView()
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionViewLayout)
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        collectionView.isUserInteractionEnabled = true
        collectionView.decelerationRate = UIScrollViewDecelerationRateNormal
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing = 0
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing = 0
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(OneMonthCollectionViewCell.self)
        
        let swipeRight = UISwipeGestureRecognizer.init(target: self, action:#selector(handleSwipeLeft))
        let swipeLeft = UISwipeGestureRecognizer.init(target: self, action:#selector(handleSwipeRight))
        swipeRight.direction = .left
        swipeLeft.direction = .right
        collectionView.addGestureRecognizer(swipeRight)
        collectionView.addGestureRecognizer(swipeLeft)
        addSubview(collectionView)
    }
    
    func updateCalendarPositionIfNeeded() {
        
        let collectionViewFrame = CGRect(origin: CGPoint(x: 0, y: 30), size: CGSize(width: bounds.width, height: frame.height - 30))
        let headerFrame = CGRect(origin: .zero,
                                 size: CGSize(width: frame.width, height: 30))
        headerView.frame = headerFrame
        titleLabel.frame = headerFrame
        collectionViewLayout.itemSize = collectionViewFrame.size
        collectionView.frame = collectionViewFrame
        collectionView.reloadData()
        titleLabel.text = Date().toString()
    }
    
    @objc func handleSwipeLeft() {
        updateToNextDate()
    }
    
    @objc func handleSwipeRight() {
        updateToPreviousDate()
    }
    
    func dataDidUpdate() {
        collectionView.reloadData()
    }
}

private extension CalendarView {
    
    func addHeaderView() {
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.text = Date().toString()
        headerView.addSubview(titleLabel)
        addSubview(headerView)
    }
    
    func updateToNextDate() {
        presenter?.updateToNextDate { [weak self ] date , index in
            self?.titleLabel.text = date.toString()
            let indexPath = IndexPath(row: index, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .right , animated: true)
            self?.dataDidUpdate()
        }
    }
    
    func updateToPreviousDate() {
        presenter?.updateToPreviousDate { [weak self] date, index in
            self?.titleLabel.text = date.toString()
            let indexPath = IndexPath(row: index, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .left , animated: true)
            self?.dataDidUpdate()
        }
    }
}

extension CalendarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.dataSourceMonts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OneMonthCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        
        let month = presenter?.dataSourceMonts[indexPath.row]
        cell.month = month
        cell.selectionStyle = selectionStyle
        cell.dataSourceDidUpdate = { [weak self] dataSource in
            
            self?.presenter?.newDays = dataSource
        }
        
        return cell
    }
}


