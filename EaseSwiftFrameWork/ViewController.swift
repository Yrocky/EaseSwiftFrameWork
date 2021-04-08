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
struct Stack<E> {

    fileprivate var array = [E]()

    init() {}
    
    init(with array: [E]) {
        self.array = array
    }
    
    var isEmpty: Bool {
        array.isEmpty
    }
    
    var top: E? {
        array.last
    }
    
    mutating func push(_ element: E) {
       array.append(element)
    }
    
    mutating func pop() -> E? {
        array.popLast()
    }
}

struct MinStack<E: Comparable> {

    var mainStack = Stack<E>()
    var minStack = Stack<E>()
    
    var isEmpty: Bool { mainStack.isEmpty }
    
    mutating func push(_ element: E) {
    
        mainStack.push(element)
    
        if let minStackTop = minStack.top {
           if element <= minStackTop {
               minStack.push(element)
           }
        } else {
            minStack.push(element)
        }
    }
    
    mutating func pop() -> E? {
        
        if isEmpty { return nil }
        
        let mainStackTop = mainStack.pop()
        let minStackTop = minStack.top
                
        if mainStackTop == minStackTop { minStack.pop() }
        
        return mainStackTop
    }
    
    func min() -> E? {
        return minStack.top
    }
}


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
            XXXRouter(
                title: "CompositionalLayout",
                destion: XXXCompositionalLayoutViewController.self
            ),
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
        
        onButton()
        
        tableView.deselectRow(at: indexPath, animated: true)
//        let router = routers[indexPath.row];
//
//        let vc = router.destion.init()
//        vc.title = router.title
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func onButton() {

        
        var mainStack = Stack(with: [4,1,3,7,9,2,11,6,1])

        var sortedStack = Stack<Int>()

        while !mainStack.isEmpty {
            
            let mainStackTop = mainStack.pop()!
            
            if let sortedStackTop = sortedStack.top {
                
                if sortedStackTop < mainStackTop {
                    
                    while let sortedTop = sortedStack.top,
                          sortedTop < mainStackTop {
                        if let top = sortedStack.pop() {
                            mainStack.push(top)
                        }
                    }
                }
            }
            sortedStack.push(mainStackTop)
        }

        while !sortedStack.isEmpty {
            print("\(sortedStack.pop())")
        }
        
//        UIView.animate(withDuration: 2.0, animations: {
//            self.displayView.layer.position.x = 200.0
//        }) { _ in
//            self.displayView.layer.position.x = 300
//        }
//        UIView.animate(duration: 2.0, animations: {
//            self.displayView.layer.position.x = 200.0
//        })
//        self.present(XXXFansListViewController(), animated: true, completion: nil)
        
//        self.present(XXXCollectionKitViewController(), animated: true, completion: nil)
    }


}

