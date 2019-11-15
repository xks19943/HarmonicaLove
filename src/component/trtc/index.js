import React, {Component} from 'react';
import {
    View,
    NativeModules,
    ViewPropTypes,
    Platform,
    findNodeHandle,
    requireNativeComponent
} from 'react-native';

console.log(NativeModules, 'xxx');
const NativeTRTC = Platform.OS === 'ios' ?NativeModules.TRTCManager : NativeModules.TRTCModule;
const TRTCVideoView = requireNativeComponent('RNTTRTCVideoView');


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
    startLocal(frontCamera: boolean, fitMode: number)  : Promise<any> {
        const node = findNodeHandle(this.root);
        return NativeTRTC.startLocal(frontCamera, fitMode, node);
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
    startRemote(userId: string, fitMode: number) : Promise<any> {
        const node = findNodeHandle(this.root);
        return NativeTRTC.startRemote(userId, fitMode, node);
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
        let role = this.props.role;
        let sdkAppId = 1400192037;
        let userId = "11011";
        let userSig = "f068173020dd1ca204718567f841455c644879bbd78c776da58a77dac2a054d2";
        let roomId = 110;
        console.log(role);
        if(role === 0){
            this.enterRoom(sdkAppId,userId,userSig,roomId,role).then((isSuccess)=>{
                console.log(isSuccess,'ccc');
                this.startLocal(true, 0).then((res)=>{
                    console.log(res, '---');
                }).catch((e)=>{
                    console.log(e, 'xxx');
                });
            }).catch((e)=>{
                console.log(e,'ooo');
            });
        } else {
            this.enterRoom(sdkAppId,"123456",userSig,roomId,role).then((ooo)=>{
                // this.userId = userId;
                // console.log(userId,'ggg');
                this.startRemote(userId, 0).then((res)=>{
                    console.log(res, '666');
                }).catch((e)=>{
                    console.log(e, '777');
                });
            }).catch((e)=>{
                console.log(e,'888');
            });
        }

    }

    componentWillUnmount(){
        this.stopLocal();
    }


    render(){
        return(
            <TRTCVideoView
                ref={this.onRef}
                style={this.props.style}/>
        )
    }
}

export default TRTC;
