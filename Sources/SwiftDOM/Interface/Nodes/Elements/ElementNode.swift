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
//@f:0
    var schemaTypeInfo: TypeInfo? { get }
    var tagName:        String    { get }
//@f:1

    func attributeValueWith(name: String) -> String?

    func attributeValueWith(namespaceURI: String, name: String) -> String?

    func attributeWith(name: String) -> AttributeNode?

    func attributeWith(namespaceURI: String, name: String) -> AttributeNode?

    func attribute(where body: (AttributeNode) throws -> Bool) rethrows -> AttributeNode?

    func elementsBy(tagName: String) -> NodeList<ElementNode>

    func elementsBy(namespaceURI: String, name: String) -> NodeList<ElementNode>

    func hasAttributeWith(name: String) -> Bool

    func hasAttributeWith(namespaceURI: String, name: String) -> Bool

    func setAttributeWith(name: String, value: String)

    func setAttributeWith(namespaceURI: String, name: String, value: String)

    @discardableResult func setAttribute(attribute: AttributeNode) -> AttributeNode?

    @discardableResult func setAttributeNS(attribute: AttributeNode) -> AttributeNode?

    @discardableResult func removeAttributeWith(name: String) -> AttributeNode?

    @discardableResult func removeAttributeWith(namespaceURI: String, name: String) -> AttributeNode?

    @discardableResult func removeAttribute(attribute: AttributeNode) -> AttributeNode?

    func setIdAttributeWith(name: String, isId: Bool)

    func setIdAttributeWith(namespaceURI: String, name: String, isId: Bool)

    func setIdAttribute(attribute: AttributeNode, isId: Bool)
}

public class AnyElementNode: AnyNode, ElementNode {
//@f:0
           var element:        ElementNode { node as! ElementNode   }
    public var schemaTypeInfo: TypeInfo?   { element.schemaTypeInfo }
    public var tagName:        String      { element.tagName        }
//@f:1

    public init(_ element: ElementNode) { super.init(element) }

    public func attributeValueWith(name: String) -> String? {
        element.attributeValueWith(name: name)
    }

    public func attributeValueWith(namespaceURI: String, name: String) -> String? {
        element.attributeValueWith(namespaceURI: namespaceURI, name: name)
    }

    public func attributeWith(name: String) -> AttributeNode? {
        element.attributeWith(name: name)
    }

    public func attributeWith(namespaceURI: String, name: String) -> AttributeNode? {
        element.attributeWith(namespaceURI: namespaceURI, name: name)
    }

    public func attribute(where body: (AttributeNode) throws -> Bool) rethrows -> AttributeNode? {
        try element.attribute(where: body)
    }

    public func elementsBy(tagName: String) -> NodeList<ElementNode> {
        element.elementsBy(tagName: tagName)
    }

    public func elementsBy(namespaceURI: String, name: String) -> NodeList<ElementNode> {
        element.elementsBy(namespaceURI: namespaceURI, name: name)
    }

    public func hasAttributeWith(name: String) -> Bool {
        element.hasAttributeWith(name: name)
    }

    public func hasAttributeWith(namespaceURI: String, name: String) -> Bool {
        element.hasAttributeWith(namespaceURI: namespaceURI, name: name)
    }

    @discardableResult public func removeAttributeWith(name: String) -> AttributeNode? {
        element.removeAttributeWith(name: name)
    }

    @discardableResult public func removeAttributeWith(namespaceURI: String, name: String) -> AttributeNode? {
        element.removeAttributeWith(namespaceURI: namespaceURI, name: name)
    }

    @discardableResult public func removeAttribute(attribute: AttributeNode) -> AttributeNode? {
        element.removeAttribute(attribute: attribute)
    }

    public func setAttributeWith(name: String, value: String) {
        element.setAttributeWith(name: name, value: value)
    }

    public func setAttributeWith(namespaceURI: String, name: String, value: String) {
        element.setAttributeWith(namespaceURI: namespaceURI, name: name, value: value)
    }

    @discardableResult public func setAttribute(attribute: AttributeNode) -> AttributeNode? {
        element.setAttribute(attribute: attribute)
    }

    @discardableResult public func setAttributeNS(attribute: AttributeNode) -> AttributeNode? {
        element.setAttributeNS(attribute: attribute)
    }

    public func setIdAttributeWith(name: String, isId: Bool) {
        element.setIdAttributeWith(name: name, isId: isId)
    }

    public func setIdAttributeWith(namespaceURI: String, name: String, isId: Bool) {
        element.setIdAttributeWith(namespaceURI: namespaceURI, name: name, isId: isId)
    }

    public func setIdAttribute(attribute: AttributeNode, isId: Bool) {
        element.setIdAttribute(attribute: attribute, isId: isId)
    }
}
