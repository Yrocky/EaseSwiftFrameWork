//
//  YYYTaskListReactor.swift
//  EaseSwiftFrameWork
//
//  Created by skynet on 2020/3/9.
//  Copyright © 2020 gmzb. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa


class TaskListReactor : Reactor {
    
    // 用户的操作，会引起状态的改变
    enum Action {
        // 在一个todo应用的人物列表界面中，
        // 可以下拉刷新、添加任务、修改任务的状态、移动任务、删除任务
        case refresh
        case editing
        case editingDone(IndexPath)
        case removeTask(IndexPath)
        case moveTask(IndexPath, IndexPath)
    }
    
    // 状态变化会导致什么结果
    enum Mutation {
        case editing
        case setTasks(TaskWrapper)
        case insertTask(IndexPath,TaskWrapper)
        case deleteTask(IndexPath)
        case moveTask(IndexPath,IndexPath)
    }
    
    // 可能会引起改变的状态
    struct State {
        var isEditing: Bool
        var tasks: [TaskWrapper]
    }

    // 设定好初始状态
    var initialState: State
    
    init() {
        initialState = State(
            isEditing: false, tasks: []
        )
    }

//    func mutate(action: Action) -> Observable<Mutation> {
//        
//        switch action {
//        case .refresh:
//            // 调用接口获取数据，返回接口的Observable
//        case .editing:
//            return .just(.editing)
//        case let .editingDone(indexPath):
//            
//        case let .removeTask(indexPath):
//            
//        case let .moveTask(source, destination):
//            
//        }
////        return TaskListReactor.Action.editing
//    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        var oldState = state
        switch mutation {
        case .editing:
            break
        case let .setTasks(tasks):
            break
        case let .insertTask(indexPath, task):
            break
        case let .deleteTask(indexPath):
            break
        case let .moveTask(source, destination):
            break
        }
        return oldState
    }
    
    func reactorForCreatingTask() {
        
    }
    func reactorForEditingTask() {
        
    }
}
