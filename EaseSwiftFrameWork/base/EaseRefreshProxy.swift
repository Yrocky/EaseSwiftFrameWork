//
//  EaseRefreshProxy.swift
//  EaseSwiftFrameWork
//
//  Created by skynet on 2020/6/2.
//  Copyright © 2020 gmzb. All rights reserved.
//

import Foundation
import UIKit

class EaseRefreshProxy {
    
    private var isRefresh: Bool = true
    private var index: Int = 0
    private var origIndex: Int = 0
    private var size: Int = 0
    
    private var scrollView: UIScrollView?
    
    init(with scrollView: UIScrollView) {
        self.scrollView = scrollView
        
    }
    
    func setup(origIndex: Int, size: Int) {
        self.origIndex = origIndex
        index = origIndex
        self.size = size
    }
}

extension EaseRefreshProxy{
    
    func addRefresh(action:@escaping ()->()) {
        scrollView?.configRefreshHeader(container:self) { [weak self] in
            self?._refresh()
            action()
        }
    }
    
    func onRefresh() {
        scrollView?.switchRefreshFooter(to: .refreshing)
    }
    
    func endRefresh() {
        isRefresh = true
        index = origIndex
        scrollView?.switchRefreshHeader(to: .normal(.success, 0.25))
    }
    
    private func _refresh() {
        isRefresh = true
        index = origIndex
    }
}

extension EaseRefreshProxy {
    
    func addLoadMore(action:@escaping ()->()) {
        scrollView?.configRefreshHeader(container:self) { [weak self] in
            self?._loadMore()
            action()
        }
    }
    
    func onLoadMore() {
        scrollView?.switchRefreshFooter(to: .refreshing)
    }
    
    func endLoadMore(_ noMoreData : Bool) {
        scrollView?.switchRefreshFooter(to: noMoreData ? .noMoreData : .normal)
    }
    
    func noMoreData() {
        
    }
    
    private func _loadMore() {
        index += 1
        isRefresh = false
    }
}
