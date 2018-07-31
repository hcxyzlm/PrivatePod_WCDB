//
//  LMKeyValueCacheStore.swift
//  LMKeyValueStore_WCDB
//
//  Created by zhuo on 2018/7/31.
//  Copyright © 2018年 zhuo. All rights reserved.
//

import Foundation

/**
    * 采用key-value方式将数据存储于关系型数据库中，实现数据持久化
    * key：app内唯一标记，通过自定义手动添加，value：通常是服务器请求回来的合法的json字符串
    * 适合简单页面存储，不需要对数据进行modify的
*/

internal let TABLE_NAME_KEYVALUE = "KeyValueTable"

open class LMKeyValueCacheStore {
    
    // MARK: - Life Cycle
    static let shareInstance = LMKeyValueCacheStore()
    private let store:LMKeyValueStore
    
    private init() {
        self.store = LMKeyValueStore(dbName: DEFAULTDBNAME)
        do {
            let isExits:Bool =  try self.store.isTableExists(tableName: TABLE_NAME_KEYVALUE)
            if  isExits == true{
                
            }else {
                try self.store.createTable(tableName: TABLE_NAME_KEYVALUE)
            }
        }catch let error {
            print(error)
        }
    }
    
    // MARK: - save json cache
    public func cache(_ josnObject:String, _ cacheKey:String) {
        do {
            try self.store.putObject(josnObject, objectId: cacheKey, tableName: TABLE_NAME_KEYVALUE)
        }catch {
            print("falue save json \(cacheKey)")
        }
    }
    // MARK: - select json
    public func selectCacheJson(_ cacheKey:String!)-> String?{
        do {
            return try self.store.getObject(cacheKey, TABLE_NAME_KEYVALUE)?.stringValue;
        }catch {
            return nil
        }
    }
    // MARK: - cleal all json
    public func clearAllCache(){
        do {
            try self.store.clearTable(tableName: TABLE_NAME_KEYVALUE)
        }catch  {
           print("falue clearAllCache json" )
        }
    }
    
    // MARK: - 设置所有的缓存过期
    public func makeAllcacheExpired(){
        do {
            try self.store.markExpired(TABLE_NAME_KEYVALUE)
        }catch  {
            print("falue makeAllcacheExpired json" )
        }
    }
    
    // MARK: - 设置某个的缓存过期
    public func makeCacheExpired(_ cacheKey:String!){
        do {
            try self.store.markExpired(cacheKey, TABLE_NAME_KEYVALUE)
        }catch{
            print("falue makeAllcacheExpired json \(cacheKey)")
        }
    }
    
    /**
     * 判断某个缓存是否过期
     * return YES:已过期 NO:未过期
     */
    public func checkCacheIsExpired(_ cacheKey:String!, cacheTiame: TimeInterval) -> Bool{
        do {
            var isExpired = true;
            let valueItem:LMKeyValueItem? = try self.store .getKeyValueItem(cacheKey, tableName: TABLE_NAME_KEYVALUE)
            if valueItem != nil {
                let date = Date()
                if date.timeIntervalSince(valueItem!.createTime!) <= cacheTiame {
                    isExpired = false;
                }
            }
            return isExpired
        } catch  {
            return true
        }
    }
}
