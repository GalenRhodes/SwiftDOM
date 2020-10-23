/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: LiveCollection.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/15/20
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

public let DOMCollectionDidChange: Notification.Name = Notification.Name("DOMCollectionDidChange")

public protocol LiveCollection {
    func domCollectionDidChange(_ node: Node)

    func isEqualTo(_ other: LiveCollection) -> Bool

    func asHashable() -> AnyLiveCollection

    func getHash(into hasher: inout Hasher)
}

@frozen public struct AnyLiveCollection: LiveCollection, Hashable {
    @usableFromInline var lc: LiveCollection

    public init(_ lc: LiveCollection) { self.lc = lc }

    @inlinable public func hash(into hasher: inout Hasher) { lc.getHash(into: &hasher) }

    @inlinable public static func == (lhs: AnyLiveCollection, rhs: AnyLiveCollection) -> Bool { lhs.lc.isEqualTo(rhs.lc) }

    @inlinable public func asHashable() -> AnyLiveCollection { self }

    @inlinable public func domCollectionDidChange(_ node: Node) { lc.domCollectionDidChange(node) }
}

extension LiveCollection where Self: Hashable {
    @inlinable public func isEqualTo(_ other: LiveCollection) -> Bool { guard let other: Self = (other as? Self) else { return false }; return (self == other) }

    @inlinable public func asHashable() -> AnyLiveCollection { AnyLiveCollection(self) }

    @inlinable public func getHash(into hasher: inout Hasher) { hash(into: &hasher) }
}

extension Array where Element: LiveCollection {
    @inlinable public static func == (lhs: [LiveCollection], rhs: [LiveCollection]) -> Bool { lhs.map({ $0.asHashable() }) == rhs.map({ $0.asHashable() }) }
}

extension Dictionary where Value: LiveCollection {
    @inlinable public static func == (lhs: [Key: LiveCollection], rhs: [Key: LiveCollection]) -> Bool { lhs.mapValues({ $0.asHashable() }) == rhs.mapValues({ $0.asHashable() }) }
}

extension Set where Element: LiveCollection {
    @inlinable public static func == (lhs: Set<Element>, rhs: Set<Element>) -> Bool { lhs.map({ $0.asHashable() }) == rhs.map({ $0.asHashable() }) }
}

