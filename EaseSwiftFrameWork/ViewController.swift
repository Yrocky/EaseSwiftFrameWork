//
//  ViewController.swift
//  EaseSwiftFrameWork
//
//  Created by skynet on 2019/7/17.
//  Copyright © 2019 gmzb. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import EasyAnimation

class DemoCell: UITableViewCell, Reusable {
    
}

struct XXXRouter {
    var title: String?
    var destion: UIViewController.Type
}

class ViewController: BaseTableViewController {

    let disposeBag = DisposeBag()
    
    var routers = [XXXRouter]()
    
    let displayView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Root"
        
        routers.append(contentsOf: [
            XXXRouter(title: "Combine", destion: XXXCombineViewController.self),
            XXXRouter(title: "Moya", destion: XXXFansListViewController.self),
            XXXRouter(title: "CollectionKit", destion: XXXCollectionKitViewController.self),
            XXXRouter(title: "ReactorKit", destion: XXXReactorKitViewController.self),
            XXXRouter(title: "RxSwift", destion: XXXRxSwiftViewController.self),
            XXXRouter(title: "Codable", destion: XXXCodableViewController.self),
            XXXRouter(title: "CollectionView", destion: XXXCollectionViewController.self),
        ])
        tableView.register(cellWithClass: UITableViewCell.self)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func addRefresh() -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routers.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withClass: UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = self.routers[indexPath.row].title!
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let router = routers[indexPath.row];
        
        let vc = router.destion.init()
        vc.title = router.title
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func onButton() {

        UIView.animate(withDuration: 2.0, animations: {
            self.displayView.layer.position.x = 200.0
        }) { _ in
            self.displayView.layer.position.x = 300
        }
//        UIView.animate(duration: 2.0, animations: {
//            self.displayView.layer.position.x = 200.0
//        })
//        self.present(XXXFansListViewController(), animated: true, completion: nil)
        
//        self.present(XXXCollectionKitViewController(), animated: true, completion: nil)
    }


}

