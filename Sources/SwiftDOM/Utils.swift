/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: Utils.swift
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

/*===============================================================================================================================*/
/// Notification name posted when the source for a live named node map is updated.
///
public let DOMNamedNodeMapDidChange: Notification.Name = Notification.Name("DOMNamedNodeMapDidChange")
/*===============================================================================================================================*/
/// Notification name posted when the source for a live node list is updated.
///
public let DOMNodeListDidChange:     Notification.Name = Notification.Name("DOMNodeListDidChange")

/*===============================================================================================================================*/
/// Check a node's type against a list of types.
/// 
/// - Parameters:
///   - node: the node.
///   - type: the types to check for.
/// - Returns: `true` if the node's type is one of those in the list provided. `false` otherwise.
///
public func nodeTypeIs(_ node: Node?, _ type: NodeTypes...) -> Bool {
    guard let node: Node = node else { return false }
    for t: NodeTypes in type { if node.nodeType == t { return true } }
    return false
}
