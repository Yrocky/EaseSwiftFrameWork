//
//  XXXCompositionLayout.swift
//  EaseSwiftFrameWork
//
//  Created by rocky on 2020/7/18.
//  Copyright © 2020 gmzb. All rights reserved.
//

import Foundation
import UIKit

class XXXCompositionLayout {
    
    static func aLayout() -> UICollectionViewCompositionalLayout {

        let bigItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.4),
                heightDimension: .fractionalHeight(1))
        )
        
        let otherItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1.0))
        )
        let group_other = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)),
            subitems: [otherItem]
        )
        group_other.interItemSpacing = .fixed(10)
        
        let group_h = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(90)),
            subitems: [bigItem,group_other]
        )
        group_h.interItemSpacing = .fixed(10);

        let section = NSCollectionLayoutSection(group: group_h)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
