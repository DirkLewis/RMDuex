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
    
//    func testExample() {
//        // This is an example of a functional test case.
//        XCTAssert(true, "Pass")
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    func testCreateBackingstore(){
        var bs = sqliteBackingstore.createBackingstore("TestModel", fileName: "Test.sqlite", configurationName: "Default")
        XCTAssertTrue(bs != nil, "Must Not Be nil", file: "", line: 0)


    }
    
    func testOpenBackingStore(){
        var bs = sqliteBackingstore.createBackingstore("TestModel", fileName: "Test.sqlite", configurationName: "Default")
        let context1 = bs.openBackingstoreDefaultContext()
        XCTAssertTrue(context1, "Backingstore must open", file: "", line: 0)
        let context2 = bs.openBackingstoreDefaultContext()
        XCTAssertEqualObjects(context1, context2, "Must be the same object", file: "", line: 0)
    }
    
    func testOpenBackingStoreByName(){
    
        var bs = sqliteBackingstore.createBackingstore("TestModel", fileName: "Test.sqlite", configurationName: "Default")
        let context1 = bs.openBackingstoreContext("myqueue")
        XCTAssertTrue(context1, "Backingstore must open", file: "", line: 0)
        let context2 = bs.openBackingstoreContext("myqueue")
        XCTAssertEqualObjects(context1, context2, "Must be the same object", file: "", line: 0)
    
    }
    
}
