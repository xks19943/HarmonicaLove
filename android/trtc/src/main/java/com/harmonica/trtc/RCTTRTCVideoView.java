package com.harmonica.trtc;

import android.content.Context;
import android.util.AttributeSet;
import android.view.SurfaceView;

import com.tencent.rtmp.ui.TXCloudVideoView;

public class RCTTRTCVideoView extends TXCloudVideoView{
    public RCTTRTCVideoView(Context context) {
        super(context);
    }

    public RCTTRTCVideoView(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
    }

    public RCTTRTCVideoView(SurfaceView surfaceView) {
        super(surfaceView);
    }
}
