//
//  XXXReactorKitViewController.swift
//  EaseSwiftFrameWork
//
//  Created by skynet on 2019/7/29.
//  Copyright © 2019 gmzb. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

class XXXReactorKitViewController: BaseViewController,View {
    
    typealias Reactor = XXXViewReactor
    
    let plus = UIButton()
    let minus = UIButton()
    let valueLabel = UILabel()
    let activityView = UIActivityIndicatorView(style: .gray)
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = XXXViewReactor()
        
        valueLabel.do {
            view.addSubview($0)
            $0.textColor = .red
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 14)
        }
        
        plus.do {
            view.addSubview($0)
            $0.backgroundColor = .orange
            $0.setTitle("+", for: .normal)
        }
        
        minus.do {
            view.addSubview($0)
            $0.backgroundColor = .orange
            $0.setTitle("-", for: .normal)
        }
        
        activityView.do {
            view.addSubview($0)
            $0.hidesWhenStopped = true
        }
        
        valueLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(minus.snp.left)
            make.left.equalTo(plus.snp.right)
            make.centerY.equalTo(self.plus)
        })
        
        activityView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.top.equalTo(valueLabel.snp.bottom).offset(10)
            make.centerX.equalTo(valueLabel)
        }
        plus.snp.makeConstraints({ (make) in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.left.equalToSuperview().offset(50)
            make.top.equalToSuperview().offset(230)
        })
        
        minus.snp.makeConstraints({ (make) in
            make.size.equalTo(self.plus)
            make.right.equalToSuperview().offset(-50)
            make.top.equalTo(self.plus)
        })
        // Do any additional setup after loading the view.
    }
    
    /// 在这里将view中的控件动作进行绑定转换
    func bind(reactor: XXXViewReactor) {
        
        // Action，实现View到Reactor的转换
        plus.rx.tap
            .map { Reactor.Action.increase }/// 将点击的操作转化成Action的increase
            .bind(to: reactor.action)/// 将action绑定到
            .disposed(by: disposeBag)
        
        minus.rx.tap
            .map{ Reactor.Action.decrease }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // State，实现Reactor到View的绑定
        reactor.state.map { $0.value }
            .distinctUntilChanged()
            .map{ "\($0)" }
            .bind(to: valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: activityView.rx.isAnimating)
            .disposed(by: disposeBag)
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
