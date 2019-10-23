//
//  XXXMakeFriendAPI.swift
//  EaseSwiftFrameWork
//
//  Created by skynet on 2019/7/23.
//  Copyright © 2019 gmzb. All rights reserved.
//

import Foundation
import Moya

let MakeFriendvider = MoyaProvider<MakeFriend>()
let MakeFriendCookieKey = "cookie"

public enum MakeFriend {
    
    ///<登录注册模块
    case regist(userName: String, nickName: String, password: String, age: Int ,sex: Int)
    case phoneLogin(phone: String, authCode: String)
    case accountLogin(account: String, password: String)
    case sendAuthCode(phone: String)
    case logout
    
    ///<动态模块
    case postDynamic(text: String, imageUrl: String)
    case userDynamicList(lastDynamicId: String?, uid: String)
    case dynamicList(lastDynamicId: String?)
    case dynamicDetail(dynamicId: String)
    case zanDynamic(dynamicId: String)
    case reportDynamic(dynamicId: String, type: Int)
    case commentDynamic(dynamicId: String, text: String)
    
    ///<消息模块
    case allUnreadMessage
    case unreadMessage(uid: String)
    case sendMessage(uid: String, text: String)
    
    ///<个人信息模块
    case userInfo(uid: String)
    case modifUserInfo
    case uploadImage
    case blackList
    case addBlackList(uid: String)
    case removeBlackList(uid: String)
    
    case checkVersion
    case bannerList
    case newFeature
}

extension MakeFriend: NetworkTargetType {
    ////<基础服务器地址
    public var baseURL: URL {
        return URL(string: "https://api.ixjdx.cn/")!
    }
    ///<请求的路径
    public var path: String {
        switch self {
        case .regist(_, _, _, _, _):
            return "user/register"
        case .phoneLogin(_, _):
            return "user/login/phone"
        case .accountLogin(_, _):
            return "user/login"
        case .sendAuthCode(_):
            return "user/login/phone-code"
        case .logout:
            return "user/logout"
        case .postDynamic(_, _):
            return "dynamic/commit"
        case .userDynamicList(_, _):
            return "dynamic/list"
        case .dynamicList(_):
            return "dynamic/page"
        case .dynamicDetail(_):
            return "dynamic/info"
        case .zanDynamic(_):
            return "dynamic/up"
        case .reportDynamic(_, _):
            return "dynamic/report"
        case .commentDynamic(_, _):
            return "dynamic/comment"
        case .allUnreadMessage:
            return "email/unread/users"
        case .unreadMessage(_):
            return "email/unread/messages"
        case .sendMessage(_, _):
            return "email/send"
        case .userInfo(_):
            return "user/info"
        case .modifUserInfo:
            return "user/update-info"
        case .uploadImage:
            return "qiniu/token/upload-img"
        case .blackList:
            return "blacklist/list"
        case .addBlackList(_):
            return "blacklist/add"
        case .removeBlackList(_):
            return "blacklist/remove"
        case .checkVersion:
            return "webview/status"
        case .bannerList:
            return "banner/get"
        case .newFeature:
            return "h5/status"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .regist(_, _, _, _, _),
             .phoneLogin(_, _),
             .accountLogin(_, _),
             .commentDynamic(_, _),
             .postDynamic(_, _),
             .reportDynamic(_, _),
             .zanDynamic(_),
             .sendMessage(_, _),
             .modifUserInfo:
            return .post
        default:
            return .get
        }
    }
    
    //请求任务事件（这里附带上参数）
    public var task: Task {
        switch self {
        case .phoneLogin(let phone, let authCode):
            var params: [String: Any] = [:]
            params["phone_number"] = phone
            params["code"] = authCode
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.default)
        case .regist(let userName, let nickName, let password, let age, let sex):
            var params: [String: Any] = [:]
            params["username"] = userName
            params["nick_name"] =  nickName
            params["password"] = password
            params["age"] = age
            params["sex"] = sex
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.default)
        case .sendAuthCode(let phone):
            return .requestParameters(parameters: ["phone_number": phone],
                                      encoding: URLEncoding.default)
        case .dynamicList(let lastDynamicId):
            var params: [String: Any] = [:]
            params["size"] = 20
            if let lastDynamicId = lastDynamicId{
                params["id"] = lastDynamicId
            }
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    ///<设置请求头
    public var headers: [String : String]? {
        var httpHeader = ["meme-app": "makefriend"]
        if self.isSecurityRequest() {
            httpHeader["cookie"] = EaseUserDefault.stringValue(for: MakeFriendCookieKey)
        }
        return httpHeader
    }
    
    
    public func requestCompleteFilter(moyaResponse: Response, response: Any?) -> Any? {
        
        if let Cookie : String = moyaResponse.response?.allHeaderFields["Cookie"] as? String {
            EaseUserDefault.add(Cookie, for: MakeFriendCookieKey)
        }
        
        switch self {
        case .regist(_,_,_,_,_):
            if let data = response as? Dictionary<String, Any>,
                let user = User.deserialize(from: data){
                return user
            }
        case .dynamicList(_):
            print("[network][dynamic]:\(response)")
            break
        default:
            return response
        }

        return response
    }
    
    public func requestFailedFilter(MoyaError: Any) {
        
    }
}

extension MakeFriend {
    ///< 这里进行自有业务逻辑的处理
    func isSecurityRequest() -> Bool {
        switch self {
        case .logout,
             .userDynamicList(_, _),
             .dynamicList(_),
             .dynamicDetail(_),
             .commentDynamic(_, _),
             .postDynamic(_, _),
             .reportDynamic(_, _),
             .zanDynamic(_),
             .allUnreadMessage,
             .unreadMessage(_),
             .sendMessage(_, _),
             .userInfo(_),
             .modifUserInfo,
             .uploadImage,
             .blackList,
             .addBlackList(_),
             .removeBlackList(_),
             .bannerList,
             .newFeature:
            return true
        default:
            return false
        }
    }
}
