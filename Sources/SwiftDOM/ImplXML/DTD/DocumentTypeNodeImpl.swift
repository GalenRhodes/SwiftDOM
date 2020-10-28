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

    open override var nodeName:    String { name }
    open override var nodeType:    NodeTypes { .DocumentTypeNode }
    open override var textContent: String? {
        get { nil }
        set {}
    }

    open internal(set) var name:           String = ""
    open internal(set) var publicId:       String = ""
    open internal(set) var systemId:       String = ""
    open internal(set) var internalSubset: String = ""

    open var entities: NamedNodeMap<EntityNode> { _entities.mapAs({ $0 as EntityNode }) }
    open var notations: NamedNodeMap<NotationNode> { _notations.mapAs({ $0 as NotationNode }) }

    var _entities:  DocTypeNamedNodeMap<EntityNodeImpl>!   = nil
    var _notations: DocTypeNamedNodeMap<NotationNodeImpl>! = nil

    public init(_ owningDocument: DocumentNodeImpl, name n: String, publicId p: String, systemId s: String, internalSubset i: String) {
        name = n
        publicId = p
        systemId = s
        internalSubset = i

        super.init(owningDocument)

        _entities = DocTypeNamedNodeMap<EntityNodeImpl>(docType: self)
        _notations = DocTypeNamedNodeMap<NotationNodeImpl>(docType: self)
    }

    open override func isEqualTo(_ other: Node) -> Bool {
        guard super.isEqualTo(other), let dt: DocumentTypeNode = (other as? DocumentTypeNode) else { return false }
        guard (publicId == dt.publicId) && (systemId == dt.systemId) && (internalSubset == dt.internalSubset) else { return false }
        guard (entities == dt.entities) && (notations == dt.notations) else { return false }
        return true
    }

    open override func baseClone(_ doc: DocumentNodeImpl, postEvent: Bool, deep: Bool) -> NodeImpl {
        DocumentTypeNodeImpl(doc, name: name, publicId: publicId, systemId: systemId, internalSubset: deep ? internalSubset : "")
    }

    public static func == (lhs: DocumentTypeNodeImpl, rhs: DocumentTypeNodeImpl) -> Bool { lhs === rhs }
}

class DocTypeNamedNodeMap<Element>: LiveNamedNodeMap<Element> {
    var data:    [Element] = []
    var docType: DocumentTypeNodeImpl { parent as! DocumentTypeNodeImpl }

    init(docType p: DocumentTypeNodeImpl) {
        super.init(parent: p)
    }

    public override func mapAs<S>(_ transform: (Element) throws -> S) rethrows -> NamedNodeMap<S> {
        DocTypeNamedNodeMap<S>(docType: docType)
    }
}

extension DocTypeNamedNodeMap where Element == EntityNodeImpl {
    func nameNodeMapDidChange() {
        if self !== docType._entities {
            data.removeAll()
            for n in docType._entities.data { data.append(n) }
        }
    }
}

extension DocTypeNamedNodeMap where Element == NotationNodeImpl {
    func nameNodeMapDidChange() {
        if self !== docType._notations {
            data.removeAll()
            for n in docType._notations.data { data.append(n) }
        }
    }
}