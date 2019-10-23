//
//  EaseCommand.swift
//  EaseSwiftFrameWork
//
//  Created by skynet on 2019/7/22.
//  Copyright © 2019 gmzb. All rights reserved.
//

import Foundation
import SwifterSwift

typealias CommandCallback = (Command) -> Void

protocol CommandDelegate {

    func commandDidFinish(_ command: Command)
    func commandDidCancel(_ command: Command)
}

protocol Command{
//    associatedtype E
    
    var context : Dictionary<String, Any>? {get set}
    
    var delegate : CommandDelegate? {get set}
    var callback : CommandCallback? {get set}
    
    func execute()
    mutating func cancel()
    mutating func done()
}

struct EaseCommand : Equatable{
    
//    let selfPointer = UnsafeMutablePointer(&self)

}

class EaseCommandManager{
    
    private var commands : Array<Command>?
    
    static let manager = EaseCommandManager()
    
    func add(command : Command?){
        guard let command = command else { return }
        commands?.append(command)
    }
    
    func cancel(command : Command?) {
        guard let command = command else { return }

        commands?.drop(while: { (inCommand) -> Bool in
            return false
//            return inCommand == command
        })
    }
}

extension EaseCommand : Command {
    
    var context: Dictionary<String, Any>? {
        get {
            return nil
        }
        set {
            
        }
    }
    
    var delegate: CommandDelegate? {
        get {
            return nil
        }
        set {
            
        }
    }
    
    var callback: CommandCallback? {
        get {
            return nil
        }
        set {
            
        }
    }
    
    func execute() {
        
    }
    
    mutating func cancel() {
        
        self.delegate = nil
        self.callback = nil
        delegate?.commandDidCancel(self)
    }
    
    mutating func done() {
        
        DispatchQueue.main.async {
//            delegate?.commandDidFinish(selfPointer)
            
        }
    }
}
