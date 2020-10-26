/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: LiveNodeList.swift
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

open class LiveNodeList<T>: NodeList<T> {
    @usableFromInline var _nodes: [T] = []

    @inlinable open override var startIndex: Int { _nodes.startIndex }
    @inlinable open override var endIndex:   Int { _nodes.endIndex }
    @inlinable open override var count:      Int { _nodes.count }

    @usableFromInline init(_ parent: ParentNode) {
        super.init()
        NotificationCenter.default.addObserver(forName: DOMCollectionDidChange, object: parent, queue: nil) {
            [weak self] in
            if let s: LiveNodeList<T> = self, let p: ParentNode = ($0.object as? ParentNode) { s.handleCollectionDidChange(p) }
        }
    }

    @inlinable open func handleCollectionDidChange(_ parent: ParentNode) {}

    @inlinable open override subscript(bounds: Range<Int>) -> ArraySlice<T> { _nodes[bounds] }

    @inlinable open override subscript(position: Int) -> T { _nodes[position] }
}
