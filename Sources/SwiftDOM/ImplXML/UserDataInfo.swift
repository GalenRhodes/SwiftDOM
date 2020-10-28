/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: UserDataInfo.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/21/20
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

public struct UserDataInfo: Hashable {
    private let uuid: String = UUID().uuidString
    public let  data: Any
    public let  body: UserDataHandler?

    public init(data: Any, body: UserDataHandler?) {
        self.data = data
        self.body = body
    }

    public func hash(into hasher: inout Hasher) { hasher.combine(uuid) }

    public static func == (lhs: UserDataInfo, rhs: UserDataInfo) -> Bool { lhs.uuid == rhs.uuid }
}
