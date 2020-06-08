//
//  XXXRxSwiftViewController.swift
//  EaseSwiftFrameWork
//
//  Created by skynet on 2019/12/19.
//  Copyright © 2019 gmzb. All rights reserved.
//

import Foundation
import RxSwift
import SnapKit

class XXXRxSwiftViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton()
        button.backgroundColor = .red
        button.rx.controlEvent(.touchUpInside)
            .subscribe { (result) in
            print("button did touch up inside")
        }.disposed(by: disposeBag)
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 50, height: 30))
            make.center.equalToSuperview()
        }
        
        doEmpty()
        doJust()
        NetworkAdapter<QiLeDynamicApi>.request(.squeare(page: 1), success: { (channels) in
            
        }) { (error) in
            print("[network][error]\(error)")
        }
    }
    
    func doEmpty() {
        // 创建一个empty，empty是灭有序列的，创建完就直接执行
        Observable<Int>.empty().subscribe(onNext: { (value) in
            
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }) {
            
        }
    }
    func doJust() {
        let array = ["aaa","bbb"]
        // 这里的observable接收的是一个字符串数组，也就是说，会监听这个数组中的每一个元素，相当于遍历数组
        Observable<[String]>.just(array).subscribe(onNext: { (value) in
            print("订阅数据:",value)
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }) {
            
        }
        Observable<[String]>.just(array).subscribe { (event) in
            print("event",event)
        }
    }
}
