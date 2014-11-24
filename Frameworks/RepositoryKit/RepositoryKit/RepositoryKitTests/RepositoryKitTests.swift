//
//  RepositoryKitTests.swift
//  RepositoryKitTests
//
//  Created by Dirk Lewis on 6/7/14.
//  Copyright (c) 2014 VideoHooHaa. All rights reserved.
//

import XCTest


class RepositoryKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    func testCreateBackingstoreWithDefaults(){
    
        var bs = SqliteBackingStore.createBackingstore(nil, fileName: "Test.sqlite", configurationName: "TestConfig")
        XCTAssertTrue(bs.fileName == "Test.sqlite", "must have correct name")
        XCTAssertTrue(bs.modelName == "model", "must have correct name")
        XCTAssertTrue(bs.configurationName == "TestConfig", "must have correct name")
    
    }
    
    func testCreateBackingstore(){
        var bs = SqliteBackingStore.createBackingstore("TestModel", fileName: "Test.sqlite", configurationName: "TestConfig")
        XCTAssertTrue(bs.fileName == "Test.sqlite", "must have correct name")
        XCTAssertTrue(bs.modelName == "TestModel", "must have correct name")
        XCTAssertTrue(bs.configurationName == "TestConfig", "must have correct name")

    }
    
    
//    func testOpenBackingStore(){
//        var bs = SqliteBackingStore.createBackingstore("TestModel", fileName: "Test.sqlite", configurationName: "Default")
//        let context1 = bs.openBackingstoreDefaultContext()
//        XCTAssertTrue(context1 = true, "Backingstore must open")
//        let context2 = bs.openBackingstoreDefaultContext()
//        XCTAssertEqualObjects(context1, context2, "Must be the same object", file: "", line: 0)
//    }
//    
//    func testOpenBackingStoreByName(){
//    
//        var bs = SqliteBackingStore.createBackingstore("TestModel", fileName: "Test.sqlite", configurationName: "Default")
//        let context1 = bs.openBackingstoreContext("myqueue")!
//        XCTAssertTrue(context1 != nil, "Backingstore must open", file: "", line: 0)
//        let context2 = bs.openBackingstoreContext("myqueue")
//        XCTAssertEqualObjects(context1, context2, "Must be the same object", file: "", line: 0)
//        XCTAssertTrue(context1.userInfo["QueueName"] as NSString == "myqueue", "Name must match", file: "", line: 0)
//    }

    
}
