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
//@f:0
    @inlinable public override var startIndex : Int             { element._attrs.startIndex }
    @inlinable public override var endIndex   : Int             { element._attrs.endIndex   }
    @inlinable public override var isEmpty    : Bool            { element._attrs.isEmpty    }
    @inlinable public override var count      : Int             { element._attrs.count      }
    @usableFromInline          var element    : ElementNodeImpl
//@f:1

    public init(element: ElementNodeImpl) {
        self.element = element
        super.init()
    }

    @inlinable public override subscript(nodeName: String) -> AttributeNode? {
        element._attributeWith(name: nodeName)
    }

    @inlinable public override subscript(namespaceURI: String, localName: String) -> AttributeNode? {
        element._attributeWith(namespaceURI: namespaceURI, name: localName)
    }

    @inlinable public override subscript(bounds: Range<Int>) -> ArraySlice<AttributeNode> {
        element._attrs.map({ (a: AttributeNodeImpl) -> AttributeNode in a })[bounds]
    }

    @inlinable public override subscript(position: Int) -> AttributeNode {
        element._attrs[position]
    }
}
