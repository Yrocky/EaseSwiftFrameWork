//
//  XXXViewReactor.swift
//  EaseSwiftFrameWork
//
//  Created by skynet on 2019/7/29.
//  Copyright © 2019 gmzb. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

// 定义一个Reactor的子类，用来将view中的事件进行传递
final class XXXViewReactor: Reactor {

    //代表用户行为，可以是用户点击，用户的手势等等，都是从View层传递过来的事件
    enum Action {
        case increase //加一操作
        case decrease //减一操作
    }
    
    //代表状态变化，View层传递过来的action进行转化
    enum Mutation {
        case increaseValue //数字加一
        case decreaseValue //数字减一
        case setLoading(Bool) //设置加载状态
    }
    
    //代表页面状态
    struct State {
        var value: Int //当前数字
        var isLoading: Bool  //当前加载状态
    }
    
    //初始页面状态
    let initialState: State
    
    init() {
        self.initialState = State(
            value: 0,
            isLoading: false
        )
    }
    
    //实现 action 到 mutate的变化
    func  mutate(action: XXXViewReactor.Action) -> Observable<XXXViewReactor.Mutation> {
        
        guard !self.currentState.isLoading else { return .empty() }

        switch action {
        case .increase:
            // 在这里将action转化成网络请求等操作
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.increaseValue)
                    .delay(1.0, scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
                ])
        case .decrease:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.decreaseValue)
                    .delay(1.0, scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
                ])
        }
    }
    
    //实现 mutate 到 state 的变化
    func reduce(state: XXXViewReactor.State, mutation: XXXViewReactor.Mutation) -> XXXViewReactor.State {
     
        // state是旧状态
        var oldStats = state
        switch mutation {
        case .increaseValue:
            oldStats.value += 1
        case .decreaseValue:
            oldStats.value -= 1
        case let .setLoading(isLoading):
            oldStats.isLoading = isLoading
        }
        return oldStats
    }
}
