/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: ElementImpl.swift
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

open class ElementImpl: NamespaceNode, ElementNode {

    @inlinable open var tagName: String { nodeName }
    @inlinable open override var attributes: NamedNodeMap<AnyAttributeNode> { super.attributes }

    public private(set) var schemaTypeInfo: TypeInfo? = nil

    public override init(_ owningDocument: DocumentNode, namespaceURI uri: String, qualifiedName qName: String) {
        super.init(owningDocument, namespaceURI: uri, qualifiedName: qName)
    }

    public init(_ owningDocument: DocumentNode, tagName: String) {
        super.init(owningDocument, nodeName: tagName)
    }

    public func attributeValueWith(name: String) -> String? { fatalError("attributeValueWith(name:) has not been implemented") }

    public func attributeValueWith(namespaceURI: String, name: String) -> String? { fatalError("attributeValueWith(namespaceURI:name:) has not been implemented") }

    public func attributeWith(name: String) -> AttributeNode? { fatalError("attributeWith(name:) has not been implemented") }

    public func attributeWith(namespaceURI: String, name: String) -> AttributeNode? { fatalError("attributeWith(namespaceURI:name:) has not been implemented") }

    public func elementsBy(tagName: String) -> NodeList<AnyElementNode> { fatalError("elementsBy(tagName:) has not been implemented") }

    public func elementsBy(namespaceURI: String, name: String) -> NodeList<AnyElementNode> { fatalError("elementsBy(namespaceURI:name:) has not been implemented") }

    public func hasAttributeWith(name: String) -> Bool { fatalError("hasAttributeWith(name:) has not been implemented") }

    public func hasAttributeWith(namespaceURI: String, name: String) -> Bool { fatalError("hasAttributeWith(namespaceURI:name:) has not been implemented") }

    public func removeAttributeWith(name: String) {}

    public func removeAttributeWith(namespaceURI: String, name: String) {}

    public func removeAttribute(attribute: AttributeNode) -> AttributeNode { fatalError("removeAttribute(attribute:) has not been implemented") }

    public func setAttributeWith(name: String, value: String) {}

    public func setAttributeWith(namespaceURI: String, name: String, value: String) {}

    public func setAttribute(attribute: AttributeNode) -> AttributeNode? { fatalError("setAttribute(attribute:) has not been implemented") }

    public func setAttributeNS(attribute: AttributeNode) -> AttributeNode? { fatalError("setAttributeNS(attribute:) has not been implemented") }

    public func setIdAttributeWith(name: String, isId: Bool) {}

    public func setIdAttributeWith(namespaceURI: String, name: String, isId: Bool) {}

    public func setIdAttribute(attribute: AttributeNode, isId: Bool) {}
}
