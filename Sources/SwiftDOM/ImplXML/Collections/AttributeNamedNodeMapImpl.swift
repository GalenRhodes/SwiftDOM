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

open class AttributeNamedNodeMapImpl<T>: LiveNamedNodeMap<T> {

    open override var startIndex: Index { _attributes.startIndex }
    open override var endIndex:   Index { _attributes.endIndex }
    open override var count:      Int { _attributes.count }

    var _attributes: [Element] = []

    init(_ elem: ElementNodeImpl) {
        super.init(parent: elem)
        nameNodeMapDidChange()
    }

    open override func mapAs<S>(_ transform: (T) throws -> S) rethrows -> NamedNodeMap<S> {
        AttributeNamedNodeMapImpl<S>(parent as! ElementNodeImpl)
    }

    open override func clone(parent p: NodeImpl, deep: Bool, postEvent: Bool) -> NamedNodeMap<T> {
        AttributeNamedNodeMapImpl<T>(parent as! ElementNodeImpl)
    }

    open override subscript(position: Index) -> Element { _attributes[position] }

    open override subscript(bounds: Indices) -> ArraySlice<Element> { _attributes[bounds] }
}
