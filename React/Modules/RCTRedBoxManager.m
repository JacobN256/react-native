//
//  RCTRedBoxManager.m
//  React
//
//  Created by Eric Lewis on 2/20/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "RCTRedBoxManager.h"

@implementation RCTRedBoxManager

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"collectRedBoxExtraData"];
}

- (void)collectRedBoxExtraData
{
  [self sendEventWithName:@"collectRedBoxExtraData" body:nil];
}

@end
