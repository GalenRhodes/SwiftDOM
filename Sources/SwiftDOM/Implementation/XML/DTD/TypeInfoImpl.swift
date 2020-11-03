/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: TypeInfoImpl.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 11/3/20
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

public class TypeInfoImpl: TypeInfo, Hashable {
    public internal(set) var typeName:      String? = nil
    public internal(set) var typeNamespace: String? = nil

    public init(typeName: String?, typeNamespace: String?) {
        self.typeName = typeName
        self.typeNamespace = typeNamespace
    }

    public func isDerivedFrom(typeNamespace: String, typeName: String, derivation: [TypeDerivation]) -> Bool { ((self.typeNamespace == typeNamespace) && (self.typeName == typeName)) }

    public func isEqualTo(_ other: TypeInfo) -> Bool { self === other }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(typeName)
        hasher.combine(typeNamespace)
    }

    public static func == (lhs: TypeInfoImpl, rhs: TypeInfoImpl) -> Bool { lhs.isEqualTo(rhs) }
}
