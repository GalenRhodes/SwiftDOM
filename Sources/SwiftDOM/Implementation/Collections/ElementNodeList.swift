/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: ElementNodeList.swift
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

open class ElementNodeList: LiveNodeList<ElementNode> {
    var nodeName:     String? = nil
    var localName:    String? = nil
    var namespaceURI: String? = nil

    public init(_ parent: ParentNode, nodeName: String) {
        super.init(parent)
        self.nodeName = nodeName
        handleCollectionDidChange(parent)
    }

    public init(_ parent: ParentNode, namespaceURI: String, localName: String) {
        super.init(parent)
        self.namespaceURI = namespaceURI
        self.localName = localName
        handleCollectionDidChange(parent)
    }

    open override func handleCollectionDidChange(_ parent: ParentNode) {
        _nodes.removeAll()
        if let name: String = nodeName {
            find(in: parent) { (node: ElementNodeImpl) in ((name == "*") || (name == node.nodeName)) }
        }
        else if let lName: String = localName, let uri: String = namespaceURI {
            find(in: parent) { (node: ElementNodeImpl) in ((lName == "*" || lName == node.localName) && (uri == "*" || uri == node.namespaceURI)) }
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

