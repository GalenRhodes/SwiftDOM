/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: NamespaceNode.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/22/20
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
private let xAscii:           String = "a-zA-Z_\\xC0-\\xD6\\xD8-\\xF6\\xF8-\\xFF"
private let xUnicode:         String = "\\u0100-\\u02ff\\u0370-\\u037D\\u037F-\\u1FFF\\u200C\\u200D\\u2070-\\u218F\\u2C00-\\u2FEF\\u3001-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFFD"
private let xExtended:        String = "\\U00010000-\\U000EFFFF"
private let xNoStart:         String = "0-9\\xB7\\u0300-\\u036F\\u203F-\\u2040\\.\\-"
private let xURIAttrDefault:  String = "xmlns"

private let xNameStartChar:   String = "\(xAscii):\(xUnicode)\(xExtended)"
private let xNameChar:        String = "\(xNameStartChar)\(xNoStart)"
private let xName:            String = "[\(xNameStartChar)][\(xNameChar)]*"

private let xNcNameStartChar: String = "\(xAscii)\(xUnicode)\(xExtended)" // No Colon Allowed
private let xNcNameChar:      String = "\(xNcNameStartChar)\(xNoStart)"
private let xNcName:          String = "[\(xNcNameStartChar)][\(xNcNameChar)]*"

private let xNameAll:         String = "^\(xName)$"
private let xNcNameAll:       String = "^\(xNcName)$"
private let xQName:           String = "^(?:(\(xNcName)):)?(\(xNcName))$"
private let xURIAttr:         String = "^\(xURIAttrDefault)(?:[:](\(xNcName)))?$"
//@f:1

open class NamespaceNode: ParentNode {

    @usableFromInline static let regexQName:  NSRegularExpression = try! NSRegularExpression(pattern: xQName)
    @usableFromInline static let regexNcName: NSRegularExpression = try! NSRegularExpression(pattern: xNcNameAll)
    @usableFromInline static let regexName:   NSRegularExpression = try! NSRegularExpression(pattern: xNameAll)

    @inlinable open override var nodeName:     String { _nodeName }
    @inlinable open override var localName:    String? { _localName }
    @inlinable open override var namespaceURI: String? { _namespaceURI }
    @inlinable open override var prefix:       String? {
        get { _prefix }
        set {
            if let pfx: String = newValue, !pfx.isEmpty {
                guard let _ = NamespaceNode.regexNcName.firstMatch(in: pfx) else { fatalError("Invalid Prefix: \(pfx)") }
                guard hasNamespace else { fatalError("Namespace error.") }
                _prefix = pfx
                _nodeName = "\(pfx):\(_localName ?? "")"
            }
            else {
                _prefix = nil
                _nodeName = (_localName ?? "")
            }
        }
    }

    @usableFromInline var _nodeName:     String  = ""
    @usableFromInline var _prefix:       String? = nil
    @usableFromInline var _localName:    String? = nil
    @usableFromInline var _namespaceURI: String? = nil

    public init(_ owningDocument: DocumentNodeImpl, namespaceURI uri: String, qualifiedName qName: String) {
        guard !uri.isEmpty else { fatalError("Invalid URI: \(uri)") }
        guard let m: RegExResult = NamespaceNode.regexQName.firstMatch(in: qName) else { fatalError("Invalid Qualified Name: \(qName)") }

        _namespaceURI = uri
        _nodeName = qName
        _localName = (qName.matchGroup(match: m, group: 2) ?? qName)
        _prefix = qName.matchGroup(match: m, group: 1)

        super.init(owningDocument)
    }

    public init(_ owningDocument: DocumentNodeImpl, nodeName: String) {
        guard let _ = NamespaceNode.regexName.firstMatch(in: nodeName) else { fatalError("Invalid Node Name: \(nodeName)") }
        _nodeName = nodeName
        super.init(owningDocument)
    }
}
