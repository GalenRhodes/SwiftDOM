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

open class AnyTypeInfo: TypeInfo, Hashable {
    var ti: TypeInfo

    public var typeName:      String? { ti.typeName }
    public var typeNamespace: String? { ti.typeNamespace }

    public init(_ typeInfo: TypeInfo) { ti = typeInfo }

    open func isDerivedFrom(typeNamespace: String, typeName: String, derivation: [TypeDerivation]) -> Bool {
        ti.isDerivedFrom(typeNamespace: typeNamespace, typeName: typeName, derivation: derivation)
    }

    open func hash(into hasher: inout Hasher) { ti.getHash(into: &hasher) }

    open func asHashable() -> AnyTypeInfo { self }

    open func isEqualTo(_ other: TypeInfo) -> Bool {
        guard let _other: AnyTypeInfo = (other as? AnyTypeInfo) else { return false }
        return ti.isEqualTo(_other.ti)
    }

    public static func == (lhs: AnyTypeInfo, rhs: AnyTypeInfo) -> Bool { lhs.ti.isEqualTo(rhs.ti) }
}

extension TypeInfo where Self: Hashable {
    public func asHashable() -> AnyTypeInfo { AnyTypeInfo(self) }

    public func getHash(into hasher: inout Hasher) { hash(into: &hasher) }
}

extension Array where Element: TypeInfo {
    public static func == (lhs: [TypeInfo], rhs: [TypeInfo]) -> Bool { lhs.map({ $0.asHashable() }) == rhs.map({ $0.asHashable() }) }
}

extension Dictionary where Value: TypeInfo {
    public static func == (lhs: [Key: TypeInfo], rhs: [Key: TypeInfo]) -> Bool { lhs.mapValues({ $0.asHashable() }) == rhs.mapValues({ $0.asHashable() }) }
}

extension Set where Element: TypeInfo {
    public static func == (lhs: Set<Element>, rhs: Set<Element>) -> Bool { lhs.map({ $0.asHashable() }) == rhs.map({ $0.asHashable() }) }
}
