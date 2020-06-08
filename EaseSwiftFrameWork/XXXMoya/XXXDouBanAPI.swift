//
//  XXXDouBanAPI.swift
//  EaseSwiftFrameWork
//
//  Created by skynet on 2019/7/22.
//  Copyright © 2019 gmzb. All rights reserved.
//

import Foundation
import Moya
import HandyJSON

struct XXXDouBanChannel : HandyJSON{
    var abbr_en : String?
    var channel_id : Int?
    var name : String?
    var name_en : String?
    var seq_id : Int?
}

struct XXXDouBanSong : HandyJSON{
    var aid : String?
    var album : String?
    var albumtitle : String?
    var artist : String?
    var picture : String?
    var singers_name : String?
    var singers_avatar : String?
    var singers_id : String?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.singers_id <-- "singers.id"
        mapper <<<
            self.singers_name <-- "singers.name"
        mapper <<<
            self.singers_avatar <-- "singers.avatar"
    }
}

//首先我们定义一个 provider，即请求发起对象。往后我们如果要发起网络请求就使用这个 provider。
//接着声明一个 enum 来对请求进行明确分类，这里我们定义两个枚举值分别表示获取频道列表、获取歌曲信息。
//最后让这个 enum 实现 TargetType 协议，在这里面定义我们各个请求的 url、参数、header 等信息。

let DouBanProvider = MoyaProvider<DouBan>()

public enum DouBan {
    case channels///<频道列表
    case playList(key : Int)///<歌曲列表
}

extension DouBan : NetworkTargetType {
    
    ////<基础服务器地址
    public var baseURL: URL {
        switch self {
        case .channels:
            return URL(string: "https://www.douban.com")!
        case .playList(_):
            return URL(string: "https://douban.fm")!
        }
    }
    ///<请求的路径
    public var path: String {
        switch self {
        case .channels:
            return "/j/app/radio/channels"
        case .playList(_):
            return "/j/mine/playlist"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    //请求任务事件（这里附带上参数）
    public var task: Task {
        switch self {
        case .playList(let channel):
            ///<请求的参数，如果是get，就直接拼接在url后面，如果是post则在http-body里面
            var params: [String: Any] = [:]
            params["channel"] = channel
            params["type"] = "n"
            params["from"] = "mainsite"
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
        return nil
    }
    
    /// 自己加的协议内容，用于过滤数据
    public func requestCompleteFilter(moyaResponse: Response, response: Any?) -> Any? {
        
        switch self {
        case .channels:
            if let data = response as? Dictionary<String, Array<Any>>,
                let channels = [XXXDouBanChannel].deserialize(from: data["channels"]){
                return channels
            }
        case .playList(_):
            if let data = response as? Dictionary<String, Any>,
                let songs = data["song"] as? Array<Dictionary<String,Any>>,
                songs.count > 0 {
                return XXXDouBanSong.deserialize(from: songs[0])
            }
        }
        return response
    }
    
    public func requestFailedFilter(MoyaError: Any) {
        
    }
}
