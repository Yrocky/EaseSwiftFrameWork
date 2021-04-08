//
//  XXXCompositionalLayoutViewController.swift
//  EaseSwiftFrameWork
//
//  Created by rocky on 2020/7/13.
//  Copyright © 2020 gmzb. All rights reserved.
//

import UIKit

class XXXAnchorView: UICollectionReusableView {

    static let reusedIdentifier = "XXXAnchorView_idendifier"
    static let elementKind = "XXXAnchorView_elementKind"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
        self.layer.cornerRadius = 22
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class XXXBackgroundView: UICollectionReusableView {
    
    static let reusedIdentifier = "XXXBackgroundView_idendifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = UIColor.red.withAlphaComponent(0.4)
        layer.cornerRadius = 10;
    }
}

class XXXNameCCell: UICollectionViewCell {

    let nameLabel = UILabel().then {
        $0.textColor = .red
        $0.font = .systemFont(ofSize: 15)
        $0.textAlignment = .center
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .green
        self.contentView.addSubview(self.nameLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.nameLabel.frame = self.contentView.bounds
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(index: Int) {
        nameLabel.text = "\(index)"
    }
}

class XXXCompositionalLayoutViewController: UIViewController {

    enum Section {
        case main
        case second
        case thrid
        case four
        case five
    }
    
    struct ImageModel: Hashable {
        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil

    var collectionView : UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView = UICollectionView.init(
            frame: view.bounds,
            collectionViewLayout: createLayout()
        )
        collectionView.backgroundColor = .white
//        collectionView.alwaysBounceVertical = true
        collectionView.register(
            XXXNameCCell.self,
            forCellWithReuseIdentifier: "name_cell"
        )
        collectionView.register(
            XXXAnchorView.self,
            forSupplementaryViewOfKind: XXXAnchorView.elementKind,
            withReuseIdentifier: XXXAnchorView.reusedIdentifier
        )
        view.addSubview(collectionView)
        
        // datasource
        dataSource = UICollectionViewDiffableDataSource<Section,Int>.init(collectionView: collectionView, cellProvider: { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "name_cell", for: indexPath) as? XXXNameCCell else {
                return nil
            }
            cell.setup(index: identifier)
            return cell
        })
        dataSource.supplementaryViewProvider = {(
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in

            let backgroundView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: XXXAnchorView.reusedIdentifier, for: indexPath) as? XXXAnchorView
            if let backgroundView = backgroundView {
                return backgroundView
            }
            return nil
            
            // 或者使用下面的方法
            if let badgeView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: XXXAnchorView.reusedIdentifier,
                for: indexPath) as? XXXAnchorView {
                
                return badgeView
            } else {
                fatalError("Cannot create new supplementary")
            }
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(1..<15), toSection: .main)
//        snapshot.appendItems(Array(16..<30), toSection: .second)
        dataSource.apply(snapshot)
    }

    func createLayout() -> UICollectionViewCompositionalLayout{
        
        return XXXCompositionLayout.aLayout()
        
        func edgedListLayout() -> UICollectionViewCompositionalLayout {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .flexible(0), top: nil,
                                                             trailing: .flexible(16), bottom: nil)
            let itemSize2 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                                  heightDimension: .fractionalHeight(1))
            let item2 = NSCollectionLayoutItem(layoutSize: itemSize2)
            item2.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil,
                                                              trailing: .flexible(0), bottom: nil)


            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .absolute(60))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                             subitems: [item, item2])

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10

            let layout = UICollectionViewCompositionalLayout(section: section)
            return layout
        }
        return edgedListLayout()
        func groupGridLayout() -> UICollectionViewCompositionalLayout {

            let layout = UICollectionViewCompositionalLayout {
                (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                
                let trailingItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(0.33))
                )
                trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                
                let leadingGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.33),
                        heightDimension: .fractionalHeight(1.0)),
                    subitem: trailingItem, count: 1
                )
                
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0))
                )
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                
                let twoItemGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(0.25)),
                    subitem: item, count: 2
                )
                
                let centerItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(0.5))
                )
                centerItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                
                let trailingGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.66),
                        heightDimension: .fractionalHeight(1.0)),
                    subitems: [twoItemGroup, centerItem, twoItemGroup]
                )
                
                let nestedGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.5),
                        heightDimension: .fractionalHeight(1.0)),
                    subitems: [leadingGroup, trailingGroup]
                )
                let section = NSCollectionLayoutSection(group: nestedGroup)
                
                return section
            }
            
            let config = UICollectionViewCompositionalLayoutConfiguration()
            config.scrollDirection = .horizontal
            layout.configuration = config
            return layout
        }
//        return groupGridLayout()
        func createTopRatedMovieSection() -> UICollectionViewCompositionalLayout {
            
//            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
//                widthDimension: .fractionalWidth(1.0),
//                heightDimension: .fractionalWidth(1.0)
//            ))
//            let group = NSCollectionLayoutGroup.vertical(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .absolute(140),
//                    heightDimension: .absolute(220)
//            ), subitem: item, count: 1)
//            group.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1/3)
            ))
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.85),
                    heightDimension: .fractionalWidth(1.0)
                ), subitem: item, count: 3
            )
            group.contentInsets = .init(top: 5, leading: 0, bottom: 5, trailing: 5)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            return UICollectionViewCompositionalLayout(section: section)
        }
//        return createTopRatedMovieSection()
        
        func galleyLayout() -> UICollectionViewCompositionalLayout {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.5))
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            
            let config = UICollectionViewCompositionalLayoutConfiguration()
            config.scrollDirection = .vertical
            
            let layout = UICollectionViewCompositionalLayout(section: section)
            layout.configuration = config
            
            return layout
        }
        
//        return galleyLayout()
        
        func listLayout() -> UICollectionViewCompositionalLayout {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 0, leading: 10, bottom: 10, trailing: 10)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(44))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            let layout = UICollectionViewCompositionalLayout(section: section)
            return layout
        }
    
        func bannerTitleGridLayout() -> UICollectionViewCompositionalLayout {
            
            let layout = UICollectionViewCompositionalLayout { (sectionIndex, layout) -> NSCollectionLayoutSection? in
                
                let anchorSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(44),
                    heightDimension: .absolute(44)
                )
                let anchor = NSCollectionLayoutAnchor(edges: [.top,.trailing])
                let anchorItem = NSCollectionLayoutSupplementaryItem(
                    layoutSize: anchorSize,
                    elementKind: XXXAnchorView.elementKind,
                    containerAnchor: anchor
                )
                
                let bigItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.5),
                        heightDimension: .fractionalHeight(1))
                )
                bigItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

                let otherItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1))
                )
                otherItem.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
                
                let otherGtoup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)),
                    subitem: otherItem, count: 2
                )
                let group_v = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.5),
                        heightDimension: .fractionalHeight(1)),
                    subitem: otherGtoup, count: 2
                )
//                group_v.supplementaryItems = [anchorItem]
                
                let group_h = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalWidth(0.5)),
                    subitems: [bigItem, group_v]
                )
                group_h.supplementaryItems = [anchorItem]
                
                let backgroundView = NSCollectionLayoutDecorationItem.background(elementKind: XXXBackgroundView.reusedIdentifier)
                backgroundView.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
                
                let section = NSCollectionLayoutSection(group: group_h)
                section.decorationItems = [backgroundView]
                section.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
                return section
            }
            
            // 注册一个section的背景视图
            layout.register(
                XXXBackgroundView.self,
                forDecorationViewOfKind: XXXBackgroundView.reusedIdentifier
            )
            return layout
        }
        
        return bannerTitleGridLayout()
        
        func bannerLayout() -> UICollectionViewCompositionalLayout {
            let layout = UICollectionViewCompositionalLayout {
                (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                
                let centerItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(0.666))
                )
                centerItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                
                let trailingItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(0.333))
                )
                trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                let trailingGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.25),
                        heightDimension: .fractionalHeight(1.0)),
                    subitem: trailingItem, count: 3
                )
                
                let centerGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.5),
                        heightDimension: .fractionalHeight(1.0)),
                    subitems: [trailingItem, centerItem]
                )
                
                let nestedGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(0.5)),
                    subitems: [trailingGroup,centerGroup,trailingGroup]
                )
                let section = NSCollectionLayoutSection(group: nestedGroup)
                
                return section
            }
            return layout
        }
        return bannerLayout()
        
        let layout = UICollectionViewCompositionalLayout.init { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in

            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(1.0)
            ))
            let group_v = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(44)),
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group_v)

            return section
        }

        return layout
    }
}

extension XXXCompositionalLayoutViewController {
    
}
