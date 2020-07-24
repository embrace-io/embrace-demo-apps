/**
 * @format
 */

import {AppRegistry} from 'react-native';
import App from './App';
import {name as appName} from './app.json';
import {initialize, setUserIdentifier} from 'react-native-embrace';
// EMBRACE HINT:
// Embrace's platform is built around user sessions.  Finding your users when they have a problem requires that Embrace knows some
// unique information about your user.  We recommend sharing an anonymized version of your internal user id.  This way your
// users will appear in searches when you look, while Embrace will not be able to link sessions back to specific users -- only you can.
// We provide multiple functions to identify users.
setUserIdentifier('user_id_1');
//EMBRACE HINT:
// Call the initialize function at the entrypoint of the application.
// This sets up a handler with ErrorUtils so that when there's an unhandled exception, the Embrace SDK has a chance to report it
//  before passing it onto the next registered handler.
// You can also pass in a patch string to identify which version of the JS bundle the app is running.
// This is helpful when you use services like CodePush, where the user could be running the same version of the app
// but a different version of the JS bundle.
initialize({patch: 'v1'});
AppRegistry.registerComponent(appName, () => App);
