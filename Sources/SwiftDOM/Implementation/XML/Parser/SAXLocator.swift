/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: SAXLocator.swift
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
import libxml2

public class SAXLocator {
    private let locator: xmlSAXLocatorPtr
    private let ctx:     UnsafeMutableRawPointer

    public var lineNumber:   Int { Int(locator.pointee.getLineNumber(ctx)) }
    public var columnNumber: Int { Int(locator.pointee.getColumnNumber(ctx)) }
    public var publicId:     String? { stringFromXStr(locator.pointee.getPublicId(ctx)) }
    public var systemId:     String? { stringFromXStr(locator.pointee.getSystemId(ctx)) }

    init(locator: xmlSAXLocatorPtr, ctx: UnsafeMutableRawPointer) {
        self.locator = locator
        self.ctx = ctx
    }
}
