//
//  LMStoreSetter.swift
//  LMStorage_Example
//
//  Created by zhuo on 2018/7/31.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

public struct LMStoreSetter {
    fileprivate var object: Any?
    public init(_ object : Any!) {
        self.object = object
    }
    
    internal var jsonString: String? {
        get{
            if let json = object as? String {
                return json
            } else {
                var sqlObject: Any?
                if let number = self.object as? NSNumber {
                    sqlObject = [number]
                } else if let arrayObject = self.object as? [Any] {
                    sqlObject = arrayObject as AnyObject
                } else if let dictionaryObject = self.object as? Dictionary<String,AnyObject> {
                    sqlObject = dictionaryObject as AnyObject
                } else{
                    return nil
                }
                do {
                    let data = try JSONSerialization.data(withJSONObject: sqlObject!, options: JSONSerialization.WritingOptions(rawValue: 0))
                    return NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
                }catch{
                    print("faild to get json data")
                    return nil
                }
            }

        }
    }
}
