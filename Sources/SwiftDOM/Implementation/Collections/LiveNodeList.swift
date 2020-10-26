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

    open override var startIndex: Int { _nodes.startIndex }
    open override var endIndex:   Int { _nodes.endIndex }
    open override var count:      Int { _nodes.count }

    public init(_ parent: ParentNode) {
        super.init()
        NotificationCenter.default.addObserver(forName: DOMCollectionDidChange, object: parent, queue: nil) {
            [weak self] in
            if let s: LiveNodeList<T> = self, let p: ParentNode = ($0.object as? ParentNode) { s.handleCollectionDidChange(p) }
        }
    }

    open func handleCollectionDidChange(_ parent: ParentNode) {}

    open override subscript(bounds: Range<Int>) -> ArraySlice<T> { _nodes[bounds] }

    open override subscript(position: Int) -> T { _nodes[position] }

    public static func == (lhs: LiveNodeList<T>, rhs: LiveNodeList<T>) -> Bool { ((lhs === rhs) || (lhs.uuid == rhs.uuid)) }
}

extension LiveNodeList where T: Node {
    @inlinable public static func == (lhs: LiveNodeList<T>, rhs: LiveNodeList<T>) -> Bool { lhs._nodes.map({ $0.asHashable() }) == rhs._nodes.map({ $0.asHashable() }) }

    @inlinable public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
        hasher.combine(_nodes.map { $0.asHashable() })
    }
}
