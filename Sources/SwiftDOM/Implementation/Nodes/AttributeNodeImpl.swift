/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: AttributeNodeImpl.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/23/20
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

open class AttributeNodeImpl: NamespaceNode, AttributeNode {

    open internal(set) var ownerElement:   ElementNode? = nil
    open internal(set) var schemaTypeInfo: TypeInfo?    = nil
    open internal(set) var isSpecified:    Bool         = false
    open internal(set) var isId:           Bool         = false

    @inlinable open var name:  String { nodeName }
    @inlinable open var value: String {
        /* TODO: Implement me... */
        get { "" }
        set {}
    }

    @inlinable open override var nodeType:    NodeTypes { NodeTypes.AttributeNode }
    @inlinable open override var nodeValue:   String? {
        get { value }
        set { if let v = newValue { value = v } }
    }
    @inlinable open override var textContent: String? {
        get { value }
        set { if let v = newValue { value = v } }
    }

    public init(_ owningDocument: DocumentNodeImpl, namespaceURI uri: String, qualifiedName qName: String, value: String) {
        super.init(owningDocument, namespaceURI: uri, qualifiedName: qName)
        self.value = value
    }

    public init(_ owningDocument: DocumentNodeImpl, attributeName name: String, value: String) {
        super.init(owningDocument, nodeName: name)
        self.value = value
    }

    @inlinable public static func == (lhs: AttributeNodeImpl, rhs: AttributeNodeImpl) -> Bool { lhs === rhs }
}
