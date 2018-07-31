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

enum LMKeyValueStoreError: Swift.Error {
    case dbConnnectionError     // 数据库链接错误
    case dbStringFormatError    // 表，字段字符格式错误
}


public class LMKeyValueStore {
    
    static let shareInstance = try LMKeyValueStore(dbPath: "\(DOCUMENTPATH)/\(DEFAULTDBNAME)")
    
    private var dbConection: Database?
//    convenience private init(dbName: String!, path: String!) throws {
//        self.init(dbPath: "\(path)/\(dbName)")
//        guard dbConection != nil else {
//            throw LMKeyValueStoreError.dbConnnectionError
//        }
//    }
    private init(dbPath: String!) {
        dbConection =  Database(withPath: dbPath)
    }
    /// 新建一个表
    ///
    /// - Parameter tableName: 表名
    /// - Throws: 抛出异常
    public func createTable(tableName: String!) throws {
        guard LMKeyValueStore .checkTableName(tableName) else {
            throw LMKeyValueStoreError.dbStringFormatError
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
            throw LMKeyValueStoreError.dbStringFormatError
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
            throw LMKeyValueStoreError.dbStringFormatError
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
            throw LMKeyValueStoreError.dbStringFormatError
        }
        do {
            try self.dbConection?.delete(fromTable: tableName)
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
