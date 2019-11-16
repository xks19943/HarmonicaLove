//
//  TRTCManager.h
//  HarmonicaLove
//
//  Created by 明明 on 2019/11/9.
//  Copyright © 2019 Facebook. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <TXLiteAVSDK_TRTC/TRTCCloudDelegate.h>

@interface TRTCManager : NSObject <RCTBridgeModule,TRTCCloudDelegate>

@property(nonatomic, copy) RCTPromiseResolveBlock mLocalResover;
@property(nonatomic, copy) RCTPromiseRejectBlock mLocalRejecter;


@property(nonatomic, copy) RCTPromiseResolveBlock mRemoteResover;
@property(nonatomic, copy) RCTPromiseRejectBlock mRemoteRejecter;

@end

