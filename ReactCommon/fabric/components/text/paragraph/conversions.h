// Copyright (c) Facebook, Inc. and its affiliates.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

#include <folly/dynamic.h>
#include <react/attributedstring/conversions.h>
#include <react/components/text/ParagraphStateData.h>

namespace facebook {
namespace react {

#ifdef ANDROID

inline folly::dynamic toDynamic(const ParagraphStateData &paragraphStateData) {
  folly::dynamic newLocalData = folly::dynamic::object();
  newLocalData["attributedString"] =
      toDynamic(paragraphStateData.getAttributedString());
  newLocalData["hash"] = newLocalData["attributedString"]["hash"];
  return newLocalData;
}

#endif

} // namespace react
} // namespace facebook
