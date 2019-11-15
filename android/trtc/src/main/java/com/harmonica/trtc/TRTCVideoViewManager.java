package com.harmonica.trtc;

import androidx.annotation.NonNull;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;

class TRTCVideoViewManager extends SimpleViewManager<RNTTRTCVideoView> {

    @NonNull
    @Override
    public String getName() {
        return "RNTTRTCVideoView";
    }

    @NonNull
    @Override
    protected RNTTRTCVideoView createViewInstance(@NonNull ThemedReactContext reactContext) {
        return new RNTTRTCVideoView(reactContext);
    }

}
