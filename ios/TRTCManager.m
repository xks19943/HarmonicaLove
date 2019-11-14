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




@implementation TRTCManager

static TRTCManager *_sharedInstance;
static TRTCCloud *trtcCloud;


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
  
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if(_sharedInstance == nil){
      NSLog(@"调用了这个方法111");
      _sharedInstance = [super allocWithZone:zone];
    }
    
    if(trtcCloud == nil){
      NSLog(@"调用了这个方法22");
      trtcCloud = [TRTCCloud sharedInstance];
      [trtcCloud setDelegate: _sharedInstance];
    }
    
  });
  
  return _sharedInstance;
  
}



RCT_EXPORT_MODULE()


/// 主播开启或者观众加入房间
/// @param sdkAppId sdkAppId
/// @param userId userId
/// @param userSig userSig
/// @param role  0为主播 1为观众
RCT_EXPORT_METHOD(enterRoom:(UInt32) sdkAppId
                  userId:(NSString *) userId
                  userSig:(NSString *) userSig
                  roomId:(UInt32) roomId
                  role:(NSInteger *) role){
  TRTCParams *params = [[TRTCParams alloc] init];
  params.sdkAppId    = sdkAppId;
  params.userId      = userId;
  params.userSig     = userSig;
  params.roomId      = roomId; //输入您想进入的房间
  if(role == 0){
     params.role     = TRTCRoleAnchor; //当前角色为主播
  } else {
    params.role      = TRTCRoleAudience;
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
                  fitMode:(NSNumber *) fitMode
                  reactTag:(NSNumber *) reactTag){
  [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
    UIView *view = viewRegistry[reactTag];
    if(fitMode == 0){
      [trtcCloud setLocalViewFillMode:TRTCVideoFillMode_Fit];
    } else {
      [trtcCloud setLocalViewFillMode:TRTCVideoFillMode_Fill];
    }
    [trtcCloud startLocalPreview:frontCamera view:view];
    [trtcCloud startLocalAudio];
  }];
}


/// 关闭本地视频和音频采集
RCT_EXPORT_METHOD(stopLocal){
  [trtcCloud stopLocalPreview];
  [trtcCloud stopLocalAudio];
}



/// 主播开关隐私模式屏蔽本地的音视频采集
RCT_EXPORT_METHOD(muteLocal){
  [trtcCloud muteLocalVideo:true];
  [trtcCloud muteLocalAudio:true];
}


/// 开启预览摄像头画面和麦克风采集
/// @param userId 
/// @param fitMode  视频显示模式为 Fill 或 Fit 模式  0位fit模式 1位fill模式
/// @param reactTag
RCT_EXPORT_METHOD(startRemote:(NSString *) userId
                  fitMode:(NSNumber *) fitMode
                  reactTag:(NSNumber *) reactTag){
  [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
    UIView *view = viewRegistry[reactTag];
    if(fitMode == 0){
      [trtcCloud setRemoteViewFillMode:userId mode:TRTCVideoFillMode_Fit];
    } else {
      [trtcCloud setRemoteViewFillMode:userId mode:TRTCVideoFillMode_Fill];
    }
    [trtcCloud startRemoteView:userId view:view];
  }];
}


/// 观众关闭主播的画面
RCT_EXPORT_METHOD(stopRemote:(NSString *) userId){
  [trtcCloud stopRemoteView:userId];
}




-(void)onError:(TXLiteAVError)errCode errMsg:(NSString *)errMsg extInfo:(NSDictionary *)extInfo {
  
}


- (void)onEnterRoom:(NSInteger)result {
  
}


//观众加入房间观看成功
- (void)onUserVideoAvailable:(NSString *)userId available:(BOOL)available {
  
}

@end
