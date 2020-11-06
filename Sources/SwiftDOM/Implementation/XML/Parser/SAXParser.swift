/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: SAXParser.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 11/4/20
 *
 * Copyright © 2020 Galen Rhodes. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *//************************************************************************/

import Foundation
import Rubicon
import libxml2
import LibXML2Helper

public class DOMXMLParser {
    public var delegate: DOMXMLParserDelegate? = nil

    @usableFromInline var inputStream: InputStream
    @usableFromInline var filename:    String
    @usableFromInline var ctx:         xmlParserCtxtPtr? = nil
    @usableFromInline var userData:    LibXmlSAXUserData

    public init(inputStream: InputStream, filename: String? = nil) {
        self.inputStream = inputStream
        self.filename = (filename ?? UUID().uuidString)
        xmlCheckVersion(LIBXML_VERSION)
        userData = LibXmlSAXUserData()
    }

    public convenience init?(url: URL) {
        guard let i = InputStream(url: url) else { return nil }
        self.init(inputStream: i, filename: url.description)
    }

    public convenience init?(filename: String) {
        guard let i = InputStream(fileAtPath: filename) else { return nil }
        self.init(inputStream: i, filename: filename)
    }

    public convenience init(data: Data, filename: String? = nil) {
        self.init(inputStream: InputStream(data: data), filename: filename)
    }

    public convenience init(bytesNoCopy: UnsafeMutablePointer<UInt8>, count: Int, deallocator: Data.Deallocator, filename: String? = nil) {
        let i = InputStream(data: Data(bytesNoCopy: UnsafeMutableRawPointer(mutating: bytesNoCopy), count: count, deallocator: deallocator))
        self.init(inputStream: i, filename: filename)
    }

    public convenience init(bytes: UnsafePointer<UInt8>, count: Int, filename: String? = nil) {
        let i = InputStream(data: Data(bytes: UnsafeRawPointer(bytes), count: count))
        self.init(inputStream: i, filename: filename)
    }

    deinit {
        if let ctx = ctx { xmlFreeParserCtxt(ctx) }
        xmlCleanupParser()
        xmlMemoryDump()
    }

    public func parse() throws {
        guard delegate != nil else { throw DOMXMLParserError.NoDelegateProvided }
        let bs: Int                        = 4096
        let b:  UnsafeMutablePointer<Int8> = createMutablePointer(capacity: bs)
        let fn: XStrBuffer                 = xStrFromString(str: filename)

        defer {
            discardXStrBuffer(fn)
            discardMutablePointer(b, bs)
        }

        memset(&userData, 0, MemoryLayout<LibXmlSAXUserData>.size)
        userData.parser = Unmanaged.passUnretained(self).toOpaque()
        ctx = xmlCreatePushParserCtxt(&userData.handler.saxHandler, &userData, b, Int32(try initialRead(buffer: b)), fn.cStr)
        guard let ctx = ctx else { throw DOMXMLParserError.CreateParserFailed }
        try parseLoop(ctx: ctx, buffer: b, bSize: bs)
    }

    func parseLoop(ctx: xmlParserCtxtPtr, buffer: UnsafeMutablePointer<Int8>, bSize: Int) throws {
        var st = try subsequentRead(buffer: buffer, maxLength: bSize)
        while st > 0 {
            xmlParseChunk(ctx, buffer, Int32(st), 0)
            st = try subsequentRead(buffer: buffer, maxLength: bSize)
        }
        xmlParseChunk(ctx, buffer, 0, 1)
    }

    @inlinable func subsequentRead(buffer: UnsafeMutablePointer<Int8>, maxLength: Int) throws -> Int {
        let st = inputStream.read(buffer, maxLength: maxLength)
        if st < 0 { throw (inputStream.streamError ?? DOMXMLParserError.UnknownInputStreamError) }
        return st
    }

    @inlinable func initialRead(buffer: UnsafeMutablePointer<Int8>, wanted: Int = 4) throws -> Int {
        var recved: Int = 0
        if inputStream.status(in: .notOpen) { inputStream.open() }
        while recved < wanted {
            let st = inputStream.read(buffer, maxLength: (wanted - recved))
            if st == 0 { throw DOMXMLParserError.EmptyDocument }
            if st < 0 { throw (inputStream.streamError ?? DOMXMLParserError.UnknownInputStreamError) }
            recved += st
        }
        return recved
    }
}

