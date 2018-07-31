//
//  LMKeyValueStore.swift
//  LMStorage_Example
//
//  Created by zhuo on 2018/7/30.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import WCDBSwift

/**
 key-value存储类
 */

enum LMStoreError: Swift.Error {
    case dbConnnectionError     // 数据库链接错误
    case stringFormatError    // 表，字段字符格式错误
    case valueNoSupport       // 不支持存储格式
}


open class LMKeyValueStore {
    
    private var dbConection: Database?
    convenience public init(_ dbName: String, path: String) {
        self.init(dbPath: "\(path)/\(dbName)")
    }
    
    convenience public init(dbName:String) {
        self.init(dbName, path: DOCUMENTPATH)
    }
    
    private init(dbPath: String) {
        dbConection =  Database(withPath: dbPath)
    }
    /// 新建一个表
    ///
    /// - Parameter tableName: 表名
    /// - Throws: 抛出异常
    public func createTable(tableName: String!) throws {
        guard LMKeyValueStore .checkTableName(tableName) else {
            throw LMStoreError.stringFormatError
        }
        do {
            try self.dbConection?.create(table: tableName, of: LMKeyValueItem.self)
        } catch let error {
            print("failed to create table : \(tableName)")
            throw error
        }
    }
    /// 删除表
    ///
    /// - Parameter tableName: 表名
    public func dropTable(tableName: String!) throws {
        guard LMKeyValueStore .checkTableName(tableName) else {
            throw LMStoreError.stringFormatError
        }
        do {
            try self.dbConection?.drop(table: tableName)
        } catch let error {
            print("failed to drop table : \(tableName)")
            throw error
        }
    }
    public func isTableExists(tableName: String) throws -> Bool {
        guard LMKeyValueStore .checkTableName(tableName) else {
            throw LMStoreError.stringFormatError
        }
        do {
            let result = try self.dbConection?.isTableExists(tableName)
            return result!
        } catch let error {
            throw error
        }
    }
    public func clearTable(tableName: String) throws {
        guard LMKeyValueStore .checkTableName(tableName) else {
            throw LMStoreError.stringFormatError
        }
        do {
            try self.dbConection?.delete(fromTable: tableName)
        } catch let error {
            throw error
        }
    }
    
    // 增删改查
    public func putObject(_ object: Any?, objectId: String!, tableName: String!) throws {
        
        guard LMKeyValueStore .checkTableName(tableName) else {
            throw LMStoreError.stringFormatError
        }
        guard objectId != nil else {
            throw LMStoreError.stringFormatError
        }
        let set = LMStoreSetter(object)
        guard let _: String = set.jsonString else {
            throw LMStoreError.valueNoSupport
        }
        
        let valueItem = LMKeyValueItem();
        valueItem.itemId = objectId
        valueItem.createTime = Date()
        valueItem.jsonObject = set.jsonString
        
        do {
            try self.dbConection?.insertOrReplace(objects: valueItem, intoTable: tableName)
        } catch let error {
            throw error
        }
    }
    
    func getKeyValueItem(_ objectId: String!, tableName: String!) throws -> LMKeyValueItem? {
        
        guard LMKeyValueStore .checkTableName(tableName) else {
            throw LMStoreError.stringFormatError
        }
        guard objectId != nil else {
            throw LMStoreError.stringFormatError
        }
        do {
            
            let item: LMKeyValueItem?  = try self.dbConection?.getObject(on: LMKeyValueItem.Properties.all, fromTable: tableName, where: LMKeyValueItem.Properties.itemId == objectId)
            return item
        } catch let error {
            throw error
        }
        
    }
    
    public func getObject(_ objectId: String!, _ tableName: String!)throws -> LMStoreValue?{
        do {
            
            let item:LMKeyValueItem? = try self.getKeyValueItem(objectId, tableName: tableName)
            return LMStoreValue(item?.jsonObject as AnyObject)
        } catch let error {
            throw error
        }
        
    }
    
    public func markExpired(_ objectId: String!, _ tableName: String!)throws {
        guard LMKeyValueStore .checkTableName(tableName) else {
            throw LMStoreError.stringFormatError
        }
        guard objectId != nil else {
            throw LMStoreError.stringFormatError
        }
        
        do {
            let updateItem = LMKeyValueItem()
            updateItem.createTime = Date(timeIntervalSince1970: 0)
            try self.dbConection?.update(table: tableName, on: LMKeyValueItem.Properties.createTime, with: updateItem, where: LMKeyValueItem.Properties.itemId == objectId)
        } catch let error {
            throw error
        }
    }
    
    public func markExpired(_ tableName:String!) throws {
        guard LMKeyValueStore .checkTableName(tableName) else {
            throw LMStoreError.stringFormatError
        }
        do {
            let updateItem = LMKeyValueItem()
            updateItem.createTime = Date(timeIntervalSince1970: 0)
            try self.dbConection?.update(table: tableName, on: LMKeyValueItem.Properties.createTime, with: updateItem)
        } catch let error {
            throw error
        }
    }
    
    internal static func checkTableName(_ tableName: String!)->Bool {
        if tableName.contains(" ") {
            print("table name : \(tableName) format error")
            return false
        }
        return true
    }
}
