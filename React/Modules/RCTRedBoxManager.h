//
//  RCTRedBoxManager.h
//  React
//
//  Created by Eric Lewis on 2/20/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <React/RCTEventEmitter.h>

@interface RCTRedBoxManager : RCTEventEmitter

- (void)collectRedBoxExtraData;

@end
