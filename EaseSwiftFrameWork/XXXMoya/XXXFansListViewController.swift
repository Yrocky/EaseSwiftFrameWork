//
//  XXXFansListViewController.swift
//  EaseSwiftFrameWork
//
//  Created by skynet on 2019/7/22.
//  Copyright © 2019 gmzb. All rights reserved.
//

import UIKit
import Alamofire
import RxCocoa
import RxSwift

class XXXFansListViewController: BaseTableViewController {

    private var dataSource : Array<XXXDouBanChannel> = []
    
    private let allCities = ["1-beijing","2-shanghai","3-guangzhou","4-shenzhen","5-hangzhou"]
    var showCities = [String]()
    
    var searchBar = UISearchBar()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.frame = CGRect.init(origin: .zero, size: CGSize.init(width: view.width, height: 40))
        
        title = "fans list"
        self.tableView.do {
            $0.register(cellWithClass: UITableViewCell.self)
            $0.tableHeaderView = searchBar
        }
        
        searchBar
            .rx.text // Observable property thanks to RxCocoa
            .orEmpty // 挑选非空的字符串 Make it non-optional
            .debounce(0.5, scheduler: MainScheduler.instance) // 0.5秒的间隔才进行下一步
            .distinctUntilChanged() // 确保只要最新的值
//            .filter { !$0.isEmpty } // If the new value is really new, filter for non-empty query.
            .subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value, that is not empty (thanks to filter above).
                print("query:\(query)")
                
                self.showCities = self.allCities.filter({
                    $0.contains(query)
                })
                //self.shownCities = self.allCities.filter { $0.hasPrefix(query) } // We now do our "API Request" to find cities.
                self.tableView.reloadData() // And reload table view data.
            })
            .disposed(by: disposeBag)
    }
}

extension XXXFansListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
        return self.showCities.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: UITableViewCell.self)
//        cell.textLabel?.text = self.showCities[indexPath.row]
        cell.textLabel?.text = self.dataSource[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        
//        NetworkAdapter<MakeFriend>.request(.sendAuthCode(phone: "15538986381"), success: { (rsp) in
//
//        }, failure: nil)

//        NetworkAdapter<MakeFriend>.request(.regist(userName: "r7sdfsds", nickName: "23osfsdfs23", password: "11111111", age: 19, sex: 1), success: { (userInfo) in
//
//            if let user = userInfo {
//                print("[network][regist]:\(user)")
//            }
//        }) { (error) in
//            print("[network][error]:\(error)")
//        }
        NetworkAdapter<MakeFriend>.request(.dynamicList(lastDynamicId: nil), success: { (list) in

        }) { (error) in

        }
        return
        NetworkAdapter<MakeFriend>.request(.phoneLogin(phone: "15538986381", authCode: "1163"), success: { (rsp) in
            
        }) { (error) in
            print("[network][error]\(error)")
        }
        return
        let channel = self.dataSource[indexPath.row]
        NetworkAdapter<DouBan>.request(.playList(key: channel.channel_id!), success: { (song) in
            if let song = song as? XXXDouBanSong{
                print("song:\(song)")
            }
        }, failure: nil)
    }
}

extension XXXFansListViewController {
    ///<重写下拉刷新等逻辑
    override func addLoadMore() -> Bool {
        return true
    }
    
    override func onRefresh() {
        super.onRefresh()

        if false {
            ///最原始的使用alamofire来进行网络请求
            Alamofire.request("https://www.douban.com/j/app/radio/channels", method: .get).responseJSON { (response) in
            
            if 200 == response.response?.statusCode &&
                response.result.isSuccess,
                let data = response.result.value as? Dictionary<String, Array<Any>>,
                let channels = data["channels"] ,
                let channelWraps = [XXXDouBanChannel].deserialize(from: channels){
                self.dataSource.removeAll()
                channelWraps.forEach({ (channel) in
                    self.dataSource.append(channel!)
                })
                self.tableView.reloadData()
            }
            self.endRefresh()
            }
        } else if false {
            ///使用moya封装过后进行网络请求，
            DouBanProvider.request(DouBan.channels) { result in
                if case let .success(value) = result {
                    let responseData = try? value.mapJSON()

                    print("responseData:\(String(describing: responseData))")
                    
                    if let data = responseData as? Dictionary<String, Array<Any>>,
                    let channels = [XXXDouBanChannel].deserialize(from: data["channels"]){
                        self.dataSource = channels as! Array<XXXDouBanChannel>
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.endRefresh()
                        }
                    }
                }
            }
        } else {
            ///在moya的基础上进行封装网络请求
            NetworkAdapter<DouBan>.request(.channels, success: { (channels) in
                if let channels = channels {
                    self.dataSource = channels as! Array<XXXDouBanChannel>
                    self.tableView.reloadData()
                }
                self.endRefresh()
            }) { (error) in
                print("[network][error]\(error)")
                self.endRefresh()
            }
        }
    }
    
    override func onLoadMore() {
        super.onLoadMore()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.endLoadMore(true)
        }
    }
}
