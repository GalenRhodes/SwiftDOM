/************************************************************************//**
 *     PROJECT: SwiftDOM
 *    FILENAME: DOMErrors.swift
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

public enum DOMError: Error {
    case DomstringSize(description: String)
    case HierarchyRequest(description: String)
    case IndexSize(description: String)
    case InuseAttribute(description: String)
    case InvalidAccess(description: String)
    case InvalidCharacter(description: String)
    case InvalidModification(description: String)
    case InvalidState(description: String)
    case Namespace(description: String)
    case NoDataAllowed(description: String)
    case NoModificationAllowed(description: String)
    case NotFound(description: String)
    case NotSupported(description: String)
    case Syntax(description: String)
    case TypeMismatch(description: String)
    case Validation(description: String)
    case WrongDocument(description: String)
}
