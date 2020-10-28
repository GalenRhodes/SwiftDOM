/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: ElementNodeListImpl.swift
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

open class ElementNodeListImpl: LiveNodeList<ElementNode> {
    let nodeName:     String?
    let localName:    String?
    let namespaceURI: String?
    let elemId:       String?

    init(_ parent: ParentNode, nodeName name: String) {
        nodeName = name
        localName = nil
        namespaceURI = nil
        elemId = nil
        super.init(parent)
        handleCollectionDidChange()
    }

    init(_ parent: ParentNode, namespaceURI uri: String, localName name: String) {
        namespaceURI = uri
        localName = name
        nodeName = nil
        elemId = nil
        super.init(parent)
        handleCollectionDidChange()
    }

    public init(_ parent: ParentNode, elemId id: String) {
        localName = nil
        namespaceURI = nil
        nodeName = nil
        elemId = id
        super.init(parent)
        handleCollectionDidChange()
    }

    open override func clone(parent p: ParentNode, deep: Bool, postEvents: Bool) -> NodeList<ElementNode> {
        var clone: ElementNodeListImpl! = nil

        if let nn: String = nodeName { clone = ElementNodeListImpl(parent, nodeName: nn) }
        else if let id: String = elemId { clone = ElementNodeListImpl(parent, elemId: id) }
        else if let uri: String = namespaceURI, let ln: String = localName { clone = ElementNodeListImpl(parent, namespaceURI: uri, localName: ln) }
        else { fatalError("Unable to clone NodeList.") }

        clone.handleCollectionDidChange()
    }

    open override func handleCollectionDidChange() {
        _nodes.removeAll()
        if let name: String = nodeName {
            find(in: parent) { (node: ElementNodeImpl) in ((name == "*") || (name == node.nodeName)) }
        }
        else if let lName: String = localName, let uri: String = namespaceURI {
            find(in: parent) { (node: ElementNodeImpl) in ((lName == "*" || lName == node.localName) && (uri == "*" || uri == node.namespaceURI)) }
        }
        else if let elemId: String = elemId {
            find(in: parent) { (elem: ElementNodeImpl) in elem._attributes.contains { (attr: AttributeNodeImpl) in attr.isId && attr.value == elemId } }
        }
    }

    func find(in parent: ParentNode, with body: (ElementNodeImpl) -> Bool) {
        var _aNode: Node? = parent.firstChild
        while let aNode: Node = _aNode {
            if let elem: ElementNodeImpl = aNode as? ElementNodeImpl {
                if body(elem) { _nodes.append(elem) }
                find(in: elem, with: body)
            }
            _aNode = aNode.nextSibling
        }
    }
}

