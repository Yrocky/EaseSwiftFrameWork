//
//  XXXCollectionKitViewController.swift
//  EaseSwiftFrameWork
//
//  Created by skynet on 2019/7/25.
//  Copyright © 2019 gmzb. All rights reserved.
//

import UIKit
import CollectionKit

let kGridCellSize = CGSize(width: 50, height: 50)
let kGridSize = (width: 20, height: 20)
let kGridCellPadding:CGFloat = 10

class XXXCollectionKitViewController: UIViewController {

    /// 使用CollectionKit需要先提供一个Provider，提供有一个创建好的BasicProvider来使用，
    /// Provider需要提供三个source：DataSource、ViewSource、SizeSource，看名字是数据源，视图源，视图的尺寸源
    ///
    /// DataSource:ArrayDataSource、ClosureDataSource
    /// ViewSource:AnyViewSource、ClosureViewSource、ComposedViewSource
    /// SizeSource:SimpleViewSizeSource、UIImageSizeSource、AutoLayoutSizeSource、ColsureSizeSource
    
    /// Layout是用来对CollectionView进行布局的，
    let dataSource = ArrayDataSource(data: [1, 2, 3, 4,5,6,7,8,9])
    
    let viewSource = ClosureViewSource(viewUpdater: { (view: UILabel, data: Int, index: Int) in
        view.textAlignment = .center
        view.layer.cornerRadius = 2.0
        view.layer.masksToBounds = true
        view.backgroundColor = .red
        view.text = "\(data)"
    })
    
    let viewSource2 = ClosureViewSource(viewUpdater: { (view: UILabel, data: Int, index: Int) in
        view.textAlignment = .center
        view.layer.cornerRadius = 10.0
        view.layer.masksToBounds = true
        view.backgroundColor = .green
        view.text = "\(data)"
    })
    
    let sizeSource = { (index: Int, data: Int, collectionSize: CGSize) -> CGSize in
        return CGSize(width: 70, height: 60)
    }
    
    let collectionView = CollectionView()
    
    //lastly assign this provider to the collectionView to display the content
    override func viewDidLoad() {
        super.viewDidLoad()

        let provider = BasicProvider(
            dataSource: dataSource,
            viewSource: viewSource,
            sizeSource: sizeSource
        )
        
//        provider.layout = FlowLayout.init(lineSpacing: 10, interitemSpacing: 5)
//            .inset(by: UIEdgeInsets.init(top: 20, left: 10, bottom: 10, right: 10))
//            .transposed()
        
        let provider2 = BasicProvider(
            dataSource: dataSource,
            viewSource: viewSource2,
            sizeSource: sizeSource
        )
//        provider2.layout = RowLayout.init("cell")
//        .inset(by: UIEdgeInsets.init(top: 10, left: 5, bottom: 20, right: 5))
        provider2.animator = FadeAnimator()
        
        view.do {
            $0.addSubview(collectionView)
            $0.backgroundColor = .white
        }
        collectionView.do {
            $0.backgroundColor = .orange
            $0.snp.makeConstraints({ (make) in
                if #available(iOS 11.0, *) {
                    make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                    make.left.right.equalToSuperview()
                } else {
                    make.left.right.top.equalToSuperview()
                }
                make.height.equalTo(200)
            })
//            let comPro = ComposedProvider(
//                layout:FlowLayout.init(lineSpacing: 10, interitemSpacing: 5)
//                .inset(by: UIEdgeInsets.init(top: 20, left: 10, bottom: 10, right: 10)),
//                                          sections:[provider,provider2])
//            $0.provider = comPro
        }
        
        let dataSource22 = ArrayDataSource(data: Array(1...kGridSize.width * kGridSize.height), identifierMapper: { (_, data) in
            return "\(data)"
        })
        let visibleFrameInsets = UIEdgeInsets(top: -150, left: -150, bottom: -150, right: -150)
        let layout = Closurelayout(frameProvider: { (i: Int, _) in
            CGRect(x: CGFloat(i % kGridSize.width) * (kGridCellSize.width + kGridCellPadding),
                   y: CGFloat(i / kGridSize.width) * (kGridCellSize.height + kGridCellPadding),
                   width: kGridCellSize.width,
                   height: kGridCellSize.height)
        }).insetVisibleFrame(by: visibleFrameInsets)
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let provider22 = BasicProvider(
            dataSource: dataSource22,
            viewSource: { (view: UILabel, data: Int, index: Int) in
                view.backgroundColor = UIColor(hue: CGFloat(index) / CGFloat(kGridSize.width * kGridSize.height),
                                               saturation: 0.68, brightness: 0.98, alpha: 1)
                view.text = "\(data)"
        },
            layout: layout,
            animator: FadeAnimator()
        )
        collectionView.provider = provider22
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
