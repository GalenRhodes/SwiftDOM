/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: DocumentTypeNodeImpl.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/26/20
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

open class DocumentTypeNodeImpl: NodeImpl, DocumentTypeNode {

    open override var nodeName: String { name }
    open override var nodeType: NodeTypes { .DocumentTypeNode }
    open override var textContent: String? {
        get { nil }
        set {}
    }

    open internal(set) var name:           String                     = ""
    open internal(set) var publicId:       String                     = ""
    open internal(set) var systemId:       String                     = ""
    open internal(set) var internalSubset: String                     = ""
    open internal(set) var entities:       NamedNodeMap<EntityNode>   = NamedNodeMap()
    open internal(set) var notations:      NamedNodeMap<NotationNode> = NamedNodeMap()

    init(_ owningDocument: DocumentNodeImpl, name: String, publicId: String, systemId: String, internalSubset: String) {
        self.name = name
        self.publicId = publicId
        self.systemId = systemId
        self.internalSubset = internalSubset
        super.init(owningDocument)
    }

    open override func isEqualTo(_ other: Node) -> Bool {
        guard super.isEqualTo(other), let dt: DocumentTypeNode = (other as? DocumentTypeNode) else { return false }
        guard publicId == dt.publicId && systemId == dt.systemId && internalSubset == dt.internalSubset else { return false }
        guard entities == dt.entities && notations == dt.notations else { return false }
        return true
    }

    open override func baseClone(_ doc: DocumentNodeImpl, postEvent: Bool, deep: Bool) -> NodeImpl {
        let e = DocumentTypeNodeImpl(doc, name: name, publicId: publicId, systemId: systemId, internalSubset: deep ? internalSubset : "")
        if deep {
            e.entities = entities.clone(postEvents: postEvent)
            e.notations = notations.clone(postEvents: postEvent)
        }
        return e
    }

    public static func == (lhs: DocumentTypeNodeImpl, rhs: DocumentTypeNodeImpl) -> Bool { lhs === rhs }
}
