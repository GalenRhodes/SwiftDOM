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

open class NamespaceNode: NamedNode {

    open override var localName:    String? { _localName }
    open override var namespaceURI: String? { _namespaceURI }
    open override var prefix:       String? {
        get { _prefix }
        set {
            if hasNamespace {
                if let p: String = newValue, !p.isEmpty {
                    guard let _ = regexNcName.firstMatch(in: p) else { fatalError("Invalid Prefix: \"\(p)\"") }
                    _prefix = p
                    _nodeName = "\(p):\(_localName ?? "")"
                }
                else {
                    _prefix = nil
                    _nodeName = (_localName ?? "")
                }
            }
            else if let p: String = newValue, !p.isEmpty {
                fatalError("Namespace error.")
            }
            else {
                _prefix = nil
            }
        }
    }

    var _prefix:       String? = nil
    var _localName:    String? = nil
    var _namespaceURI: String? = nil

    public init(_ owningDocument: DocumentNodeImpl, namespaceURI uri: String, qualifiedName qName: String) {
        let t: NsNamesCheckResult = nsNamesCheck(namespaceURI: uri, qualifiedName: qName)
        _prefix = t.prefix
        _localName = t.localName
        _namespaceURI = t.namespaceURI
        super.init(owningDocument, nodeName: qName)
    }

    public override init(_ owningDocument: DocumentNodeImpl, nodeName: String) { super.init(owningDocument, nodeName: nodeName) }

    open func rename(namespaceURI uri: String, qualifiedName qName: String) {
        let t: NsNamesCheckResult = nsNamesCheck(namespaceURI: uri, qualifiedName: qName)
        _prefix = t.prefix
        _localName = t.localName
        _namespaceURI = t.namespaceURI
        _nodeName = qName
    }
}
