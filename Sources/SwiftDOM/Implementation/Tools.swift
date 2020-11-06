/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: Tools.swift
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

@inlinable func < (lhs: String?, rhs: String?) -> Bool { ((rhs != nil) && ((lhs == nil) || (lhs! < rhs!))) }

@inlinable func < (lhs: [String?], rhs: [String?]) -> Bool {
    guard lhs.count == rhs.count else { fatalError() }
    for (i, l) in lhs.enumerated() {
        let r = rhs[i]
        if l == r { continue }
        else if l < r { return true }
    }
    return false
}

@inlinable func == (lhs: [String?], rhs: [String?]) -> Bool {
    guard lhs.count == rhs.count else { fatalError() }
    for (i, l) in lhs.enumerated() {
        if l != rhs[i] { return false }
    }
    return true
}

@inlinable func stringFromCStr(_ str: UnsafePointer<Int8>?) -> String? {
    if let str = str { return String(cString: str, encoding: String.Encoding.utf8) }
    return nil
}

/*===============================================================================================================================*/
/// Returns `true` if the given string is either `nil` or empty.
///
/// - Parameter str: the string.
/// - Returns: `true` if the string is `nil` or empty.
///
@inlinable func e(_ str: String?) -> Bool { (str?.isEmpty ?? true) }

/*===============================================================================================================================*/
/// For non-NULL-terminated C strings we will first make a copy of the string and add a NULL character.
///
/// - Parameters:
///   - ptr: the pointer to the non-`nil`-terminated C string.
///   - count: the length of the string.
/// - Returns: a mutable buffer containing the `nil`-terminated copy of the string.
///
@inlinable func copyBuffer(ptr: UnsafePointer<UInt8>, count: Int) -> (UnsafeMutablePointer<UInt8>, Int) {
    let length: Int                         = (count + 1)
    let buf:    UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>.allocate(capacity: length)

    buf.initialize(from: ptr, count: count)
    buf[count] = 0
    return (buf, length)
}

/*===============================================================================================================================*/
/// For non-NULL-terminated C strings we will first make a copy of the string and add a NULL character.
///
/// - Parameters:
///   - p1: a pointer to the first character of the string.
///   - p2: a pointer to one byte past the last character of the string.
/// - Returns: a mutable buffer containing the `nil`-terminated copy of the string.
///
@inlinable func copyBuffer(pBegin p1: UnsafePointer<UInt8>, pEnd p2: UnsafePointer<UInt8>) -> (UnsafeMutablePointer<UInt8>, Int) {
    copyBuffer(ptr: p1, count: (p2 - p1))
}

/*===============================================================================================================================*/
/// Destroys a temporary buffer by deinitializing it and then deallocating it.
///
/// - Parameters:
///   - buf: the buffer.
///   - count: the length of the buffer.
///
@inlinable func destroyBuffer(buf: UnsafeMutablePointer<UInt8>, count: Int) {
    buf.deinitialize(count: count)
    buf.deallocate()
}

/*===============================================================================================================================*/
/// Destroys a temporary buffer by deinitializing it and then deallocating it.
///
/// - Parameters:
///   - buf: the buffer.
///   - count: the length of the buffer.
///
@inlinable func destroyBuffer(buf: UnsafeMutablePointer<Int8>, count: Int) {
    buf.deinitialize(count: count)
    buf.deallocate()
}

extension InputStream {
    @usableFromInline func read(_ buffer: UnsafeMutablePointer<Int8>, maxLength: Int) -> Int {
        buffer.withMemoryRebound(to: UInt8.self, capacity: maxLength) { (p: UnsafeMutablePointer<UInt8>) -> Int in read(p, maxLength: maxLength) }
    }
}
