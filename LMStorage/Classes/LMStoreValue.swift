//
//  LMStoreValue.swift
//  LMStorage_Example
//
//  Created by zhuo on 2018/7/31.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

/*
 数据库对象
 */

public struct LMStoreValue {
    
    internal var value : AnyObject?
    
    public init(_ value : AnyObject!) {
        self.value = value
    }
    
    public var objectValue : AnyObject?{
        get{
            return self.value
        }
    }
    
    public var stringValue : String? {
        get{
            return self.value as? String
        }
    }
    
    public var numberValue : NSNumber?{
        
        get{
            if self.value == nil { return nil}
            
            if let num = self.value as? NSNumber{
                return num
            }else{
                
                do{
                    let result: Any? = try JSONSerialization.jsonObject(with: self.value!.data(using: String.Encoding.utf8.rawValue)!, options: .allowFragments)
                    if let num = result as? [NSNumber]{
                        return num[0]
                    }else{
                        return nil
                    }
                }catch{
                    print("faild to get json data")
                    return nil
                }
                
            }
        }
        
    }
    
    public var dictionaryValue : Dictionary<String , AnyObject>?{
        get{
            if self.value == nil { return nil}
            
            do{
                let result: Any? = try JSONSerialization.jsonObject(with: self.value!.data(using: String.Encoding.utf8.rawValue)!, options: .allowFragments)
                if let dic = result as? Dictionary<String , AnyObject>{
                    return dic
                }else{
                    return nil
                }
            }catch{
                print("faild to get json data")
                return nil
            }
            
        }
    }
    
    
    public var arrayValue : Array<AnyObject>?{
        get{
            if self.value == nil { return nil}
            
            do{
                let result: Any? = try JSONSerialization.jsonObject(with: self.value!.data(using: String.Encoding.utf8.rawValue)!, options: .allowFragments)
                if let dic = result as? Array<AnyObject>{
                    return dic
                }else{
                    return nil
                }
            }catch{
                print("faild to get json data")
                return nil
            }
        }
    }

}
