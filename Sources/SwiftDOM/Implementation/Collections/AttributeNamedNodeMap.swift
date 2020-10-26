/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: AttributeNamedNodeMap.swift
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

open class AttributeNamedNodeMap: NamedNodeMap<AttributeNode> {

    @inlinable open override var startIndex: Index { _attributes.startIndex }
    @inlinable open override var endIndex:   Index { _attributes.endIndex }
    @inlinable open override var count:      Int { _attributes.count }

    @usableFromInline var _attributes: [Element] = []

    @usableFromInline init(_ elem: ElementNode) {
        super.init()
        NotificationCenter.default.addObserver(forName: DOMAttributeListDidChange, object: elem, queue: nil) {
            [weak self] in
            if let s: AttributeNamedNodeMap = self, let e: ElementNodeImpl = $0.object as? ElementNodeImpl {
                s._attributes.removeAll()
                for a: AttributeNode in e._attributes { s._attributes.append(a) }
            }
        }
    }

    @inlinable open override subscript(nodeName: String) -> Element? { first { $0.nodeName == nodeName } }

    @inlinable open override subscript(namespaceURI uri: String, localName lName: String) -> Element? { first { $0.namespaceURI == uri && $0.localName == lName } }

    @inlinable open override subscript(position: Index) -> Element { _attributes[position] }

    @inlinable open override subscript(bounds: Indices) -> ArraySlice<Element> { _attributes[bounds] }
}