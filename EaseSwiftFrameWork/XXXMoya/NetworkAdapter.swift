//
//  NetworkAdapter.swift
//  EaseSwiftFrameWork
//
//  Created by skynet on 2019/7/22.
//  Copyright © 2019 gmzb. All rights reserved.
//

import Foundation
import Moya

typealias NetworkSuccessCallback = (Any?) -> Void
typealias NetworkFailureCallback = (MoyaError) -> Void

public protocol NetworkTargetType : TargetType {
    
    ///<请求成功之后可以这个方法内部进行过滤
    func requestCompleteFilter(moyaResponse: Response, response : Any?) -> Any?
    ///<请求失败
    func requestFailedFilter(MoyaError : Any)
}

struct NetworkAdapter<Module: NetworkTargetType> {
    
    static func request(
        _ target: Module,
        success successCallback: @escaping NetworkSuccessCallback,
        failure failureCallback: NetworkFailureCallback?
        ) {
        MoyaProvider<Module>().request(target) { result in
            print("[network]:\(result)")
            switch result {
            case let .success(moyaResponse):
                do {
                    //如果数据返回成功则直接将结果转为JSON
                    try _ = moyaResponse.filterSuccessfulStatusCodes()
                    let response = try moyaResponse.mapJSON()
                    DispatchQueue.main.async {
                        successCallback(target.requestCompleteFilter(moyaResponse: moyaResponse, response: response))
                    }
                }
                catch _ {
                    //如果数据获取失败，则返回错误状态码
                    failureCallback?(.jsonMapping(moyaResponse))
                }
            case let .failure(error):
                failureCallback?(error)
            }
        }
    }
}
