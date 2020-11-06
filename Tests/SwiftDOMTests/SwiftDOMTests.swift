//
//  SwiftDOMTests.swift
//  SwiftDOMTests
//
//  Created by Galen Rhodes on 10/14/20.
//

import XCTest
@testable import SwiftDOM

class SwiftDOMTests: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testDOMXMLParserDelegate() throws {
        let parser   = DOMXMLParser(inputStream: InputStream(fileAtPath: "/Users/grhodes/Desktop/XML/Test.xml")!) // XMLParser(stream: InputStream(fileAtPath: "/Users/grhodes/Desktop/XML/Test.xml")!)
        let delegate = MyDelegate()

        parser.delegate = delegate
//        parser.shouldProcessNamespaces = true
//        parser.shouldReportNamespacePrefixes = true
//        parser.shouldResolveExternalEntities = true
//        parser.externalEntityResolvingPolicy = .always
//        parser.allowedExternalEntityURLs = nil
        try! parser.parse()
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
}
