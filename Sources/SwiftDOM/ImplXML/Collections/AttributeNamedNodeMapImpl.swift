/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: AttributeNamedNodeMapImpl.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/25/20
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

open class AttributeNamedNodeMapImpl<Element>: LiveNamedNodeMap<Element> {

    open override var startIndex: Index { _element._attributes.startIndex }
    open override var endIndex:   Index { _element._attributes.endIndex }
    open override var count:      Int { _element._attributes.count }

    var _element: ElementNodeImpl { (parent as! ElementNodeImpl) }

    init(_ elem: ElementNodeImpl) {
        super.init(parent: elem)
    }

    open override func mapAs<S>(_ transform: (Element) throws -> S) rethrows -> NamedNodeMap<S> {
        AttributeNamedNodeMapImpl<S>(_element)
    }

    open override func clone(parent p: NodeImpl, deep: Bool, postEvent: Bool) -> NamedNodeMap<Element> {
        AttributeNamedNodeMapImpl<Element>(_element)
    }
}

extension AttributeNamedNodeMapImpl where Element == AttributeNode {
    public subscript(nodeName: String) -> Element? { _element.attributeWith(name: nodeName) }

    public subscript(namespaceURI uri: String, localName lName: String) -> Element? { _element.attributeWith(namespaceURI: uri, name: lName) }

    public subscript(position: Index) -> Element { _element.attributes[position] }

    public subscript(bounds: Indices) -> ArraySlice<Element> { _element.attributes[bounds] }
}
