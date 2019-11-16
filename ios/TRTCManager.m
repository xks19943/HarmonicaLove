//
//  TRTCManager.m
//  HarmonicaLove
//
//  Created by 明明 on 2019/11/9.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "TRTCManager.h"
#import <TXLiteAVSDK_TRTC/TRTCCloud.h>
#import <React/RCTUIManager.h>
#if __has_include(<React/RCTUIManagerUtils.h>)
#import <React/RCTUIManagerUtils.h>
#endif
#import <React/RCTBridge.h>
#import "TRTCVideoView.h"




@implementation TRTCManager

static TRTCCloud *trtcCloud;


- (instancetype)init
{
  self = [super init];
  NSLog(@"调用了这个构造方法1");
  if (self) {
    NSLog(@"调用了这个构造方法2");
    trtcCloud = [TRTCCloud sharedInstance];
    [trtcCloud setDelegate: self];
  }
  return self;
}

-(void)dealloc{
  if(trtcCloud){
    [trtcCloud exitRoom];
  }
  [TRTCCloud destroySharedIntance];
}

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue
{
  return RCTGetUIManagerQueue();
}


RCT_EXPORT_MODULE()


/// 主播开启或者观众加入房间
/// @param sdkAppId sdkAppId
/// @param userId userId
/// @param userSig userSig
/// @param role  0为主播 1为观众
RCT_EXPORT_METHOD(enterRoom:(nonnull NSNumber *) sdkAppId
                  userId:(NSString *) userId
                  userSig:(NSString *) userSig
                  roomId:(nonnull NSNumber *) roomId
                  role:(NSInteger *) role
                  rosolver: (RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
  NSLog(@"调用了这个方法___1");
  TRTCParams *params = [[TRTCParams alloc] init];
  params.sdkAppId    = sdkAppId;
  params.userId      = userId;
  params.userSig     = userSig;
  params.roomId      = roomId; //输入您想进入的房间
  if(role == 0){
     params.role     = TRTCRoleAnchor; //当前角色为主播
    self.mLocalResover = resolve;
    self.mLocalRejecter = reject;
    NSLog(@"调用了这个方法___2");
  } else {
    params.role      = TRTCRoleAudience;
    self.mRemoteResover = resolve;
    self.mRemoteRejecter = reject;
    NSLog(@"调用了这个方法___3");
  }
  [trtcCloud enterRoom:params appScene:TRTCAppSceneLIVE];
}


/// 主播或者主播退出房间
RCT_EXPORT_METHOD(exitRoom){
  if(trtcCloud != nil){
    [trtcCloud exitRoom];
  }
}



/// 开启预览摄像头画面和麦克风采集
/// @param frontCamera  相机是否前置
/// @param fitMode  视频显示模式为 Fill 或 Fit 模式  0位fit模式 1位fill模式
/// @param reactTag
RCT_EXPORT_METHOD(startLocal:(BOOL) frontCamera
                  fitMode:(nonnull NSNumber *) fitMode
                  reactTag:(nonnull NSNumber *) reactTag
                  rosolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
  NSLog(@"调用了这个方法___1");
  [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
    NSLog(@"调用了这个方法___2");
    
    
    TRTCVideoView *view = viewRegistry[reactTag];
    NSLog(@"调用了这个方法___3");
    if (![view isKindOfClass:[TRTCVideoView class]]){
      NSLog(@"调用了这个方法___4");
      reject(@"startLocal",@"startLocal fail", nil);
      return;
    }
    
    NSLog(@"调用了这个方法___5");
    
    if(fitMode == 0){
      [trtcCloud setLocalViewFillMode:TRTCVideoFillMode_Fit];
    } else {
      [trtcCloud setLocalViewFillMode:TRTCVideoFillMode_Fill];
    }
    [trtcCloud startLocalPreview:frontCamera view:view];
    [trtcCloud startLocalAudio];
    resolve(@"success");
  }];
  
}


/// 关闭本地视频和音频采集
RCT_EXPORT_METHOD(stopLocal){
  if(trtcCloud != nil) {
    [trtcCloud stopLocalPreview];
    [trtcCloud stopLocalAudio];
  }
}



/// 主播开关隐私模式屏蔽本地的音视频采集
RCT_EXPORT_METHOD(muteLocal){
  if(trtcCloud != nil) {
    [trtcCloud muteLocalVideo:true];
    [trtcCloud muteLocalAudio:true];
  }
}


/// 开启预览摄像头画面和麦克风采集
/// @param userId 
/// @param fitMode  视频显示模式为 Fill 或 Fit 模式  0位fit模式 1位fill模式
/// @param reactTag
RCT_EXPORT_METHOD(startRemote:(NSString *) userId
                  fitMode:(nonnull NSNumber *) fitMode
                  reactTag:(nonnull NSNumber *) reactTag
                  rosolver:(RCTPromiseResolveBlock) resolve
                  rejecter:(RCTPromiseRejectBlock) reject){
  [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
    NSLog(@"startRemote 调用了这个方法___1");
    TRTCVideoView *view = viewRegistry[reactTag];
    if (![view isKindOfClass:[TRTCVideoView class]]){
      reject(@"startRemote",@"startRemote fail", nil);
      return;
    }
    
    NSLog(@"startRemote 调用了这个方法___1");
    if(fitMode == 0){
      [trtcCloud setRemoteViewFillMode:userId mode:TRTCVideoFillMode_Fit];
    } else {
      [trtcCloud setRemoteViewFillMode:userId mode:TRTCVideoFillMode_Fill];
    }
    [trtcCloud startRemoteView:userId view:view];
    NSLog(@"startRemote 调用了这个方法___3");
    resolve(@"success");
  }];
}


/// 观众关闭主播的画面
RCT_EXPORT_METHOD(stopRemote:(NSString *) userId){
  [trtcCloud stopRemoteView:userId];
}




-(void)onError:(TXLiteAVError)errCode errMsg:(NSString *)errMsg extInfo:(NSDictionary *)extInfo {
  if (errCode == ERR_ROOM_ENTER_FAIL) {
      if(trtcCloud != nil){
        [trtcCloud exitRoom];
      }
      NSLog(@"加入房间失败");
      if(self.mLocalRejecter != nil){
        self.mLocalRejecter(@"onError",errMsg, nil);
        self.mLocalResover = nil;
        self.mLocalRejecter = nil;
      }
      
      if(self.mRemoteRejecter != nil){
        self.mRemoteRejecter(@"onError",errMsg, nil);
        self.mRemoteResover = nil;
        self.mRemoteRejecter = nil;
      }
      return;
  }
}

//加入房间成功
- (void)onEnterRoom:(NSInteger)result {
  NSLog(@"加入房间成功");
  if(self.mLocalResover != nil){
    self.mLocalResover(@"success");
    self.mLocalResover = nil;
    self.mLocalRejecter = nil;
  }
  
  if(self.mRemoteResover != nil){
    self.mRemoteResover(@"success");
    self.mRemoteResover = nil;
    self.mRemoteRejecter = nil;
  }
  
}


//观众加入房间并且主播在线
- (void)onUserVideoAvailable:(NSString *)userId available:(BOOL)available {
  NSLog(@"onUserVideoAvailable主播在线：@%s", userId);
  
  if(self.mRemoteResover != nil){
    self.mRemoteResover(@"success");
    self.mRemoteResover = nil;
    self.mRemoteRejecter = nil;
  }
}

@end
