/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React from 'react';
import {
    StyleSheet,
    View,
    Text
} from 'react-native';
import TRTC from './src/component/trtc';

class App extends React.Component{
  render(){
    return(
        <View style={styles.root}>
            <TRTC style={styles.anchor} role={0}/>
            {/*<TRTC style={styles.audience} role={1}/>*/}
        </View>
    )
  }
}
export default App;


const styles = StyleSheet.create({
    root: {
        flex: 1
    },
    anchor: {
        flex: 1
    },
    audience: {
        position: 'absolute',
        top: 0,
        right: 0,
        width: 120,
        height: 240,
        zIndex: 10,
    }
});
