package com.harmonica.trtc;

import android.content.Context;
import android.util.AttributeSet;
import android.view.SurfaceView;

import com.tencent.rtmp.ui.TXCloudVideoView;

public class RNTTRTCVideoView extends TXCloudVideoView{
    public RNTTRTCVideoView(Context context) {
        super(context);
    }

    public RNTTRTCVideoView(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
    }

    public RNTTRTCVideoView(SurfaceView surfaceView) {
        super(surfaceView);
    }


    @Override
    public void requestLayout() {
        super.requestLayout();
        post(measureAndLayout);
    }


    /**
     * 重新刷新下布局
     */
    private final Runnable measureAndLayout = new Runnable() {
        @Override
        public void run() {
            measure(
                    MeasureSpec.makeMeasureSpec(getWidth(), MeasureSpec.EXACTLY),
                    MeasureSpec.makeMeasureSpec(getHeight(), MeasureSpec.EXACTLY));
            layout(getLeft(), getTop(), getRight(), getBottom());
        }
    };

}
