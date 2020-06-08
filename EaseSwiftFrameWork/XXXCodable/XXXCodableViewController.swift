//
//  XXXCodableViewController.swift
//  EaseSwiftFrameWork
//
//  Created by skynet on 2020/3/10.
//  Copyright © 2020 gmzb. All rights reserved.
//

import UIKit
/*
 
 版本任务
 
 1. 协助测试回归3.6.0版本中的功能以及bug
 2. 3.6.1中消息界面和UI同学的对接，包括直播间消息以及 tabbar 中的消息
 3. 阅读查看支付宝支付文档，对3.6.1版本中要涉及到的功能任务进行熟悉
 
 项目稳健
 
 1. 针对在线榜单中主播总榜的显示与否bug的解决，主要是对后台数据模型化的不足
 2. 解决邀请PK中搜索在线主播接口数据获取不完全的bug，主要是项目中刷新框架处理下拉刷新以及上拉加载更多逻辑不完善
 */

class XXXCodableViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let json = """
        {
          "name": "rocky project",
          "id": 235345,
          "size": 1,
          "user": {
            "id": "fsdfet34",
            "user_name": "rocky",
            "age": 25,
            "address": "SH"
            }
        }
        """.data(using: .utf8)!
        
        do {
            let shot = try JSONDecoder().decode(XXXShot.self, from: json)
            print(shot.user.name)
            print(shot.size)
        } catch  {
            print(error)
        }
    }
    
    class XXXShot: Codable {

        // 这里的id是string类型，后台数据中如果对这个字段的定义是string那就没有问题
        // 但是如果后台将这个字段定义为int类型，就会报错，这个时候需要进入到👇代码部分，也就是要实现解码(Decodable)协议的方法
        let id: String
        let name: String
        let user: XXXUser
        
        // 如果模型中有枚举类型，并且和服务器返回的类型不一样，比如这样
        enum Size: Int, Codable{
            case regular = 0
            case medium = 1
            case large = 2
        }
        let size: Size
        
        // 如果模型中的字段和服务器中的字段一样，可以不用重写case的字符串
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case user
            case size
        }
        
        init(id: String, user: XXXUser, name: String, size: Int){
            self.id = id
            self.name = name
            self.user = user
            self.size = Size.init(rawValue: size)!
        }
        
        // 这里就是👇的代码，实现Decodable协议的方法
        required convenience init(from decoder: Decoder) throws {
            // 这个方法中可以获取到一个 KeyedDecodingContainer
            // 可以通过这个containter来解码对应的属性，
            // 如果要使用这个方法来专门的解析数据，一定要实现CodingKeys这个枚举
            let container = try decoder.container(keyedBy: CodingKeys.self)
            // 注意这里，由于接收到的Data中id字段是Int类型的，所以这里也要对其解码成Int类型的
            // 然后将这个Int类型转换成String类型的，交给模型的id属性
            let id = try container.decode(Int.self, forKey: .id)
            let user = try container.decode(XXXUser.self, forKey: .user)
            let name = try container.decode(String.self, forKey: .name)
            let size = try container.decode(Int.self, forKey: .size)
            self.init(id: "\(id)", user: user, name: name, size: size)
        }
    }

    class XXXUser: Codable {
        let id: String
        let name: String
        let age: Int
        let address: String
        
        // 如果服务器给的字段中是user_name，但是项目中是name
        // 这个时候需要加入下面这段代码，并且是对所有的属性进行枚举的设置
        enum CodingKeys: String, CodingKey {
            case id
            case name = "user_name"
            case age
            case address
        }
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
