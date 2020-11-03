/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: ElementNodeList.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/30/20
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

public class ElementNodeList: LiveNodeList<ElementNode> {
//@f:0
    @usableFromInline let nodeName     : String?
    @usableFromInline let localName    : String?
    @usableFromInline let namespaceURI : String?
    @usableFromInline var element      : ElementNode { if let e = (parent as? ElementNode) { return e } else { fatalError("Not element node.") }  }
//@f:1

    public init(parent: ElementNode, nodeName name: String?) {
        nodeName = name
        localName = nil
        namespaceURI = nil
        super.init(parent: parent)
    }

    public init(parent: ElementNode, namespaceURI uri: String?, localName name: String?) {
        localName = name
        namespaceURI = uri
        nodeName = nil
        super.init(parent: parent)
    }

    @inlinable public override func handleDomNodeListDidChange() {
        var list: [ElementNode] = []
        findElements(parent: element, nodeList: &list)
        nodes = list
    }

    @usableFromInline func findElements(parent: ElementNode, nodeList: inout [ElementNode]) {
        parent.forEachChild { node in
            if let elem = (node as? ElementNode) {
                if testElement(element: elem) { nodeList.append(elem) }
                findElements(parent: elem, nodeList: &nodeList)
            }
        }
    }

    @inlinable final func testElement(element: ElementNode) -> Bool {
        if let name = nodeName {
            return ((name == "*") || (element.nodeName == name))
        }
        else if let uri = namespaceURI, let name = localName {
            return ((uri == "*" || element.namespaceURI == uri) && (name == "*" || element.localName == name))
        }
        else {
            return false
        }
    }
}
