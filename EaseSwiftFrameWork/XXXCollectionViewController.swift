//
//  XXXCollectionViewController.swift
//  EaseSwiftFrameWork
//
//  Created by skynet on 2020/5/26.
//  Copyright © 2020 gmzb. All rights reserved.
//

import UIKit

extension UIEdgeInsets{
    enum Direction: Int {
        case vertical
        case horizontal
    }
    
    static func mekeAll(_ margin: CGFloat = 0) -> UIEdgeInsets {
        return UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
    
    func value(of direction: Direction) -> CGFloat{
        switch direction {
        case .horizontal:
            return self.left + self.right
        case .vertical:
            return self.top + self.bottom
        }
    }
}
class XXXSomeCollectionViewCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .orange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class XXXCollectionViewController: BaseViewController {

    var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = XXXCollectionViewFlowLayout()
        let margin: CGFloat = 20
        let itemW = (view.bounds.width - margin * 4) / 3
        let itemH = itemW
        // 每个item的大小
        layout.itemSize = CGSize(width: itemW, height: itemH)
        // 最小行间距
        layout.minimumLineSpacing = margin
        // 最小item之间的距离
        layout.minimumInteritemSpacing = margin
        // 每组item的边缘切距
        layout.sectionInset = UIEdgeInsets.mekeAll(margin)
        // 滚动方向
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.backgroundColor = .white
        collectionView!.register(cellWithClass: XXXSomeCollectionViewCell.self)
        collectionView!.register(XXXSectionHeaderView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: "header")
        collectionView!.register(XXXSectionFooterView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                 withReuseIdentifier: "footer")
        view.addSubview(collectionView!)
        
        collectionView!.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
}

extension XXXCollectionViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8 + section * 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: XXXSomeCollectionViewCell.self, for: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! XXXSectionHeaderView
            header.backgroundColor = .purple
//            header.textLabel.text = "第 \(indexPath.section) 组的头部"
            return header
        }
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer", for: indexPath) as! XXXSectionFooterView
//        footer.textLabel.text = "第 \(indexPath.section) 组的尾部"
        footer.backgroundColor = .lightGray
        return footer
    }
}

extension XXXCollectionViewController: YYCollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: 40, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        return CGSize(width: 40, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        if section == 0 {
            return .red
        } else if section == 1 {
            return .green
        } else if section == 2 {
            return UIColor.brown.withAlphaComponent(0.8)
        }
        return .blue
    }
}

class XXCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var bgColor = UIColor.red
}

class XXXSectionHeaderView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class XXXSectionFooterView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class XXXSectionBGView: UICollectionReusableView {
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let att = layoutAttributes as? XXCollectionViewLayoutAttributes else { return  }
        backgroundColor = att.bgColor
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
}

public protocol YYCollectionViewDelegateFlowLayout: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorInsertForSectionAt section: Int) -> UIEdgeInsets
}

extension YYCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return .clear
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorInsertForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets.mekeAll(10)
    }
}

class XXXCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var decorateViewAtts: [UICollectionViewLayoutAttributes] = []
    
    override init() {
        super.init()
        register(XXXSectionBGView.classForCoder(), forDecorationViewOfKind: "XXXSectionBGView")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        guard let numberOfSections = self.collectionView?.numberOfSections,
            let delegate = self.collectionView?.delegate as? YYCollectionViewDelegateFlowLayout
            else {return}
        
        self.decorateViewAtts.removeAll()
        
        for section in 0..<numberOfSections {
            guard let numberOfItems = self.collectionView?.numberOfItems(inSection: section),
                numberOfItems > 0,
                let firstItem = self.layoutAttributesForItem(at: IndexPath(item: 0, section: section)),
                let lastItem = self.layoutAttributesForItem(at: IndexPath(item: numberOfItems - 1, section: section)) else {
                    continue
            }
            var sectionInset = self.sectionInset
            if let inset = delegate.collectionView?(self.collectionView!, layout: self, insetForSectionAt: section) {
                sectionInset = inset
            }
            
           let decorateInset = delegate.collectionView(self.collectionView!,
                                                       layout: self,
                                                       backgroundColorInsertForSectionAt: section)
            
            let sectionFrame = firstItem.frame.union(lastItem.frame)
            
            let attr = XXCollectionViewLayoutAttributes(forDecorationViewOfKind: "XXXSectionBGView",
                                                        with: IndexPath(item: 0, section: section))
            attr.frame = calculatfDecorationViewFrame(sectionInset: sectionInset,
                                                      sectionFrame: sectionFrame,
                                                      decorateInset: decorateInset)
            attr.zIndex = -1
            attr.bgColor = delegate.collectionView(self.collectionView!, layout: self, backgroundColorForSectionAt: section)
            self.decorateViewAtts.append(attr)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var atts = super.layoutAttributesForElements(in: rect)
        atts?.append(contentsOf: self.decorateViewAtts.filter({
            return rect.intersects($0.frame)
        }))
        return atts
    }
    
    func calculatfDecorationViewFrame(sectionInset: UIEdgeInsets, sectionFrame: CGRect, decorateInset: UIEdgeInsets) -> CGRect{
        
        var decorateViewFrame = sectionFrame

        if self.scrollDirection == .horizontal {
            decorateViewFrame.origin.x = sectionFrame.origin.x - (sectionInset.left - decorateInset.left)
            decorateViewFrame.origin.y -= (sectionInset.top - decorateInset.top)
            decorateViewFrame.size.width += (sectionInset.left - decorateInset.left) +
            (sectionInset.right - decorateInset.right)
            decorateViewFrame.size.height = sectionFrame.height + sectionInset.value(of: .vertical) - decorateInset.value(of: .vertical)
        } else {
            decorateViewFrame.origin.x = decorateInset.left
            decorateViewFrame.origin.y -= (sectionInset.top - decorateInset.top)
            decorateViewFrame.size.width = (self.collectionView!.frame.width - decorateInset.left - decorateInset.right)
            decorateViewFrame.size.height += (sectionInset.top - decorateInset.top) +
                (sectionInset.bottom - decorateInset.bottom)
        }
        
        return decorateViewFrame
    }
}
