//
//  ViewController.swift
//  LMStorage
//
//  Created by mrscorpion on 07/13/2018.
//  Copyright (c) 2018 mrscorpion. All rights reserved.
//

import UIKit
import WCDBSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let path = self.documentPath().appending("/test.db");
        let database = Database(withPath:path)
        do {
            try database.create(table: "KeyItemTable", of: LMKeyValueItem.self)
        }catch {
            
        }
        
        
        let keyItem = LMKeyValueItem()
        keyItem.createTime = Date()
        keyItem.itemId = "primaryKey"
        keyItem.jsonObject = "/news/province-pm2-ts0.json"
        
        do {
            try database.insertOrReplace(objects: keyItem, intoTable: "KeyItemTable")
            
        }catch let error{
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    func documentPath() -> String {
        let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                FileManager.SearchPathDomainMask.userDomainMask, true)
        
        print("home dictory = \(documentPaths[0])")
        return documentPaths[0] as String
    }

}
