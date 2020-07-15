/**
 * @format
 */

import {AppRegistry} from 'react-native';
import App from './App';
import {name as appName} from './app.json';
import {
  initialize,
  setUserIdentifier,
  addSessionProperty,
} from 'react-native-embrace';
//EMBRACE HINT:
// Embrace's platform is built around user sessions.  Finding your users when they have a problem requires that Embrace knows some
// unique information about your user.  We recommend sharing an anonymized version of your internal user id.  This way your
// users will appear in searches when you look, while Embrace will not be able to link sessions back to specific users -- only you can.
// We provide multiple functions to identify users.
setUserIdentifier('user_id_1');
// EMBRACE HINT:
// Session properties are a great way to keep track of additional information about this session or this device.  For example if your
// application runs on kiosk hardware in retail stores, you could add the store id as a permanent property.  Now you can filter and
// search based on your deployed locations.
// In this example we're tracking the component that indentifies users.
addSessionProperty('index.js', 'Identifier Component', false);
//EMBRACE HINT:
// The initialize function is great to keep track of JS PATCH versions.
initialize({patch: 'v1'});
AppRegistry.registerComponent(appName, () => App);
