/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: EntityNodeImpl.swift
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

open class EntityNodeImpl: ParentNode, EntityNode {
    open override var nodeType: NodeTypes { .EntityNode }
    open override var nodeName: String { entityName }

    open internal(set) var inputEncoding: String.Encoding = String.Encoding.utf8
    open internal(set) var notationName:  String          = ""
    open internal(set) var publicId:      String          = ""
    open internal(set) var systemId:      String          = ""
    open internal(set) var xmlEncoding:   String          = ""
    open internal(set) var xmlVersion:    String          = ""

    var entityName: String = ""

    public init(_ owningDocument: DocumentNodeImpl,
                entityName: String,
                notationName: String,
                publicId: String,
                systemId: String,
                inputEncoding: String.Encoding = String.Encoding.utf8,
                xmlEncoding: String,
                xmlVersion: String) {
        self.inputEncoding = inputEncoding
        self.notationName = notationName
        self.publicId = publicId
        self.systemId = systemId
        self.xmlEncoding = xmlEncoding
        self.xmlVersion = xmlVersion
        self.entityName = entityName
        super.init(owningDocument)
    }

    open override func baseClone(_ doc: DocumentNodeImpl, postEvent: Bool, deep: Bool) -> NodeImpl {
        let e = EntityNodeImpl(doc,
                               entityName: entityName,
                               notationName: notationName,
                               publicId: publicId,
                               systemId: systemId,
                               inputEncoding: inputEncoding,
                               xmlEncoding: xmlEncoding,
                               xmlVersion: xmlVersion)
        forEachChild { e.append(child: $0.cloneNode(doc, postEvent: postEvent, deep: true)) }
        return e
    }

    public static func == (lhs: EntityNodeImpl, rhs: EntityNodeImpl) -> Bool { lhs === rhs }
}
