package com.harmonica.trtc;

import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.uimanager.NativeViewHierarchyManager;
import com.facebook.react.uimanager.UIBlock;
import com.facebook.react.uimanager.UIManagerModule;
import com.tencent.liteav.TXLiteAVCode;
import com.tencent.trtc.TRTCCloud;
import com.tencent.trtc.TRTCCloudDef;
import com.tencent.trtc.TRTCCloudListener;

class TRTCModule extends ReactContextBaseJavaModule implements LifecycleEventListener {


    private TRTCCloud trtcCloud;
    private TRTCCloudDef.TRTCParams trtcParams;
    private Promise mLocalPromise;
    private Promise mRemotePromise;

    public TRTCModule(@NonNull ReactApplicationContext reactContext) {
        super(reactContext);
        reactContext.addLifecycleEventListener(this);

        trtcCloud = TRTCCloud.sharedInstance(reactContext.getApplicationContext());
        //监听相关的事件
        trtcCloud.setListener(new TRTCCloudListener() {
            @Override
            public void onError(int i, String s, Bundle bundle) {
                super.onError(i, s, bundle);
                if (i == TXLiteAVCode.ERR_ROOM_ENTER_FAIL) {

                    if(mLocalPromise!= null){
                        mLocalPromise.reject("ERR_ROOM_ENTER_FAIL", "ERR_ROOM_ENTER_FAIL" + s);
                        mLocalPromise = null;
                    }
                    if(mRemotePromise!= null){
                        mRemotePromise.reject("ERR_ROOM_ENTER_FAIL", "ERR_ROOM_ENTER_FAIL" + s);
                        mRemotePromise = null;
                    }
                }

            }

            @Override
            public void onEnterRoom(long l) {
                if(mLocalPromise != null){
                    mLocalPromise.resolve(true);
                    mLocalPromise = null;
                }
                if(mRemotePromise != null){
                    mRemotePromise.resolve(true);
                    mRemotePromise = null;
                }
            }

            @Override
            public void onUserVideoAvailable(String s, boolean b) {
                Log.i("onUserVideoAvailable","调用了这个方法" + s);
                if(mRemotePromise != null){
                    mRemotePromise.resolve(s);
                    mRemotePromise = null;
                }
            }

            @Override
            public void onExitRoom(int i) {
                if(mLocalPromise!= null){
                    mLocalPromise = null;
                }
                if(mRemotePromise!= null){
                    mRemotePromise = null;
                }
            }
        });
    }


    @NonNull
    @Override
    public String getName() {
        return "TRTCModule";
    }

    @Override
    public void onHostResume() {

    }

    @Override
    public void onHostPause() {

    }

    @Override
    public void onHostDestroy() {
        if (trtcCloud != null) {
            trtcCloud.setListener(null);
        }
        trtcCloud = null;
        TRTCCloud.destroySharedInstance();
    }

    /**
     *  主播开启或者观众加入房间
     * @param sdkAppId
     * @param userId
     * @param userSig
     * @param roomId
     * @param role 0为主播 1为观众
     */
    @ReactMethod
    public void enterRoom(int sdkAppId, String userId, String userSig, int roomId, int role, Promise promise){
        trtcParams = new TRTCCloudDef.TRTCParams();
        trtcParams.sdkAppId = sdkAppId;
        trtcParams.userId   = userId;
        trtcParams.userSig  = userSig;
        trtcParams.roomId   = roomId; //输入您想进入的房间
        if(role == 0){
            trtcParams.role = TRTCCloudDef.TRTCRoleAnchor; //当前角色为主播
            mLocalPromise = promise;
        } else {
            trtcParams.role = TRTCCloudDef.TRTCRoleAudience; //当前角色为用户
            mRemotePromise = promise;
        }
        trtcCloud.enterRoom(trtcParams, TRTCCloudDef.TRTC_APP_SCENE_LIVE);
    }


    /**
     * 退出房间
     */
    @ReactMethod
    public void exitRoom(){
        if(trtcCloud != null){
            trtcCloud.exitRoom();
        }
    }


    /**
     *  开启预览摄像头画面和麦克风采集
     * @param frontCamera  相机是否前置
     * @param fitMode fitMode 视频显示模式为 Fill 或 Fit 模式  0位fit模式 1位fill模式
     * @param viewTag
     * @param promise
     */
    @ReactMethod
    public void startLocal(final boolean frontCamera, final int fitMode, final int viewTag, final Promise promise) {
        Log.i("startLocal","调用了这个方法1");
        final ReactApplicationContext context = getReactApplicationContext();
        UIManagerModule uiManager = context.getNativeModule(UIManagerModule.class);
        uiManager.addUIBlock(new UIBlock() {
            @Override
            public void execute(NativeViewHierarchyManager nativeViewHierarchyManager) {
                Log.i("startLocal","调用了这个方法2");
                final RNTTRTCVideoView rnttrtcVideoView;
                try {
                    rnttrtcVideoView = (RNTTRTCVideoView) nativeViewHierarchyManager.resolveView(viewTag);
                    if(fitMode == 0){
                        trtcCloud.setLocalViewFillMode(TRTCCloudDef.TRTC_VIDEO_RENDER_MODE_FIT);
                    }else {
                        trtcCloud.setLocalViewFillMode(TRTCCloudDef.TRTC_VIDEO_RENDER_MODE_FILL);
                    }
                    trtcCloud.startLocalPreview(frontCamera, rnttrtcVideoView);
                    trtcCloud.startLocalAudio();
                    Log.i("startLocal","调用了这个方法3");
                    promise.resolve(true);
                } catch (Exception e) {
                    e.printStackTrace();
                    promise.reject("startLocal", "startLocal fail");
                }
            }
        });
    }


    /**
     * 关闭麦克风采集
     */
    @ReactMethod
    public void stopLocal(){
        trtcCloud.stopLocalPreview();
        trtcCloud.startLocalAudio();
    }


    /**
     * 主播开关隐私模式屏蔽本地的音视频采集
     */
    @ReactMethod
    public void muteLocal(){
        trtcCloud.muteLocalVideo(true);
        trtcCloud.muteLocalAudio(true);
    }


    /**
     * 观众查看主播的视频画面
     * @param userId
     * @param fitMode
     * @param viewTag
     * @param promise
     */
    @ReactMethod
    public void startRemote(final String userId, final int fitMode, final int viewTag, final Promise promise){
        final ReactApplicationContext context = getReactApplicationContext();
        UIManagerModule uiManager = context.getNativeModule(UIManagerModule.class);
        uiManager.addUIBlock(new UIBlock() {
            @Override
            public void execute(NativeViewHierarchyManager nativeViewHierarchyManager) {
                final RNTTRTCVideoView rnttrtcVideoView;
                try {
                    rnttrtcVideoView = (RNTTRTCVideoView) nativeViewHierarchyManager.resolveView(viewTag);
                    if(fitMode == 0){
                        trtcCloud.setRemoteViewFillMode(userId, TRTCCloudDef.TRTC_VIDEO_RENDER_MODE_FIT);
                    }else {
                        trtcCloud.setRemoteViewFillMode(userId, TRTCCloudDef.TRTC_VIDEO_RENDER_MODE_FILL);
                    }
                    trtcCloud.startRemoteView(userId, rnttrtcVideoView);
                    promise.resolve(true);
                } catch (Exception e) {
                    e.printStackTrace();
                    promise.reject("startRemote", "startRemote fail");
                }
            }
        });
    }


    /**
     * 观众关闭主播的画面
     * @param userId
     */
    @ReactMethod
    public void stopRemote(final String userId){
        trtcCloud.stopRemoteView(userId);
    }




}
