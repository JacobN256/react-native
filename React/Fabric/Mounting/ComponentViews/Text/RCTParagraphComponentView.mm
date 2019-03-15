/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "RCTParagraphComponentView.h"

#import <react/components/text/ParagraphStateData.h>
#import <react/components/text/ParagraphProps.h>
#import <react/components/text/ParagraphShadowNode.h>
#import <react/core/LocalData.h>
#import <react/core/State.h>
#import <react/graphics/Geometry.h>
#import <react/textlayoutmanager/RCTTextLayoutManager.h>
#import <react/textlayoutmanager/TextLayoutManager.h>
#import "RCTConversions.h"

using namespace facebook::react;

@implementation RCTParagraphComponentView {
  SharedParagraphStateData _paragraphStateData;
  ParagraphAttributes _paragraphAttributes;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const ParagraphProps>();
    _props = defaultProps;

    self.isAccessibilityElement = YES;
    self.accessibilityTraits |= UIAccessibilityTraitStaticText;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
  }

  return self;
}

#pragma mark - RCTComponentViewProtocol

+ (ComponentHandle)componentHandle
{
  return ParagraphShadowNode::Handle();
}

- (void)updateProps:(SharedProps)props oldProps:(SharedProps)oldProps
{
  const auto &paragraphProps = std::static_pointer_cast<const ParagraphProps>(props);

  [super updateProps:props oldProps:oldProps];

  assert(paragraphProps);
  _paragraphAttributes = paragraphProps->paragraphAttributes;
}

- (void)updateState:(facebook::react::State::Shared)state oldState:(facebook::react::State::Shared)oldState
{
  auto localState = std::static_pointer_cast<const ConcreteState<ParagraphStateData>>(state);
  _paragraphStateData = std::make_shared<const ParagraphStateData>(localState->getData());
  assert(_paragraphStateData);
  [self setNeedsDisplay];
}

- (void)prepareForRecycle
{
  [super prepareForRecycle];
  _paragraphStateData.reset();
}

- (void)drawRect:(CGRect)rect
{
  if (!_paragraphStateData) {
    return;
  }

  SharedTextLayoutManager textLayoutManager = _paragraphStateData->getTextLayoutManager();
  RCTTextLayoutManager *nativeTextLayoutManager =
      (__bridge RCTTextLayoutManager *)textLayoutManager->getNativeTextLayoutManager();

  CGRect frame = RCTCGRectFromRect(_layoutMetrics.getContentFrame());

  [nativeTextLayoutManager drawAttributedString:_paragraphStateData->getAttributedString()
                            paragraphAttributes:_paragraphAttributes
                                          frame:frame];
}

#pragma mark - Accessibility

- (NSString *)accessibilityLabel
{
  NSString *superAccessibilityLabel = RCTNSStringFromStringNilIfEmpty(_props->accessibilityLabel);
  if (superAccessibilityLabel) {
    return superAccessibilityLabel;
  }

  if (!_paragraphStateData) {
    return nil;
  }

  return RCTNSStringFromString(_paragraphStateData->getAttributedString().getString());
}

- (SharedTouchEventEmitter)touchEventEmitterAtPoint:(CGPoint)point
{
  if (!_paragraphStateData) {
    return _eventEmitter;
  }

  SharedTextLayoutManager textLayoutManager = _paragraphStateData->getTextLayoutManager();
  RCTTextLayoutManager *nativeTextLayoutManager =
      (__bridge RCTTextLayoutManager *)textLayoutManager->getNativeTextLayoutManager();
  CGRect frame = RCTCGRectFromRect(_layoutMetrics.getContentFrame());

  SharedEventEmitter eventEmitter =
      [nativeTextLayoutManager getEventEmitterWithAttributeString:_paragraphStateData->getAttributedString()
                                              paragraphAttributes:_paragraphAttributes
                                                            frame:frame
                                                          atPoint:point];

  if (!eventEmitter) {
    return _eventEmitter;
  }

  assert(std::dynamic_pointer_cast<const TouchEventEmitter>(eventEmitter));
  return std::static_pointer_cast<const TouchEventEmitter>(eventEmitter);
}

@end
