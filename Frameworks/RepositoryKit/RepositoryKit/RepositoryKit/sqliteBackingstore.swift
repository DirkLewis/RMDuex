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



class sqliteBackingstore: NSObject, BackingstoreProtocol {


    //initializers
    
    init(backingstore modelName: String, fileName: String, configurationName: String) {
        self.modelName = modelName
        self.fileName = fileName
        self.configurationName = configurationName
        self.errorArray = []
        
    }
    
    //properties
    var modelName : String?
    var fileName : String?
    var configurationName : String?
    var managedObjectContext : NSManagedObjectContext?
    var managedObjectModel : NSManagedObjectModel?
    var persistentStoreCoordinator : NSPersistentStoreCoordinator?
    var errorArray : Array<NSError>?

    //public methods
    func openBackingstore() -> Bool {
    
        return false
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
    
    func persistanceStoreExistsBy(storeName: String) -> Bool{
        return false
    }
    
    
    //private methods
    func createManagedObjectContext() -> NSManagedObjectContext{
    
        if let context = managedObjectContext{
            return context
        }
        
        //let coordinator : NSPersistentStoreCoordinator
    
        return managedObjectContext!
    }
    
    func createManagedObjectModel() -> NSManagedObjectModel{
        
        if let model = managedObjectModel{
            return model
        }
        
        var models : Array<NSManagedObjectModel> = []
        
        for item : AnyObject in NSBundle.allBundles(){
            
            if let bundle = item as? NSBundle{
                let modelPaths : Array <AnyObject> = bundle.pathsForResourcesOfType("momd", inDirectory: nil)
                for modelpath : AnyObject in modelPaths{
                    let momURL : NSURL = NSURL.fileURLWithPath(modelpath as String)
                    let path : String = modelName! + ".momd"
                    let momCount : Int = momURL.pathComponents.filter{$0 as String == path}.count
                
                    if momCount > 0{
                        let model : NSManagedObjectModel = NSManagedObjectModel(contentsOfURL: momURL)
                        if models != nil{
                            models += model
                        }
                    }
                }
                
            }
        }
        managedObjectModel = NSManagedObjectModel(byMergingModels: models)
        return managedObjectModel!
    }

}



























