/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ParagraphStateData.h"

#include <react/components/text/conversions.h>
#include <react/debug/debugStringConvertibleUtils.h>

namespace facebook {
    namespace react {
        
        AttributedString ParagraphStateData::getAttributedString() const {
            return attributedString_;
        }
        
        void ParagraphStateData::setAttributedString(
                                                     AttributedString attributedString) {
            attributedString_ = attributedString;
        }
        
        SharedTextLayoutManager ParagraphStateData::getTextLayoutManager() const {
            return textLayoutManager_;
        }
        
        void ParagraphStateData::setTextLayoutManager(
                                                      SharedTextLayoutManager textLayoutManager) {
            textLayoutManager_ = textLayoutManager;
        }
        
#ifdef ANDROID
        
        folly::dynamic ParagraphLocalData::getDynamic() const {
            return toDynamic(*this);
        }
        
#endif
        
#pragma mark - DebugStringConvertible
        
#if RN_DEBUG_STRING_CONVERTIBLE
        std::string ParagraphLocalData::getDebugName() const {
            return "ParagraphLocalData";
        }
        
        SharedDebugStringConvertibleList ParagraphLocalData::getDebugProps() const {
            return {
                debugStringConvertibleItem("attributedString", attributedString_, "")};
        }
#endif
        
    } // namespace react
} // namespace facebook
