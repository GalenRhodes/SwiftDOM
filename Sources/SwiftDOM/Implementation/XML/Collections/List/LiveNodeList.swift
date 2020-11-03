/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: LiveNodeList.swift
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

public class LiveNodeList<Element>: NodeList<Element> {
//@f:0
    @usableFromInline          var nodes      : [Element] = []
    @usableFromInline          var parent     : Node
    @inlinable public override var startIndex : Int  { nodes.startIndex }
    @inlinable public override var endIndex   : Int  { nodes.endIndex   }
//@f:1

    public init(parent: Node) {
        self.parent = parent
        super.init()
        NotificationCenter.default.addObserver(forName: DOMNodeListDidChange, object: parent, queue: nil) {
            [weak self] (n: Notification) in
            if let s = self, let o = n.object, let p = (o as? Node), p.isSameNode(as: s.parent) { s.handleDomNodeListDidChange() }
        }
    }

    // Probably not necessary but I'll do it anyways.
    deinit { NotificationCenter.default.removeObserver(self) }

    /*===========================================================================================================================*/
    /// Default behavior is to simply load the parent's child nodes.
    ///
    public func handleDomNodeListDidChange() {
        var t: [Element] = []
        parent.forEachChild { node in if let e = (node as? Element) { t.append(e) } }
        nodes = t
    }

    @inlinable public override subscript(bounds: Range<Int>) -> ArraySlice<Element> { nodes[bounds] }
    @inlinable public override subscript(position: Int) -> Element { nodes[position] }
}
