/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: TypeInfo.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/19/20
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

public protocol TypeInfo: AnyObject {
    var typeName:      String? { get }
    var typeNamespace: String? { get }

    func isDerivedFrom(typeNamespace: String, typeName: String, derivation: [TypeDerivation]) -> Bool

    func isEqualTo(_ other: TypeInfo) -> Bool

    func asHashable() -> AnyTypeInfo

    func getHash(into hasher: inout Hasher)
}

public class AnyTypeInfo: TypeInfo, Hashable {
    @usableFromInline var info: TypeInfo

    public var typeName:      String? { info.typeName }
    public var typeNamespace: String? { info.typeNamespace }

    public init(_ info: TypeInfo) { self.info = info }

    @inlinable public func hash(into hasher: inout Hasher) { info.getHash(into: &hasher) }

    @inlinable public static func == (lhs: AnyTypeInfo, rhs: AnyTypeInfo) -> Bool { lhs.info.isEqualTo(rhs.info) }

    @inlinable public func asHashable() -> AnyTypeInfo { self }

    @inlinable public func isEqualTo(_ other: TypeInfo) -> Bool { info.isEqualTo(other) }

    public func isDerivedFrom(typeNamespace ns: String, typeName n: String, derivation d: [TypeDerivation]) -> Bool { info.isDerivedFrom(typeNamespace: ns, typeName: n, derivation: d) }
}

extension TypeInfo where Self: Hashable {
    @inlinable public func asHashable() -> AnyTypeInfo { AnyTypeInfo(self) }

    @inlinable public func getHash(into hasher: inout Hasher) { hash(into: &hasher) }
}

extension Array where Element: TypeInfo {
    @inlinable public static func == (lhs: [TypeInfo], rhs: [TypeInfo]) -> Bool { lhs.map({ $0.asHashable() }) == rhs.map({ $0.asHashable() }) }
}

