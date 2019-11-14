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
    View
} from 'react-native';
import TRTC from './src/component/trtc';

class App extends React.Component{
  render(){
    return(
        <TRTC style={styles.container}/>
    )
  }
}
export default App;


const styles = StyleSheet.create({
  container: {
    flex: 1
  }
});