import React, {Component} from 'react';
import {
    View,
    NativeModules,
    ViewProps, ViewPropTypes,
} from 'react-native';


const NativeTRTC = NativeModules.RCTTRTC;

class TRTC extends Component<Props>{


    static propTypes = {
        style: ViewPropTypes.style
    };

    /**
     * 主播或者观众加入聊天室
     * @param sdkAppId
     * @param userId
     * @param userSig
     * @param roomId
     * @param role  0为主播 1为观众
     * @returns {Promise<*>}
     */
    enterRoom(sdkAppId: number, userId: string, userSig: string, roomId: number, role: number) : Promise<any> {
        return NativeTRTC.enterRoom(sdkAppId, userId, userSig, roomId, role);
    }

    /**
     * 退出聊天室
     */
    exitRoom(){
        NativeTRTC.exitRoom();
    }


    /**
     * 开启预览摄像头画面和麦克风采集
     * @param frontCamera 相机是否前置
     * @param fitMode 视频显示模式为 Fill 或 Fit 模式  0位fit模式 1位fill模式
     */
    startLocal(frontCamera: boolean, fitMode: number){
        NativeTRTC.startLocal(frontCamera, fitMode, this.root)
    }


    /**
     * 关闭本地预览
     */
    stopLocal(){
        NativeTRTC.stopLocal()
    }

    /**
     * 主播开关隐私模式屏蔽本地的音视频采集
     */
    muteLocal(){
        NativeTRTC.muteLocal();
    }


    /**
     * 开启预览摄像头画面和麦克风采集
     * @param userId
     * @param fitMode
     */
    startRemote(userId: string, fitMode: number){
        NativeTRTC.startRemote(userId, fitMode, this.root)
    }

    /**
     * 关闭主播视频
     */
    stopRemote(userId: string){
        NativeTRTC.stopRemote(userId);
    }



    onRef = (ref) => {
        this.root = ref;
    };


    render(){
        return(
            <View
                ref={this.onRef}
                style={this.props.style}/>
        )
    }
}

export default TRTC;
