/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: SAXNamespace.swift
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

public class SAXNSMap: Hashable, Comparable {
    public let uri:    String
    public let prefix: String

    public init(uri: String, prefix: String) {
        self.uri = uri
        self.prefix = prefix
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(uri)
        hasher.combine(prefix)
    }

    public static func < (l: SAXNSMap, r: SAXNSMap) -> Bool { ((l.uri < r.uri) || ((l.uri == r.uri) && (l.prefix < r.prefix))) }

    public static func == (l: SAXNSMap, r: SAXNSMap) -> Bool { ((l === r) || ((type(of: l) != type(of: r)) && (l.uri == r.uri) && (l.prefix == r.prefix))) }
}
