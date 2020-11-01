/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: LiveNamedNodeMap.swift
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

public class ElementAttributeMap: NamedNodeMap<AttributeNode> {
    @inlinable public override var startIndex: Int { element.attributes.startIndex }
    @inlinable public override var endIndex:   Int { element.attributes.endIndex }

    @usableFromInline var element: ElementNode

    public init(element: ElementNode) {
        self.element = element
        super.init()
    }

    @inlinable public override subscript(nodeName: String) -> AttributeNode? { element.attributes[nodeName] }
    @inlinable public override subscript(namespaceURI: String, localName: String) -> AttributeNode? { element.attributes[namespaceURI, localName] }
    @inlinable public override subscript(bounds: Range<Int>) -> ArraySlice<AttributeNode> { element.attributes[bounds] }
    @inlinable public override subscript(position: Int) -> AttributeNode { element.attributes[position] }
}
