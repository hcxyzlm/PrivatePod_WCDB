//
//  LMKeyValueItem.swift
//  LMStorage_Example
//
//  Created by zhuo on 2018/7/26.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import WCDBSwift

public class LMKeyValueItem: WCDBSwift.TableCodable {
    var itemId: String?
    var jsonObject: String?
    var createTime: Date?
    public enum CodingKeys: String, CodingTableKey {
        public typealias Root = LMKeyValueItem
        case itemId
        case jsonObject
        case createTime
        public static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        //Column constraints for primary key, unique, not null, default value and so on. It is optional.
        public static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                itemId: ColumnConstraintBinding(isPrimary: true)
            ]
        }
        //Index bindings. It is optional.
        //static var indexBindings: [IndexBinding.Subfix: IndexBinding]? {
        //    return [
        //        "_index": IndexBinding(indexesBy: CodingKeys.variable2)
        //    ]
        //}
        //Table constraints for multi-primary, multi-unique and so on. It is optional.
        //static var tableConstraintBindings: [TableConstraintBinding.Name: TableConstraintBinding]? {
        //    return [
        //        "MultiPrimaryConstraint": MultiPrimaryBinding(indexesBy: variable2.asIndex(orderBy: .descending), variable3.primaryKeyPart2)
        //    ]
        //}
        
        //Virtual table binding for FTS and so on. It is optional.
        //static var virtualTableBinding: VirtualTableBinding? {
        //    return VirtualTableBinding(with: .fts3, and: ModuleArgument(with: .WCDB))
        //}
    }
    
    //Properties below are needed only the primary key is auto-incremental
    //var isAutoIncrement: Bool = false
    //var lastInsertedRowID: Int64 = 0
}
