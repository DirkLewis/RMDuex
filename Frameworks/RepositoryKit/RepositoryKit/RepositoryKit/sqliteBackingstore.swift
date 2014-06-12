//
//  sqliteBackingstore.swift
//  RepositoryKit
//
//  Created by Dirk Lewis on 6/8/14.
//  Copyright (c) 2014 VideoHooHaa. All rights reserved.
//

import Foundation
import CoreData
import Security



class sqliteBackingstore: NSObject,BackingstoreProtocol {
    
    
    // #pragma mark - initializers
    init(){
        sqliteBackingstore(backingstore: nil, fileName: nil, configurationName: nil)
        super.init()
    }
    
    init(backingstore modelName: String!, fileName: String!, configurationName: String!) {
        self._modelName = modelName ? modelName : "model"
        self._fileName = fileName ? fileName : "model.sqlite"
        self._configurationName = configurationName ? configurationName : "Default"
        
        super.init()
        
    }
    
    class func createBackingstore(modelName : String!, fileName : String!, configurationName : String!) -> BackingstoreProtocol{
        return sqliteBackingstore(backingstore: modelName, fileName: fileName, configurationName: configurationName)
    }
    
    // #pragma mark - Properties
    
    var _backingstore : BackingstoreProtocol?
    var _managedObjectContextQueue = Dictionary<String,NSManagedObjectContext>()
    
    var _modelName : String = ""
    var modelName : String?{
        get{
            return _modelName
        }
    }
    
    var _fileName : String = ""
    var fileName : String?{
        get{
            return _fileName
        }
    }
    
    var _configurationName : String = ""
    var configurationName : String?{
        get{
            return _configurationName
        }
    }
    
    var _errorArray = NSError[]()
    var errorArray : Array<NSError>?{
        get{
        
            return _errorArray
        }
    }
    
    // #pragma mark - Public Methods
    
    //public methods
    func openBackingstoreDefaultContext() -> NSManagedObjectContext? {
        
        if let defaultMOC = _managedObjectContextQueue["Default"]{
            return defaultMOC
        }
        
        let context = managedObjectContext
        
        _managedObjectContextQueue["Default"] = context
        
        return context
    }
    
    
    func openBackingstoreContext(queueName:NSString) -> NSManagedObjectContext?{
        
        if let defaultMOC = _managedObjectContextQueue[queueName]{
            return defaultMOC
        }
        
        let context = managedObjectContext
        
        _managedObjectContextQueue[queueName] = context
        
        return context
    }
    
    func closeBackingstore() -> Bool{
        return false
    }
    
    func resetBackingstore() -> Bool {
        return false
    }
    
    func deleteBackingstore() -> Bool {
        return false
    }
    
    func persistanceStoreExistsBy(storeName: String) -> Bool{
        return false
    }

    
    // #pragma mark - Private Methods
    
    func resetPersistentStoreCoordinator(deleteStore:Bool) ->Bool{
    
        let stores = persistentStoreCoordinator.persistentStores as Array<NSPersistentStore>
        var error : NSError?
        for store in stores{
            persistentStoreCoordinator.removePersistentStore(store, error: &error)
            if deleteStore{
            
                NSFileManager.defaultManager().removeItemAtPath(store.URL.path + "-wal", error: &error)
                NSFileManager.defaultManager().removeItemAtPath(store.URL.path + "-shm", error: &error)
                NSFileManager.defaultManager().removeItemAtPath(store.URL.path, error: &error)
            }
        }
        _persistentStoreCoordinator = nil
        if error{
            _errorArray += error!
            return false
        }
        
        return true
    }
    
    func datastoreMigrationRequired(datastoreURL:NSURL)->Bool{
    
        if (!NSFileManager.defaultManager().fileExistsAtPath(datastoreURL.path)){
            return false
        }
        
        var error:NSError?
        let sourceMetaData = NSPersistentStoreCoordinator.metadataForPersistentStoreOfType(NSSQLiteStoreType, URL: datastoreURL, error: &error)
        
        if(error){
            _errorArray.append(error!)
        }
        
        let destination = _persistentStoreCoordinator!.managedObjectModel
        let isModelCompatible = destination.isConfiguration(nil, compatibleWithStoreMetadata: sourceMetaData)
        
        if (!sourceMetaData || isModelCompatible){
            return false
        }
        
        return true
        
    }
    
    func createDocumentDirectoryForSaving() -> Bool{
    
        var isDirectory : ObjCBool = false
        let directoryPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true) as Array<String>
        if directoryPaths.count == 1{
        
            let fileManager = NSFileManager.defaultManager()
            if !fileManager.fileExistsAtPath(directoryPaths[0], isDirectory: &isDirectory) && isDirectory.getLogicValue(){
                
                var error:NSError?
                fileManager.createDirectoryAtPath(directoryPaths[0], withIntermediateDirectories: true, attributes: nil, error: &error)
                
                if (error){
                    _errorArray.append(error!)
                    return false
                }
                else{
                    return true
                }
                
            }
            else{
                return true
            }
        }
        return false
    }
    
    // #pragma mark - Core Data stack
    
    // Returns the managed object context for the application.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
    var _managedObjectContext: NSManagedObjectContext? = nil
    var managedObjectContext: NSManagedObjectContext {
        if !_managedObjectContext {
            let coordinator = self.persistentStoreCoordinator
            if coordinator != nil {
                _managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
                _managedObjectContext!.persistentStoreCoordinator = coordinator
            }
        }
        return _managedObjectContext!
    }
    
    
    // Returns the managed object model for the application.
    // If the model doesn't already exist, it is created from the application's model.
    var _managedObjectModel: NSManagedObjectModel? = nil
    var managedObjectModel: NSManagedObjectModel {
    if !_managedObjectModel {
        var models = NSManagedObjectModel[]()
        
        for bundle in NSBundle.allBundles() as Array<NSBundle>{
            
            let modelPaths = bundle.pathsForResourcesOfType("momd", inDirectory: nil) as Array<String>
            for modelpath in modelPaths{
                let momURL = NSURL.fileURLWithPath(modelpath as String)
                let path = modelName! + ".momd"
                let momCount = momURL.pathComponents.filter{$0 as String == path}.count
                
                if momCount > 0{
                    let model = NSManagedObjectModel(contentsOfURL: momURL)
                    if models != nil{
                        models += model
                    }
                }
            }
        }
        _managedObjectModel = NSManagedObjectModel(byMergingModels: models)
    }
        return _managedObjectModel!
    }

    // Returns the persistent store coordinator for the application.
    // If the coordinator doesn't already exist, it is created and the application's store added to it.
    var _persistentStoreCoordinator: NSPersistentStoreCoordinator? = nil
    var persistentStoreCoordinator: NSPersistentStoreCoordinator {
    
    if !_persistentStoreCoordinator {
        var error: NSError? = nil
        
        _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        if(createDocumentDirectoryForSaving()){
            
            let storeURLs = (NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask))
            let storeName = storeURLs[0].URLByAppendingPathComponent(fileName)
            let options = [NSMigratePersistentStoresAutomaticallyOption:true,NSInferMappingModelAutomaticallyOption:true]
            let migrationRequired = datastoreMigrationRequired(storeName)
            
            if migrationRequired{
                NSNotificationCenter.defaultCenter().postNotificationName("datastoremigrationnotification", object: ["message":"Migration Required", "code":0])
            }
            
            if !_persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: configurationName, URL: storeName, options: options, error: &error){
                _errorArray.append(error!)

                if migrationRequired{
                    NSNotificationCenter.defaultCenter().postNotificationName("datastoremigrationnotification", object: ["message":"Migration Failed", "code":-1, "error":error!])
                }
                else{
                    NSException(name: error!.localizedDescription, reason: "Datastore failed to initialize.", userInfo: nil).raise()
                }
            }
        }
        
        }
        return _persistentStoreCoordinator!
    }
    
    
    // #pragma mark - Application's Documents directory
    
    // Returns the URL to the application's Documents directory.
    var applicationDocumentsDirectory: NSURL {
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.endIndex-1] as NSURL
    }
    
    func description()->String{
        return super.description + ";" + "Filename: " + fileName! + " Configuration: " + configurationName!
    }
}








