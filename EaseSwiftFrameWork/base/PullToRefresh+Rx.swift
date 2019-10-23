//
//  PullToRefresh+Rx.swift
//  EaseSwiftFrameWork
//
//  Created by skynet on 2019/7/24.
//  Copyright © 2019 gmzb. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import PullToRefreshKit

///<对PullToRefreshKit进行RxSwift的拓展
extension Reactive where Base : RefreshHeaderContainer {

    //正在刷新事件
//    var refreshing: ControlEvent<Void> {
//        let source: Observable<Void> = Observable.create {
//            [weak control = self.base] observer  in
//            if let control = control {
//                control.refreshingBlock = {
//                    observer.on(.next(()))
//                }
//            }
//            return Disposables.create()
//        }
//        return ControlEvent(events: source)
//    }
//
    var refreshing: ControlEvent<Void> {
        let source: Observable<Void> = Observable.create {
            [weak control = self.base] observer in
            
            if let control = control {
//                control.refreshAction = {
//                }
                
                observer.on(.next(()))
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
//    //停止刷新
//    var endRefreshing: Binder<Bool> {
//        return Binder(base) { refresh, isEnd in
//            if isEnd {
//                refresh.endRefreshing()
//            }
//        }
//    }
    
}
