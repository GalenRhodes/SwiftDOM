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

@usableFromInline class AttributeNamedNodeMap: NamedNodeMap<AttributeNode> {

    @inlinable override var startIndex: Index { _attributes.startIndex }
    @inlinable override var endIndex:   Index { _attributes.endIndex }
    @inlinable override var count:      Int { _attributes.count }

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

    @inlinable override subscript(nodeName: String) -> Element? {
        for a: AttributeNode in _attributes { if a.nodeName == nodeName { return a } }
        return nil
    }

    @inlinable override subscript(name: String, namespaceURI: String) -> Element? {
        for a: AttributeNode in _attributes { if a.localName == name && a.namespaceURI == namespaceURI { return a } }
        return nil
    }

    @inlinable override subscript(position: Index) -> Element { _attributes[position] }

    @inlinable override subscript(bounds: Indices) -> ArraySlice<Element> { _attributes[bounds] }
}
