/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: LibXMLTools.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 11/5/20
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
import libxml2
import LibXML2Helper
import Rubicon

@usableFromInline typealias XStr = UnsafePointer<xmlChar>
@usableFromInline typealias XMuStr = UnsafeMutablePointer<xmlChar>
@usableFromInline typealias XStrArr = UnsafeMutablePointer<XStr?>
@usableFromInline typealias XStrBuffer = (cStr: UnsafeMutablePointer<Int8>, length: Int)

@inlinable func stringFromXStr(_ xstr: XStr, length: Int32) -> String {
    let (buf, len) = copyBuffer(ptr: xstr, count: Int(length))
    defer { destroyBuffer(buf: buf, count: len) }
    return String(cString: buf)
}

@inlinable func stringFromOXStr(_ xstr: XStr?, length: Int32) -> String? {
    if let s = xstr { return stringFromXStr(s, length: length) }
    return nil
}

@inlinable func stringFromXStr(_ xstr: XStr?) -> String? {
    if let s = xstr { return String(cString: s) }
    return nil
}

@inlinable func stringFromXStr(_ xstr: XMuStr?) -> String? {
    if let s = xstr { return String(cString: s) }
    return nil
}

@inlinable func stringFromOXStrPtrs(pBegin p1: XStr?, pEnd p2: XStr?) -> String? {
    guard let p1 = p1, let p2 = p2 else { return nil }
    return stringFromXStrPtrs(pBegin: p1, pEnd: p2)
}

@inlinable func stringFromXStrPtrs(pBegin p1: XStr, pEnd p2: XStr) -> String {
    let (buf, len) = copyBuffer(pBegin: p1, pEnd: p2)
    defer { destroyBuffer(buf: buf, count: len) }
    return String(cString: buf)
}

@inlinable func xStrFromString(str: String) -> XStrBuffer {
    var str = str
    return str.withUTF8 { (p: UnsafeBufferPointer<UInt8>) -> XStrBuffer in
        guard let p2 = UnsafeRawBufferPointer(p).bindMemory(to: Int8.self).baseAddress else { fatalError() }
        let len = (p.count + 1)
        let mp  = UnsafeMutablePointer<Int8>.allocate(capacity: len)
        mp.initialize(from: p2, count: p.count)
        mp[p.count] = 0
        return (mp, len)
    }
}

@inlinable func discardXStrBuffer(_ buf: XStrBuffer) { discardMutablePointer(buf.cStr, buf.length) }

extension SAXAttribute {
    convenience init?(_ arr: XStrArr, isDefault def: Bool = false) {
        if let name = arr[0], let vP1 = arr[3], let vP2 = arr[4] {
            self.init(localName: String(cString: name), prefix: stringFromXStr(arr[1]), namespaceURI: stringFromXStr(arr[2]), value: stringFromXStrPtrs(pBegin: vP1, pEnd: vP2), isDefault: def)
        }
        else {
            return nil
        }
    }
}

extension SAXNSMap {
    convenience init?(_ arr: XStrArr) {
        if let uri = arr[0], let pfx = arr[1] { self.init(uri: String(cString: uri), prefix: String(cString: pfx)) }
        else { return nil }
    }
}
