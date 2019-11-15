//
//  TRTCVideoViewManager.m
//  HarmonicaLove
//
//  Created by 明明 on 2019/11/9.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "TRTCVideoViewManager.h"
#import "TRTCVideoView.h"

@implementation TRTCVideoViewManager

RCT_EXPORT_MODULE(RNTTRTCVideoView)

- (UIView *)view
{
  return [[TRTCVideoView alloc] init];
}

@end
