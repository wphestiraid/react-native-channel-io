//
//  RNChannelEventEmitter.m
//  RNExample
//
//  Created by Haeun Chung on 28/09/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "RNChannelEventEmitter.h"
#import "RNChannelIO.h"

@implementation RNChannelEventEmitter
{
  bool hasListeners;
}

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue {
  return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    ChannelIO.delegate = self;
  }
  return self;
}

- (void)dealloc
{
  ChannelIO.delegate = nil;
}

// Will be called when this module's first listener is added.
-(void)startObserving {
  hasListeners = YES;
}

// Will be called when this module's last listener is removed, or on dealloc.
-(void)stopObserving {
  hasListeners = NO;
}

- (NSArray<NSString *> *)supportedEvents {
  return @[
     ON_CHANGE_BADGE,
     ON_RECEIVE_PUSH,
     WILL_OPEN_MESSENGER,
     WILL_CLOSE_MESSENGER,
     ON_CLICK_CHAT_LINK
  ];
}

#pragma mark ChannelPluginDelegate

- (void)onChangeBadgeWithCount:(NSInteger)count {
  if (hasListeners) {
    [self sendEventWithName:ON_CHANGE_BADGE body:@{@"count": @(count)}];
  }
}

- (void)onReceivePushWithEvent:(PushEvent *)event {
  if (hasListeners) {
    [self sendEventWithName:ON_RECEIVE_PUSH body:@{@"push": event}];
  }
}

- (BOOL)onClickChatLinkWithUrl:(NSURL *)url {
  if (hasListeners) {
    [self sendEventWithName:ON_CLICK_CHAT_LINK body:@{@"link": url}];
    return false;
  }
  return true;
}

- (void)willOpenMessenger {
  if (hasListeners) {
    [self sendEventWithName:WILL_OPEN_MESSENGER body:nil];
  }
}

- (void)willCloseMessenger {
  if (hasListeners) {
    [self sendEventWithName:WILL_CLOSE_MESSENGER body:nil];
  }
}

@end