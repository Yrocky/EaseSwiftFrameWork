//
//  XXXQiLeAPI.swift
//  EaseSwiftFrameWork
//
//  Created by skynet on 2019/12/19.
//  Copyright © 2019 gmzb. All rights reserved.
//

import Foundation
import Moya

let QiLeProvider = MoyaProvider<QiLe>()

public enum QiLe{
    
    enum Login {
        
        case phoneLogin(phone: String, authCode: String)
    }
    
    // 动态相关
    enum Dynamic {
        case squeare(page : Int)
        case follow(page : Int)
        case user(dstUid : String, page : Int)
        
        case post(content : String, images : [String]?)
    }
    case Dynamicg
}

public enum QLSendAuthCodeType{
    case regist ///<注册 1
    case reset_password ///< 重置密码 3
    case bind_phoneNumber ///<绑定手机号 2
    case verify_phoneNumber ///<修改绑定手机号前先验证一下原来的手机号 1
    case modify_phoneNumber ///<修改绑定手机号 2
    case cancelAccount_sure ///<账户注销 1
    case cancelAccount_undo ///<撤销注销账号 2
}

public enum QiLeLoginApi {

    case sendAuthCode(phone : String, type : QLSendAuthCodeType)

    case regist(phone: String, password: String, authCode: String, recUid: String)
    
    case phoneLogin(phone: String, password: String)
    case wechatLogin(userInfo: Dictionary<String, Any>, recUid: String)
    case qqLogin(userInfo: Dictionary<String, Any>, recUid: String)
    case appleLogin(uid: String, authCode: String, identityToken: String, recUid: String)
    
    case resetPassword(phone: String, newPassword: String, authCode: String)
    
    case writeOff(authCode: String, undoToken: String)
    case cancelWriteOff(authCode: String, undoToken: String)
}

public enum QiLeDynamicApi {
    
    case squeare(page : Int)
    case follow(page : Int)
    case user(dstUid : String, page : Int)
    
    case post(content : String, images : [String]?)
    
    case detail(dynamicId : String)
    case zan(dynamiceId : String, _ zan : Bool)
    case delete(dynamicId : String)
    case commentDynamic(dynamiceId : String, content: String)
    case commentComment(dynamicId : String, content : String, tid : String, commentId : String)
    case deleteComment(dynamiceId : String, commentId : String)
}

//public enum QiLePKApi {
//
//}

extension QiLeDynamicApi : NetworkTargetType {
    
    ////<基础服务器地址
        public var baseURL: URL {
            return URL(string: "https://api.ixjdx.cn/")!
        }
        ///<请求的路径
        public var path: String {
            ""
        }
        
        public var method: Moya.Method {
            .get
        }
        
        //请求任务事件（这里附带上参数）
        public var task: Task {
            .requestPlain
        }
    //        switch self {
    //        case .phoneLogin(let phone, let authCode):
    //            var params: [String: Any] = [:]
    //            params["phone_number"] = phone
    //            params["code"] = authCode
    //            return .requestParameters(parameters: params,
    //                                      encoding: URLEncoding.default)
    //        case .regist(let userName, let nickName, let password, let age, let sex):
    //            var params: [String: Any] = [:]
    //            params["username"] = userName
    //            params["nick_name"] =  nickName
    //            params["password"] = password
    //            params["age"] = age
    //            params["sex"] = sex
    //            return .requestParameters(parameters: params,
    //                                      encoding: URLEncoding.default)
    //        case .sendAuthCode(let phone):
    //            return .requestParameters(parameters: ["phone_number": phone],
    //                                      encoding: URLEncoding.default)
    //        case .dynamicList(let lastDynamicId):
    //            var params: [String: Any] = [:]
    //            params["size"] = 20
    //            if let lastDynamicId = lastDynamicId{
    //                params["id"] = lastDynamicId
    //            }
    //            return .requestParameters(parameters: params,
    //                                      encoding: URLEncoding.default)
    //        default:
    //            return .requestPlain
    //        }
    //    }
        
        public var sampleData: Data {
            return "{}".data(using: String.Encoding.utf8)!
        }
        
        ///<设置请求头
        public var headers: [String : String]? {
            var httpHeader = ["meme-app": "makefriend"]
            if true {
                httpHeader["cookie"] = EaseUserDefault.stringValue(for: MakeFriendCookieKey)
            }
            return httpHeader
        }
        
        
        public func requestCompleteFilter(moyaResponse: Response, response: Any?) -> Any? {
            
            if let Cookie : String = moyaResponse.response?.allHeaderFields["Cookie"] as? String {
                EaseUserDefault.add(Cookie, for: MakeFriendCookieKey)
            }
            
    //        switch self {
    //        case .regist(_,_,_,_,_):
    //            if let data = response as? Dictionary<String, Any>,
    //                let user = User.deserialize(from: data){
    //                return user
    //            }
    //        case .dynamicList(_):
    //            print("[network][dynamic]:\(response)")
    //            break
    //        default:
    //            return response
    //        }

            return response
        }
        
        public func requestFailedFilter(MoyaError: Any) {
            
        }
}
extension QiLe: NetworkTargetType {
    
    ////<基础服务器地址
    public var baseURL: URL {
        return URL(string: "https://api.ixjdx.cn/")!
    }
    ///<请求的路径
    public var path: String {
        ""
    }
    
    public var method: Moya.Method {
        .get
    }
    
    //请求任务事件（这里附带上参数）
    public var task: Task {
        .requestPlain
    }
//        switch self {
//        case .phoneLogin(let phone, let authCode):
//            var params: [String: Any] = [:]
//            params["phone_number"] = phone
//            params["code"] = authCode
//            return .requestParameters(parameters: params,
//                                      encoding: URLEncoding.default)
//        case .regist(let userName, let nickName, let password, let age, let sex):
//            var params: [String: Any] = [:]
//            params["username"] = userName
//            params["nick_name"] =  nickName
//            params["password"] = password
//            params["age"] = age
//            params["sex"] = sex
//            return .requestParameters(parameters: params,
//                                      encoding: URLEncoding.default)
//        case .sendAuthCode(let phone):
//            return .requestParameters(parameters: ["phone_number": phone],
//                                      encoding: URLEncoding.default)
//        case .dynamicList(let lastDynamicId):
//            var params: [String: Any] = [:]
//            params["size"] = 20
//            if let lastDynamicId = lastDynamicId{
//                params["id"] = lastDynamicId
//            }
//            return .requestParameters(parameters: params,
//                                      encoding: URLEncoding.default)
//        default:
//            return .requestPlain
//        }
//    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    ///<设置请求头
    public var headers: [String : String]? {
        var httpHeader = ["meme-app": "makefriend"]
        if true {
            httpHeader["cookie"] = EaseUserDefault.stringValue(for: MakeFriendCookieKey)
        }
        return httpHeader
    }
    
    
    public func requestCompleteFilter(moyaResponse: Response, response: Any?) -> Any? {
        
        if let Cookie : String = moyaResponse.response?.allHeaderFields["Cookie"] as? String {
            EaseUserDefault.add(Cookie, for: MakeFriendCookieKey)
        }
        
//        switch self {
//        case .regist(_,_,_,_,_):
//            if let data = response as? Dictionary<String, Any>,
//                let user = User.deserialize(from: data){
//                return user
//            }
//        case .dynamicList(_):
//            print("[network][dynamic]:\(response)")
//            break
//        default:
//            return response
//        }

        return response
    }
    
    public func requestFailedFilter(MoyaError: Any) {
        
    }
}
