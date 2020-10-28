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
import Rubicon

open class ElementNodeImpl: NamespaceNode, ElementNode {

    open var tagName: String { nodeName }

    public internal(set) var schemaTypeInfo: TypeInfo? = nil

    open override var attributes:    NamedNodeMap<AttributeNode> { AttributeNamedNodeMapImpl(self) }
    open override var nodeType:      NodeTypes { NodeTypes.ElementNode }
    open override var hasAttributes: Bool { !_attributes.isEmpty }

    var _attributes:    [AttributeNodeImpl]                   = []
    var _attrNameCache: [String: AttributeNodeImpl]           = [:]
    var _attrNSCache:   [String: [String: AttributeNodeImpl]] = [:]

    public override init(_ owningDocument: DocumentNodeImpl, namespaceURI uri: String, qualifiedName qName: String) {
        super.init(owningDocument, namespaceURI: uri, qualifiedName: qName)
    }

    public init(_ owningDocument: DocumentNodeImpl, tagName: String) {
        super.init(owningDocument, nodeName: tagName)
    }

    open func attributeValueWith(name: String) -> String? {
        _getAttribWith(name: name)?.value
    }

    open func attributeValueWith(namespaceURI uri: String, name: String) -> String? {
        _getAttribWith(namespaceURI: uri, localName: name)?.value
    }

    open func attributeWith(name: String) -> AttributeNode? {
        _getAttribWith(name: name)
    }

    open func attributeWith(namespaceURI uri: String, name: String) -> AttributeNode? {
        _getAttribWith(namespaceURI: uri, localName: name)
    }

    open func elementsBy(tagName: String) -> NodeList<ElementNode> {
        ElementNodeListImpl(self, nodeName: tagName)
    }

    open func elementsBy(namespaceURI uri: String, name: String) -> NodeList<ElementNode> {
        ElementNodeListImpl(self, namespaceURI: uri, localName: name)
    }

    open func hasAttributeWith(name: String) -> Bool {
        (_getAttribWith(name: name) != nil)
    }

    open func hasAttributeWith(namespaceURI uri: String, name: String) -> Bool {
        (_getAttribWith(namespaceURI: uri, localName: name) != nil)
    }

    @discardableResult open func removeAttributeWith(name: String) -> AttributeNode? {
        _remove(attributes: _attributes.removeAllGet { $0.name == name })
    }

    @discardableResult open func removeAttributeWith(namespaceURI uri: String, name: String) -> AttributeNode? {
        _remove(attributes: _attributes.removeAllGet { $0.namespaceURI == uri && $0.localName == name })
    }

    @discardableResult open func removeAttribute(attribute: AttributeNode) -> AttributeNode? {
        _remove(attributes: _attributes.removeAllGet { $0.isSameNode(as: attribute) })
    }

    open func setAttributeWith(name: String, value: String) {
        if let a: AttributeNodeImpl = _getAttribWith(name: name) { a.value = value }
        else { _addNewAttribute(name: name, value: value) }
        _notifyAttributeListeners()
    }

    open func setAttributeWith(namespaceURI uri: String, name: String, value: String) {
        if let a: AttributeNode = _getAttribWith(namespaceURI: uri, localName: name) { a.value = value }
        else { _addNewAttribute(namespaceURI: uri, localName: name, value: value) }
        _notifyAttributeListeners()
    }

    @discardableResult open func setAttribute(attribute: AttributeNode) -> AttributeNode? {
        _setAttribute(attribute: attribute) { $0.name == attribute.name }
    }

    @discardableResult open func setAttributeNS(attribute: AttributeNode) -> AttributeNode? {
        guard let uri: String = attribute.namespaceURI, let lName: String = attribute.localName else { fatalError("Attribute does not have a namespace.") }
        return _setAttribute(attribute: attribute) { $0.namespaceURI == uri && $0.localName == lName }
    }

    open func setIdAttributeWith(name: String, isId: Bool) {
        if let a: AttributeNodeImpl = _getAttribWith(name: name) {
            _setAttrAsId(attr: a)
            _notifyAttributeListeners()
        }
    }

    open func setIdAttributeWith(namespaceURI uri: String, name: String, isId: Bool) {
        if let a: AttributeNodeImpl = _getAttribWith(namespaceURI: uri, localName: name) {
            _setAttrAsId(attr: a)
            _notifyAttributeListeners()
        }
    }

    open func setIdAttribute(attribute: AttributeNode, isId: Bool) {
        if let a: AttributeNodeImpl = (attribute as? AttributeNodeImpl), (a.ownerElement?.isSameNode(as: self) ?? false), _attributes.contains(where: { $0.isSameNode(as: attribute) }) {
            _setAttrAsId(attr: a)
            _notifyAttributeListeners()
        }
        else {
            fatalError("Attribute is not owned by this element.")
        }
    }

    open func forEachAttribute(_ body: (AttributeNodeImpl) throws -> Bool) rethrows -> Bool {
        for a: AttributeNodeImpl in _attributes { if try body(a) { return true } }
        return false
    }

    open func attribute(where body: (AttributeNode) throws -> Bool) rethrows -> AttributeNode? {
        for a: AttributeNodeImpl in _attributes { if try body(a) { return a } }
        return nil
    }

    open override func baseClone(_ doc: DocumentNodeImpl, postEvent: Bool, deep: Bool) -> NodeImpl {
        let e: ElementNodeImpl = (hasNamespace ? ElementNodeImpl(doc, namespaceURI: namespaceURI, qualifiedName: tagName) : ElementNodeImpl(doc, tagName: tagName))
        forEachAttribute { e._attributes.append($0.cloneNode(doc, postEvent: postEvent, deep: true)) }
        if deep { forEachChild { e.append(child: $0.cloneNode(doc, postEvent: postEvent, deep: deep)) } }
        return e
    }

    func _attribute(where test: (AttributeNodeImpl) throws -> Bool) rethrows -> AttributeNodeImpl? {
        if let attrIdx: Int = try _indexOfAttribute(where: test) { return _attributes[attrIdx] }
        else { return nil }
    }

    func _indexOfAttribute(where test: (AttributeNodeImpl) throws -> Bool) rethrows -> Int? {
        try _attributes.firstIndex(where: { try test($0) })
    }

    func _addNewAttribute(name: String, value: String) {
        let a: AttributeNodeImpl = (owningDocument.createAttribute(name: name) as! AttributeNodeImpl)
        _addNewAttribute(attr: a, value: value)
    }

    func _addNewAttribute(namespaceURI uri: String, localName lName: String, value: String) {
        let a: AttributeNodeImpl = (owningDocument.createAttribute(namespaceURI: uri, name: lName) as! AttributeNodeImpl)
        _addNewAttribute(attr: a, value: value)
    }

    func _addNewAttribute(attr: AttributeNodeImpl, value: String) {
        attr.value = value
        _setAttrOwner(attr: attr, elem: self)
        _attributes.append(attr)
    }

    func _setAttribute(attribute: AttributeNode, where test: (AttributeNodeImpl) throws -> Bool) rethrows -> AttributeNodeImpl? {
        guard let attribute: AttributeNodeImpl = (attribute as? AttributeNodeImpl) else { fatalError("Invalid attribute class.") }
        guard attribute.ownerElement == nil || (attribute.ownerElement?.isSameNode(as: self) ?? false) else { fatalError("Attribute is already owned.") }

        var _oa: AttributeNodeImpl? = nil

        if attribute.ownerElement == nil {
            if let oaIdx: Int = try _attributes.firstIndex(where: { try test($0) }) {
                let oa: AttributeNodeImpl = _attributes[oaIdx]
                _attributes.remove(at: oaIdx)
                _setAttrOwner(attr: oa, elem: nil)
                _oa = oa
                _clearCaches()
                _notifyAttributeListeners()
            }

            _attributes.append(attribute)
            _setAttrOwner(attr: attribute, elem: self)
            _notifyAttributeListeners()
        }

        return _oa
    }

    func _setAttrAsId(attr: AttributeNodeImpl) {
        attr.isId = true
    }

    func _setAttrOwner(attr: AttributeNodeImpl, elem: ElementNode?) {
        attr.ownerElement = elem
    }

    func _notifyAttributeListeners() {
        NotificationCenter.default.post(name: DOMAttributeListDidChange, object: self)
    }

    func _remove(attributes list: [AttributeNodeImpl]) -> AttributeNodeImpl? {
        if list.count > 0 {
            for a: AttributeNodeImpl in list { _setAttrOwner(attr: a, elem: nil) }
            _clearCaches()
            _notifyAttributeListeners()
        }
        return list.first
    }

    func _clearCaches() {
        _attrNameCache.removeAll()
        _attrNSCache.removeAll()
    }

    func _getAttribWith(name: String) -> AttributeNodeImpl? {
        if let a: AttributeNodeImpl = _attrNameCache[name] { return a }
        if let a: AttributeNodeImpl = _attribute(where: { $0.name == name }) {
            _attrNameCache[name] = a
            return a
        }
        return nil
    }

    func _getAttribWith(namespaceURI uri: String, localName name: String) -> AttributeNodeImpl? {
        if let a: AttributeNodeImpl = _attrNSCache[uri]?[name] { return a }
        if let a: AttributeNodeImpl = _attribute(where: { $0.namespaceURI == uri && $0.localName == name }) {
            if var c1: [String: AttributeNodeImpl] = _attrNSCache[uri] { c1[name] = a }
            else { _attrNSCache[uri] = [ name: a ] }
            return a
        }
        return nil
    }

    public static func == (lhs: ElementNodeImpl, rhs: ElementNodeImpl) -> Bool { lhs === rhs }
}
