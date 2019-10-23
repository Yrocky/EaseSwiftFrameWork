//
//  BaseTableViewController.swift
//  EaseSwiftFrameWork
//
//  Created by skynet on 2019/7/17.
//  Copyright © 2019 gmzb. All rights reserved.
//

import UIKit
import SnapKit
import PullToRefreshKit
import Then

struct EaseTablePageWrapper {
    
    var isRefresh = true///<是否是下拉刷新
    var index = 1
    var origIndex = 1
    var size = 20
    
    mutating func refresh() {
        index = origIndex;
        isRefresh = true
    }
    mutating func loadMore() {
        index += 1
        isRefresh = false
    }
}

class BaseTableViewController: BaseViewController {

    private var pageWrapper = EaseTablePageWrapper()
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: .zero, style: .grouped)
        view.separatorStyle = .none
        view.tableHeaderView = nil
        view.tableFooterView = nil
        view.delegate = self;
        view.dataSource = self;
        view.estimatedRowHeight = 0;
        view.estimatedSectionHeaderHeight = 0;
        view.estimatedSectionFooterHeight = 0;
        view.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        let headerView = UIView()
        headerView.frame = CGRect.init(origin: .zero, size: CGSize.init(width: 0, height: 0.01))
        view.tableHeaderView = headerView
        let footerView = UIView()
        footerView.frame = CGRect.init(origin: .zero, size: CGSize.init(width: 0, height: 0.01))
        view.tableFooterView = footerView
        view.backgroundColor = .white
        view.rowHeight = 44.0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(self.tableView)

        self.tableView.snp.makeConstraints { (make) -> Void in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.left.right.equalToSuperview()
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.edges.equalToSuperview()
            }
        }
        
        if addRefresh() {
            self.tableView.configRefreshHeader(container:self) { [weak self] in
                self?.onRefresh()
            }
        }
        if addLoadMore() {
            self.tableView.configRefreshFooter(container:self) { [weak self] in
                self?.onLoadMore()
            };
        }
        if loadRefreshWhenViewDidLoad() && addRefresh() {
           onRefresh()
        }
    }
}

@objc extension BaseTableViewController {
    
    func loadRefreshWhenViewDidLoad() -> Bool {
        return true
    }
    
    func addRefresh() -> Bool {
        return true
    }
    func addLoadMore() -> Bool {
        return false
    }
    
    func endRefresh() {
        self.tableView.switchRefreshHeader(to: .normal(.success, 0.25))
    }
    func endLoadMore(_ noMoreData : Bool) {
        self.tableView.switchRefreshFooter(to: noMoreData ? .noMoreData : .normal)
    }
    
    func onRefresh() {
        self.pageWrapper.refresh()
        self.tableView.switchRefreshFooter(to: .normal)
    }
    func onLoadMore() {
        self.pageWrapper.loadMore()
    }
}

extension BaseTableViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = .red
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}

extension BaseTableViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
