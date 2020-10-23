/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: DOMLocatorImpl.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/21/20
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

public struct DOMLocatorImpl: DOMLocator, Hashable {

    public private(set) var byteOffset:   Int
    public private(set) var lineNumber:   Int
    public private(set) var columnNumber: Int
    public private(set) var utf16Offset:  Int
    public private(set) var uri:          String
    public private(set) var relatedNode:  Node

    public func hash(into hasher: inout Hasher) {
        hasher.combine(byteOffset)
        hasher.combine(lineNumber)
        hasher.combine(columnNumber)
        hasher.combine(utf16Offset)
        hasher.combine(uri)
        relatedNode.getHash(into: &hasher)
    }

    public static func == (lhs: DOMLocatorImpl, rhs: DOMLocatorImpl) -> Bool {
        ((lhs.byteOffset == rhs.byteOffset) && (lhs.lineNumber == rhs.lineNumber) && (lhs.columnNumber == rhs.columnNumber) && (lhs.utf16Offset == rhs.utf16Offset) &&
         (lhs.uri == rhs.uri) && lhs.relatedNode.isEqualTo(rhs.relatedNode))
    }
}
