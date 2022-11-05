// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef BASE_STRINGS_STRCAT_WIN_H_
#define BASE_STRINGS_STRCAT_WIN_H_

#include <initializer_list>
#include <string>

#include "base/base_export.h"
#include "base/containers/span.h"
#include "base/strings/string_piece.h"

namespace base {

// The following section contains overloads of the cross-platform APIs for
// std::wstring and base::WStringPiece.
BASE_EXPORT void StrAppend(std::wstring* dest, span<const WStringPiece> pieces);
BASE_EXPORT void StrAppend(std::wstring* dest, span<const std::wstring> pieces);

inline void StrAppend(std::wstring* dest,
                      std::initializer_list<WStringPiece> pieces) {
  StrAppend(dest, make_span(pieces));
}

// FIXME: Currently, Android RISCV64 only supports clang version 12.0.x.
//        Seems combining the C++11 alignas specifier and the GNU __attribute__ specifier are not supported.
// Ref: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=69585#c5
// [[nodiscard]] BASE_EXPORT std::wstring StrCat(span<const WStringPiece> pieces);
// [[nodiscard]] BASE_EXPORT std::wstring StrCat(span<const std::wstring> pieces);
__attribute__((warn_unused_result)) BASE_EXPORT std::wstring StrCat(span<const WStringPiece> pieces);
__attribute__((warn_unused_result)) BASE_EXPORT std::wstring StrCat(span<const std::wstring> pieces);

inline std::wstring StrCat(std::initializer_list<WStringPiece> pieces) {
  return StrCat(make_span(pieces));
}

}  // namespace base

#endif  // BASE_STRINGS_STRCAT_WIN_H_
