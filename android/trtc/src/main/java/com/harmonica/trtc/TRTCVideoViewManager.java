package com.harmonica.trtc;

import androidx.annotation.NonNull;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;

class TRTCVideoViewManager extends SimpleViewManager<RCTTRTCVideoView> {

    @NonNull
    @Override
    public String getName() {
        return "RCTTRTCVideoView";
    }

    @NonNull
    @Override
    protected RCTTRTCVideoView createViewInstance(@NonNull ThemedReactContext reactContext) {
        return new RCTTRTCVideoView(reactContext);
    }

}
