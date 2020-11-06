/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: SAXAttribute.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 11/4/20
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

public class SAXAttribute: Hashable, Comparable {
//@f:0
    @usableFromInline let _name        : String
    public            let prefix       : String?
    public            let namespaceURI : String?
    public            let value        : String
    public            let isDefault    : Bool
    @inlinable public var localName    : String? { (e(namespaceURI) ? nil : _name)                                  }
    @inlinable public var name         : String  { ((e(namespaceURI) || e(prefix)) ? _name : "\(prefix!):\(_name)") }
//@f:1

    public init(name: String, value: String, isDefault: Bool = false) {
        _name = name
        prefix = nil
        namespaceURI = nil
        self.value = value
        self.isDefault = false
    }

    public init(localName: String, prefix: String?, namespaceURI: String?, value: String, isDefault: Bool = false) {
        _name = localName
        self.prefix = prefix
        self.namespaceURI = namespaceURI
        self.value = value
        self.isDefault = isDefault
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(localName)
        hasher.combine(prefix)
        hasher.combine(namespaceURI)
        hasher.combine(value)
    }

    @inlinable public static func == (l: SAXAttribute, r: SAXAttribute) -> Bool {
        [ l.name, l.namespaceURI, l.localName, l.prefix, l.value ] == [ r.name, r.namespaceURI, r.localName, r.prefix, r.value ]
    }

    @inlinable public static func < (l: SAXAttribute, r: SAXAttribute) -> Bool {
        [ l.name, l.namespaceURI, l.localName, l.prefix, l.value ] < [ r.name, r.namespaceURI, r.localName, r.prefix, r.value ]
    }
}
