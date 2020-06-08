//
//  UIControlSubscription.swift
//  EaseSwiftFrameWork
//
//  Created by skynet on 2020/3/24.
//  Copyright © 2020 gmzb. All rights reserved.
//

import Foundation
import Combine
import UIKit

final class UIControlSubscription<SubscriberType: Subscriber, Control: UIControl>: Subscription where SubscriberType.Input == Control {
    
    
    private var subscriber: SubscriberType?
    private let control: Control
    
    init(subscriber: SubscriberType, control: Control, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
//: 为要拓展的控件绑定target-action事件，将自己成为响应者
        control.addTarget(self, action: #selector(onEvent), for: event)

    }
//: 由于本类实现了`Subscription`协议，所以需要实现下面的两个方法
    func request(_ demand: Subscribers.Demand) {
        
    }
    
    func cancel() {
        subscriber = nil
    }
    
//:实现对应的响应方法，当控件发生响应时间的时候，在这里将事件交给订阅者，前面已经设置了`SubscriberType.Input == Control`，所以这里是将当前控件传递出去
    
    @objc private func onEvent() {
        _ = subscriber?.receive(control)
    }
}

struct UIControlPublisher<Control: UIControl>: Publisher {
    
    typealias Output = Control
    typealias Failure = Never
    
//: 设置两个属性用来保存数据
    let control: Control
    let event: UIControl.Event
    
    init(control: Control, event: UIControl.Event) {
        self.control = control
        self.event = event
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, UIControlPublisher.Failure == S.Failure,
        UIControlPublisher.Output == S.Input {
            let subscription = UIControlSubscription(subscriber: subscriber, control: control, event: event)
            subscriber.receive(subscription: subscription)
    }
}

//: 在做完了上面的所有之后，就可以为UIControl添加

protocol CombineCompatible{}
extension UIControl: CombineCompatible{}

extension CombineCompatible where Self: UIControl {
    func publisher(for event: UIControl.Event) -> UIControlPublisher<UIControl> {
        return UIControlPublisher(control: self, event: event)
    }
}
