//
//  SqliteBackingStore.swift
//  RepositoryKit
//
//  Created by Dirk Lewis on 11/24/14.
//  Copyright (c) 2014 VideoHooHaa. All rights reserved.
//

import UIKit
import CoreData
import Security

class SqliteBackingStore: NSObject,BackingstoreProtocol {
    
    override init() {
        
        SqliteBackingStore(backingstore: nil, fileName: nil, configurationName: nil)
        
    }
    
    required init(backingstore modelName: String?, fileName: String?, configurationName: String?) {
        
        self._modelName = (modelName != nil && !modelName!.isEmpty) ? modelName : "model"
        self._fileName =  (fileName != nil && !fileName!.isEmpty) ? fileName : "model.sqlite"
        self._configurationName = configurationName != nil && !configurationName!.isEmpty ? configurationName : "Default"
        
        super.init()
        
    }
    
    class func createBackingstore(modelName: String?, fileName: String?, configurationName: String?) -> BackingstoreProtocol {
        
        return SqliteBackingStore(backingstore: modelName, fileName: fileName, configurationName: configurationName)
        
    }
    
    func openBackingstoreDefaultContext() -> NSManagedObjectContext? {
        return nil
    }
    
    func openBackingstoreContext(queueName: NSString) -> NSManagedObjectContext? {
        return nil
    }
    
    func closeBackingstore() -> Bool {
        return false
    }
    
    func resetBackingstore() -> Bool {
        return false
    }
    
    func deleteBackingstore() -> Bool {
        return false
    }
    
    func persistanceStoreExistsBy(storeName: String) -> Bool {
        return false
    }
    
    
    var _modelName:String?
    var modelName:String?{
        get{
            
            return self._modelName
        }
    }
    
    var _fileName:String?
    internal var fileName:String?{
        get{
            
            return self._fileName
        }
    }
    
    var _configurationName:String?
    internal var configurationName:String?{
        get{
            
            return self._configurationName
        }
    }
    
    var _errorArray:[NSError]?
    internal var errorArray:[NSError]?{
        get{
            
            return self._errorArray
        }
    }
    
    
   
}
