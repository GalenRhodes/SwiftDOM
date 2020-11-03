/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: ElementNodeImpl.swift
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

public class ElementNodeImpl: NamedNodeImpl, ElementNode {
//@f:0
    public internal(set) var schemaTypeInfo   : TypeInfo?                   = nil
    public               var tagName          : String                      { nodeName                           }
    public override      var attributes       : NamedNodeMap<AttributeNode> { ElementAttributeMap(element: self) }
    @usableFromInline    var _attrs           : [AttributeNodeImpl]         = []
    @usableFromInline    var _attrNameCache   : [String:AttributeNodeImpl]  = [:]
    @usableFromInline    var _attrNsNameCache : [NsName:AttributeNodeImpl]  = [:]
//@f:1

    public init(_ owningDocument: DocumentNode, tagName: String) {
        super.init(owningDocument, nodeName: tagName)
    }

    public override init(_ owningDocument: DocumentNode, namespaceURI: String, qualifiedName: String) {
        super.init(owningDocument, namespaceURI: namespaceURI, qualifiedName: qualifiedName)
    }

    override func canBeParentTo(child: Node) -> Bool { child.isNodeType(.ElementNode, .TextNode, .CommentNode, .CDataSectionNode, .EntityReferenceNode, .ProcessingInstructionNode) }

    public func elementsBy(tagName: String) -> NodeList<ElementNode> { ElementNodeList(parent: self, nodeName: tagName) }

    public func elementsBy(namespaceURI: String, name: String) -> NodeList<ElementNode> { ElementNodeList(parent: self, namespaceURI: namespaceURI, localName: name) }

    @inlinable public func attributeValueWith(name: String) -> String? { _attributeWith(name: name)?.value }

    @inlinable public func attributeValueWith(namespaceURI: String, name: String) -> String? { _attributeWith(namespaceURI: namespaceURI, name: name)?.value }

    @inlinable public func attributeWith(name: String) -> AttributeNode? { _attributeWith(name: name) }

    @inlinable public func attributeWith(namespaceURI: String, name: String) -> AttributeNode? { _attributeWith(namespaceURI: namespaceURI, name: name) }

    @inlinable public func attribute(where body: (AttributeNode) throws -> Bool) rethrows -> AttributeNode? { try _attribute(where: body) }

    @inlinable public func hasAttributeWith(name: String) -> Bool { (_attributeWith(name: name) != nil) }

    @inlinable public func hasAttributeWith(namespaceURI: String, name: String) -> Bool { (_attributeWith(namespaceURI: namespaceURI, name: name) != nil) }

    @inlinable public func setAttributeWith(name: String, value: String) {
        if let attr = _attributeWith(name: name) {
            attr.value = value
        }
        else {
            let attr = owningDocument.createAttribute(name: name) as! AttributeNodeImpl
            attr.value = value
            attr.ownerElement = self
            _attrs.append(attr)
            _attrNameCache[name] = attr
        }
        notifyAttributeListeners()
    }

    @inlinable public func setAttributeWith(namespaceURI: String, name: String, value: String) {
        if let attr = _attributeWith(namespaceURI: namespaceURI, name: name) {
            attr.value = value
        }
        else {
            let attr = owningDocument.createAttribute(namespaceURI: namespaceURI, name: name) as! AttributeNodeImpl
            attr.value = value
            attr.ownerElement = self
            _attrs.append(attr)
            _attrNsNameCache[attr.nsName] = attr
        }
        notifyAttributeListeners()
    }

    @inlinable @discardableResult public func setAttribute(attribute: AttributeNode) -> AttributeNode? {
        guard let newAttr = (attribute as? AttributeNodeImpl) else { fatalError("Invalid Attribute") }
        guard newAttr.parentNode == nil else { fatalError("Attribute already owned by another element.") }
        var oa: AttributeNodeImpl? = nil

        if let oldAttr = _attributeWith(name: newAttr.name) {
            removeAttribute(attribute: oldAttr)
            oa = oldAttr
        }

        newAttr.ownerElement = self
        _attrs.append(newAttr)
        _attrNameCache[newAttr.name] = newAttr
        notifyAttributeListeners()
        return oa
    }

    @inlinable @discardableResult public func setAttributeNS(attribute: AttributeNode) -> AttributeNode? {
        guard attribute.owningDocument.isSameNode(as: owningDocument) else { fatalError("Wrong document.") }
        guard let newAttr = (attribute as? AttributeNodeImpl) else { fatalError("Invalid Attribute") }
        guard newAttr.parentNode == nil else { fatalError("Attribute already owned by another element.") }
        var oa: AttributeNodeImpl? = nil

        if let oldAttr = _attributeWith(namespaceURI: newAttr.namespaceURI ?? "", name: newAttr.localName ?? newAttr.nodeName) {
            removeAttribute(attribute: oldAttr)
            oa = oldAttr
        }

        newAttr.ownerElement = self
        _attrs.append(newAttr)
        _attrNsNameCache[newAttr.nsName] = newAttr
        notifyAttributeListeners()
        return oa
    }

    @inlinable @discardableResult public func removeAttributeWith(name: String) -> AttributeNode? {
        var oa: AttributeNodeImpl? = nil

        if let attr = _attributeWith(name: name) {
            _attrs.removeAll(where: { $0.isSameNode(as: attr) })
            _attrNameCache.removeValue(forKey: attr.name)
            _attrNsNameCache.removeValue(forKey: attr.nsName)
            attr.ownerElement = nil
            oa = attr
            notifyAttributeListeners()
        }

        return oa
    }

    @inlinable @discardableResult public func removeAttributeWith(namespaceURI: String, name: String) -> AttributeNode? {
        var oa: AttributeNodeImpl? = nil

        if let attr: AttributeNodeImpl = _attributeWith(namespaceURI: namespaceURI, name: name) {
            _attrs.removeAll { $0.isSameNode(as: attr) }
            _attrNameCache.removeValue(forKey: attr.name)
            _attrNsNameCache.removeValue(forKey: attr.nsName)
            attr.ownerElement = nil
            oa = attr
            notifyAttributeListeners()
        }

        return oa
    }

    @inlinable @discardableResult public func removeAttribute(attribute: AttributeNode) -> AttributeNode? {
        guard let oldAttr = (attribute as? AttributeNodeImpl), (oldAttr.ownerElement?.isSameNode(as: self) ?? false) else { fatalError("Attribute not found.") }
        _attrs.removeAll { $0.isSameNode(as: oldAttr)  }
        _attrNameCache.removeValue(forKey: oldAttr.name)
        _attrNsNameCache.removeValue(forKey: oldAttr.nsName)
        oldAttr.ownerElement = nil
        notifyAttributeListeners()
        return oldAttr
    }

    @inlinable public func setIdAttributeWith(name: String, isId: Bool) -> AttributeNode? {
        if let attr = _attributeWith(name: name) {
            attr.isId = isId
            return attr
        }
        return nil
    }

    @inlinable public func setIdAttributeWith(namespaceURI: String, name: String, isId: Bool) -> AttributeNode? {
        if let attr = _attributeWith(namespaceURI: namespaceURI, name: name) {
            attr.isId = isId
            return attr
        }
        return nil
    }

    @inlinable public func setIdAttribute(attribute: AttributeNode, isId: Bool) {
        guard let attr = (attribute as? AttributeNodeImpl), let oe = attr.ownerElement, oe.isSameNode(as: self) else { fatalError("Attribute not found.") }
        attr.isId = isId
    }

    @inlinable func _attributeWith(name: String) -> AttributeNodeImpl? {
        if let attr = _attrNameCache[name] { return attr }
        for attr in _attrs {
            if attr.name == name {
                _attrNameCache[name] = attr
                return attr
            }
        }
        return nil
    }

    @inlinable func _attributeWith(namespaceURI: String, name: String) -> AttributeNodeImpl? {
        let nsName = NsName(namespaceURI, name)
        if let attr = _attrNsNameCache[nsName] { return attr }
        for attr in _attrs {
            if attr.hasNamespace && (namespaceURI == attr.namespaceURI) && (name == attr.localName) {
                _attrNsNameCache[nsName] = attr
                return attr
            }
        }
        return nil
    }

    @inlinable func _attribute(where body: (AttributeNode) throws -> Bool) rethrows -> AttributeNodeImpl? {
        for attr in _attrs { if try body(attr) { return attr } }
        return nil
    }

    @inlinable func notifyAttributeListeners() {
        NotificationCenter.default.post(name: DOMNamedNodeMapDidChange, object: self)
    }
}
