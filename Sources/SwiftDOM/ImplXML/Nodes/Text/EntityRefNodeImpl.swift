/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: EntityRefNodeImpl.swift
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
import Rubicon

open class EntityRefNodeImpl: ParentNode, EntityRefNode {
    open override var nodeType: NodeTypes { .EntityReferenceNode }
    open override var nodeName: String { entityName }

    open internal(set) var entityName: String = ""

    public var entity: EntityNodeImpl? { load() }
    @usableFromInline var _entity: EntityNodeImpl? = nil

    public init(_ owningDocument: DocumentNodeImpl, entityName eName: String, lookup: Bool = true) {
        entityName = eName
        _entity = nil
        super.init(owningDocument)
        if lookup { load() }
    }

    public init(_ owningDocument: DocumentNodeImpl, entity ent: EntityNodeImpl) {
        guard ent.owningDocument === owningDocument else { fatalError("Entity belongs to wrong document.") }
        _entity = ent
        entityName = ent.entityName
        super.init(owningDocument)
        load(entity: ent)
    }

    @inlinable @discardableResult func load() -> EntityNodeImpl? {
        if _entity == nil {
            switch entityName.lowercased() {
                case "amp":  _entity = createEntity("&")
                case "lt":   _entity = createEntity("<")
                case "gt":   _entity = createEntity(">")
                case "quot": _entity = createEntity("\"")
                case "apos": _entity = createEntity("'")
                default:     _entity = findEntity()
            }
            if let e: EntityNodeImpl = _entity { load(entity: e) }
        }
        return _entity
    }

    @usableFromInline func findEntity() -> EntityNodeImpl? {
        guard let dt: DocumentTypeNodeImpl = _owningDocument._docType else { return nil }
        return dt._entities.first(where: { ent in ent.entityName == entityName })
    }

    @usableFromInline func createEntity(_ content: String) -> EntityNodeImpl {
        let ent = EntityNodeImpl(_owningDocument, entityName: entityName, notationName: "", publicId: "", systemId: "", xmlEncoding: "UTF-8", xmlVersion: "1.0")
        ent.append(child: TextNodeImpl(_owningDocument, content: content))
        return ent
    }

    @usableFromInline func load(entity: EntityNodeImpl) {
        //-----------------------------------------------------------------
        // EntityRefNodes always do deep clone of their entity's children.
        //-----------------------------------------------------------------
        entity.forEachChild { (node: NodeImpl) in self.append(child: node.baseClone(entity._owningDocument, postEvent: false, deep: true)) }
    }

    open override func baseClone(_ doc: DocumentNodeImpl, postEvent: Bool, deep: Bool) -> NodeImpl {
        //-----------------------------------------------------------------
        // EntityRefNodes always do deep clone of their entity's children.
        //-----------------------------------------------------------------
        EntityRefNodeImpl(doc, entityName: entityName, lookup: true)
    }

    public static func == (lhs: EntityRefNodeImpl, rhs: EntityRefNodeImpl) -> Bool { lhs === rhs }
}
