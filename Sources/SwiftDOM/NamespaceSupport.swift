/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: NamespaceSupport.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/15/20
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

//@f:0
/// [Reference](https://www.w3.org/TR/REC-xml/#NT-NameStartChar)
///
internal let xAscii:           String = "a-zA-Z_\\xC0-\\xD6\\xD8-\\xF6\\xF8-\\xFF"
internal let xUnicode:         String = "\\u0100-\\u02ff\\u0370-\\u037D\\u037F-\\u1FFF\\u200C\\u200D\\u2070-\\u218F\\u2C00-\\u2FEF\\u3001-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFFD"
internal let xExtended:        String = "\\U00010000-\\U000EFFFF"
internal let xNoStart:         String = "0-9\\xB7\\u0300-\\u036F\\u203F-\\u2040\\.\\-"

internal let xNameStartChar:   String = "\(xAscii):\(xUnicode)\(xExtended)"
internal let xNameChar:        String = "\(xNameStartChar)\(xNoStart)"
internal let xName:            String = "[\(xNameStartChar)][\(xNameChar)]*"
internal let xNameAll:         String = "^\(xName)$"

internal let xNcNameStartChar: String = "\(xAscii)\(xUnicode)\(xExtended)" // No Colon Allowed
internal let xNcNameChar:      String = "\(xNcNameStartChar)\(xNoStart)"
internal let xNcName:          String = "[\(xNcNameStartChar)][\(xNcNameChar)]*"

internal let xNcNameAll:       String = "^\(xNcName)$"
internal let xQName:           String = "^(?:(\(xNcName)):)?(\(xNcName))$"
internal let xURIAttr:         String = "^\(Namespace.XMLNS_PREFIX.rawValue)(?:[:](\(xNcName)))?$"
//@f:1

public enum Namespace: String {
    case NSDECL       = "http://www.w3.org/xmlns/2000/"
    case XMLNS        = "http://www.w3.org/XML/1998/namespace"
    case XMLNS_PREFIX = "xmlns"
}

public let regexQName:  NSRegularExpression = try! NSRegularExpression(pattern: xQName)
public let regexNcName: NSRegularExpression = try! NSRegularExpression(pattern: xNcNameAll)
public let regexName:   NSRegularExpression = try! NSRegularExpression(pattern: xNameAll)

public typealias NsNamesCheckResult = (namespaceURI: String, prefix: String?, localName: String)

public func nsNamesCheck(namespaceURI uri: String, qualifiedName qName: String) -> NsNamesCheckResult {
    guard !uri.isEmpty else { fatalError("Invalid URI: \"\(uri)\"") }
    guard let m: RegExResult = regexQName.firstMatch(in: qName) else { fatalError("Invalid Qualified Name: \"\(qName)\"") }

    let prefix:    String? = qName.matchGroup(match: m, group: 1)
    let localName: String  = (qName.matchGroup(match: m, group: 2) ?? qName)

    return (uri, prefix, localName)
}
