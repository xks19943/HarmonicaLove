import React, {Component} from 'react';
import {
    View,
    NativeModules,
    ViewPropTypes,
    Platform,
    findNodeHandle
} from 'react-native';

console.log(NativeModules, 'xxx');
const NativeTRTC = Platform.OS === 'ios' ?NativeModules.TRTCManager : null;


class TRTC extends Component<Props>{


    static propTypes = {
        style: ViewPropTypes.style
    };

    resolveFirstLayout: (layout: Object) => void;
    firstLayoutPromise = new Promise(resolve => {
        this.resolveFirstLayout = resolve;
    });

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
    startLocal(frontCamera, fitMode){

      this.firstLayoutPromise
        .then(() => {
          const node = findNodeHandle(this.root);
          NativeTRTC.startLocal(frontCamera, fitMode, node);
        }).then((e)=>{
            console.log(e, '---')
        })
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
        const node = findNodeHandle(this.root);
        NativeTRTC.startRemote(userId, fitMode, node)
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


    componentDidMount(){
        this.startLocal(true,0);
    }

    componentWillUnmount(){
        this.stopLocal();
    }


    render(){
        return(
            <View
                ref={this.onRef}
                style={this.props.style}/>
        )
    }
}

export default TRTC;
