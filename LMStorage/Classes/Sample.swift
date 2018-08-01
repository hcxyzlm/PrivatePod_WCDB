//
//  Sample.swift
//  LMStorage
//
//  Created by zhuo on 2018/8/1.
//

import Foundation
import WCDBSwift

class Sample: TableCodable {
    var identifier: Int? = nil
    var description: String? = nil
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = Sample
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case identifier
        case description
    }
}
