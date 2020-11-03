/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: NamedNodeImpl.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 11/2/20
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

public class NamedNodeImpl: ParentNodeImpl {
//@f:0
    public override   var hasNamespace  : Bool    { !(_namespaceURI?.isTrimEmpty ?? true)       }
    public override   var nodeName      : String  { _nodeName                                   }
    public override   var namespaceURI  : String? { _namespaceURI                               }
    public override   var localName     : String? { _localName                                  }
    public override   var prefix        : String? { get { _prefix } set { setPrefix(newValue) } }
    @usableFromInline var _nodeName     : String
    @usableFromInline var _localName    : String?
    @usableFromInline var _namespaceURI : String?
    @usableFromInline var _prefix       : String?
//@f:1

    public init(_ owningDocument: DocumentNode, nodeName: String) {
        guard let _ = regexName.firstMatch(in: nodeName) else { fatalError("Invalid node name.") }
        _nodeName = nodeName
        _localName = nil
        _prefix = nil
        _namespaceURI = nil
        super.init(owningDocument)
    }

    public init(_ owningDocument: DocumentNode, namespaceURI: String, qualifiedName: String) {
        guard !namespaceURI.trimmed.isEmpty else { fatalError("Invalid namespace URI") }
        guard let m = regexQName.firstMatch(in: qualifiedName) else { fatalError("Invalid qualified name.") }
        _namespaceURI = namespaceURI
        _nodeName = qualifiedName
        _localName = qualifiedName.matchGroup(match: m, group: 2, default: qualifiedName)
        _prefix = qualifiedName.matchGroup(match: m, group: 1, default: nil)
        super.init(owningDocument)
    }

    func setPrefix(_ newPrefix: String?) {
        if let newPrefix = newPrefix, !newPrefix.isEmpty {
            guard let _ = regexNsName.firstMatch(in: newPrefix) else { fatalError("Invalid prefix.") }
            guard hasNamespace else { fatalError("Node does not have a namespace URI.") }
            _prefix = newPrefix
        }
        else {
            _prefix = nil
        }
    }
}
