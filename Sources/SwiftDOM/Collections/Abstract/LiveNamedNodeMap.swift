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

open class LiveNamedNodeMap<T>: NamedNodeMap<T> {

    open let parent: ParentNode

    open init(parent p: ParentNode) {
        parent = p
        super.init()
        NotificationCenter.default.addObserver(forName: DOMAttributeListDidChange, object: parent, queue: nil) {
            [weak self] (note: Notification) in
            if let s: LiveNamedNodeMap<T> = self, let p: ParentNode = (note.object as? ParentNode), p === parent { attributeListDidChange() }
        }
    }

    open func attributeListDidChange() {}

    open func clone(parent p: ParentNode, deep: Bool, postEvent: Bool) -> NamedNodeMap<T> { fatalError("Unable to clone NamedNodeMap") }

    open override func clone(deep: Bool, postEvents: Bool) -> NamedNodeMap<T> { clone(parent: parent, deep: deep, postEvent: postEvents) }
}
