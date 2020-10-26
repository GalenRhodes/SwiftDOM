/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: Element.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/14/20
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

public protocol ElementNode: Node {

    var schemaTypeInfo: TypeInfo? { get }
    var tagName:        String { get }

    func attributeValueWith(name: String) -> String?

    func attributeValueWith(namespaceURI: String, name: String) -> String?

    func attributeWith(name: String) -> AttributeNode?

    func attributeWith(namespaceURI: String, name: String) -> AttributeNode?

    func elementsBy(tagName: String) -> NodeList<ElementNode>

    func elementsBy(namespaceURI: String, name: String) -> NodeList<ElementNode>

    func hasAttributeWith(name: String) -> Bool

    func hasAttributeWith(namespaceURI: String, name: String) -> Bool

    func removeAttributeWith(name: String) -> AttributeNode?

    func removeAttributeWith(namespaceURI: String, name: String) -> AttributeNode?

    func removeAttribute(attribute: AttributeNode) -> AttributeNode?

    func setAttributeWith(name: String, value: String)

    func setAttributeWith(namespaceURI: String, name: String, value: String)

    func setAttribute(attribute: AttributeNode) -> AttributeNode?

    func setAttributeNS(attribute: AttributeNode) -> AttributeNode?

    func setIdAttributeWith(name: String, isId: Bool)

    func setIdAttributeWith(namespaceURI: String, name: String, isId: Bool)

    func setIdAttribute(attribute: AttributeNode, isId: Bool)
}

public class AnyElementNode: AnyNode, ElementNode {

    @inlinable var element: ElementNode { node as! ElementNode }

    public var schemaTypeInfo: TypeInfo? { element.schemaTypeInfo }
    public var tagName:        String { element.tagName }

    public init(_ element: ElementNode) { super.init(element) }

    @inlinable open func attributeValueWith(name: String) -> String? {
        element.attributeValueWith(name: name)
    }

    @inlinable open func attributeValueWith(namespaceURI: String, name: String) -> String? {
        element.attributeValueWith(namespaceURI: namespaceURI, name: name)
    }

    @inlinable open func attributeWith(name: String) -> AttributeNode? {
        element.attributeWith(name: name)
    }

    @inlinable open func attributeWith(namespaceURI: String, name: String) -> AttributeNode? {
        element.attributeWith(namespaceURI: namespaceURI, name: name)
    }

    @inlinable open func elementsBy(tagName: String) -> NodeList<ElementNode> {
        element.elementsBy(tagName: tagName)
    }

    @inlinable open func elementsBy(namespaceURI: String, name: String) -> NodeList<ElementNode> {
        element.elementsBy(namespaceURI: namespaceURI, name: name)
    }

    @inlinable open func hasAttributeWith(name: String) -> Bool {
        element.hasAttributeWith(name: name)
    }

    @inlinable open func hasAttributeWith(namespaceURI: String, name: String) -> Bool {
        element.hasAttributeWith(namespaceURI: namespaceURI, name: name)
    }

    @inlinable open func removeAttributeWith(name: String) -> AttributeNode? {
        element.removeAttributeWith(name: name)
    }

    @inlinable open func removeAttributeWith(namespaceURI: String, name: String) -> AttributeNode? {
        element.removeAttributeWith(namespaceURI: namespaceURI, name: name)
    }

    @inlinable open func removeAttribute(attribute: AttributeNode) -> AttributeNode? {
        element.removeAttribute(attribute: attribute)
    }

    @inlinable open func setAttributeWith(name: String, value: String) {
        element.setAttributeWith(name: name, value: value)
    }

    @inlinable open func setAttributeWith(namespaceURI: String, name: String, value: String) {
        element.setAttributeWith(namespaceURI: namespaceURI, name: name, value: value)
    }

    @inlinable open func setAttribute(attribute: AttributeNode) -> AttributeNode? {
        element.setAttribute(attribute: attribute)
    }

    @inlinable open func setAttributeNS(attribute: AttributeNode) -> AttributeNode? {
        element.setAttributeNS(attribute: attribute)
    }

    @inlinable open func setIdAttributeWith(name: String, isId: Bool) {
        element.setIdAttributeWith(name: name, isId: isId)
    }

    @inlinable open func setIdAttributeWith(namespaceURI: String, name: String, isId: Bool) {
        element.setIdAttributeWith(namespaceURI: namespaceURI, name: name, isId: isId)
    }

    @inlinable open func setIdAttribute(attribute: AttributeNode, isId: Bool) {
        element.setIdAttribute(attribute: attribute, isId: isId)
    }
}

