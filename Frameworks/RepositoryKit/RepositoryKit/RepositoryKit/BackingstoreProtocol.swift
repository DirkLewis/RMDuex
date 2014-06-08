//
//  BackingstoreProtocol.swift
//  RepositoryKit
//
//  Created by Dirk Lewis on 6/8/14.
//  Copyright (c) 2014 VideoHooHaa. All rights reserved.
//

import Foundation
import CoreData


protocol BackingstoreProtocol {

    var modelName : String? {get set}
    var fileName : String? {get set}
    var configurationName : String? {get set}
    var managedObjectContext : NSManagedObjectContext? {get set}
    var managedObjectModel : NSManagedObjectModel? {get set}
    var persistentStoreCoordinator : NSPersistentStoreCoordinator? {get set}
    var errorArray : Array<NSError>? {get}
    
    init(backingstore modelName:String, fileName:String, configurationName:String)
    func resetBackingstore() -> Bool
    func closeBackingstore() -> Bool
    func openBackingstore() -> Bool
    func deleteBackingstore() -> Bool
    func persistanceStoreExistsBy(storeName:String) -> Bool

}