//
//  UICollectionViewExtension.swift
//  Calendar
//
//  Created by Sasha on 13.09.18.
//  Copyright © 2018 Sasha. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell & NibLoadableView>(_: T.Type) {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        
        register(nib, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell & NibLoadableView>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return cell
    }
    
}
