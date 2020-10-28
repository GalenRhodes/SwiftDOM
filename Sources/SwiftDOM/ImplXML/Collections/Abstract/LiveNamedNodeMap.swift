/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: LiveNamedNodeMap.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/28/20
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

open class LiveNamedNodeMap<Element>: NamedNodeMap<Element> {

    public let parent: NodeImpl

    public init(parent p: NodeImpl) {
        parent = p
        super.init()
        NotificationCenter.default.addObserver(forName: DOMNamedNodeMapDidChange, object: parent, queue: nil) {
            [weak self] (note: Notification) in
            if let s: LiveNamedNodeMap<Element> = self, let p: ParentNode = (note.object as? ParentNode), p === s.parent { s.nameNodeMapDidChange() }
        }
        nameNodeMapDidChange()
    }

    open func nameNodeMapDidChange() {}

    open func clone(parent p: NodeImpl, deep: Bool, postEvent: Bool) -> NamedNodeMap<Element> { fatalError("Unable to clone NamedNodeMap") }

    open override func clone(deep: Bool, postEvents: Bool) -> NamedNodeMap<Element> { clone(parent: parent, deep: deep, postEvent: postEvents) }

    open override func mapAs<S>(_ transform: (Element) throws -> S) rethrows -> NamedNodeMap<S> { LiveNamedNodeMap<S>(parent: parent) }
}
