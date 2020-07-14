/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React, {useState, useEffect} from 'react';
import {
  SafeAreaView,
  StyleSheet,
  ScrollView,
  View,
  Text,
  StatusBar,
  TouchableOpacity,
} from 'react-native';

import {Header, Colors} from 'react-native/Libraries/NewAppScreen';
import {
  getSessionProperties,
  addSessionProperty,
  removeSessionProperty,
  logMessage,
  INFO,
  startMoment,
  endMoment,
} from 'react-native-embrace';

const App = () => {
  const [currentProps, setCurrentProps] = useState({});
  const [waitingForReload, setWaitingForReload] = useState(false);
  const exampleProp = 'MyProp';

  useEffect(() => {
    // EMBRACE HINT:
    // This is where we end our add item moment.  We wanted to measure this interaction as it is core to our user experience.
    // By measuring user interactions in this manner you can start to understand how app performance impacts your user journey.
    // Note the waitingForReload boolean used to end the moment
    // Always make sure to end moments you start, Embrace considered any non-ended moment to be an abandonment by the user
    if (waitingForReload) {
      endMoment('AddingASessionProp');
    }
  }, [currentProps]);

  const setProperty = () => {
    // EMBRACE HINT:
    // Moments are a great way to measure the performance and abandonment of workflows within your application
    // Here we are adding a new prop to the session.
    startMoment('AddingASessionProp');
    // EMBRACE HINT:
    // Event logging is how you can ensure that events are available in alerts as they happen, rather than when sessions end.
    // If you are tracking down a difficult bug, or trying to understand a complex interaction -- logging is an appropriate API to use
    // For lighter weight tracking like navigation events, look into breadcrumbs.
    logMessage('Adding a new prop to the session', INFO, {exampleProp}, true);
    // When you use logging events, these are immediately sent to our servers and are meant to be the basis for alerting you to
    // real-time issues with your application in production.  As such, take care not to over-use logging events as they have a higher impact
    // on the performance of your app vs breadcrumbs.
    // Note that our log is a complex object, not a simple string.  By breaking out properties like this we can use their values to power
    // our alerting, we can also search and filter on the property values -- we cannot do that if we only send strings.
    // Taking a screenshot is way to see what the user was looking at yourself.  Consider the users privacy and the impact on performance
    // when enabling this feature.
    addSessionProperty(exampleProp, 'value', true);
    setWaitingForReload(true);
  };

  const getProperties = () => {
    // EMBRACE HINT:
    // Session properties defined as permanent persist across app launch.
    //  This means you can read those properties back and use them for application logic.
    getSessionProperties().then(setCurrentProps);
  };
  //TODO:// EMBRACE HINT:
  // As you can see from this project, Embrace is much more than just a simple crash tracker.  If you do want to try out
  // Embrace's crash tracking capabilities, simply uncomment the below dispatch call.
  //  Ensure that you run your application on real hardware, to ensure the crash is captured correctly.

  //TODO:// EMBRACE HINT:
  // Embrace will automatically capture class names for views.  Sometimes that's what you want,
  // other times it is better to customize the name of a view.  This is especially important if
  // the view's class is used in many places inside your app.
  // Implement this method to customize the name.

  return (
    <>
      <StatusBar barStyle="dark-content" />
      <SafeAreaView>
        <ScrollView
          contentInsetAdjustmentBehavior="automatic"
          style={styles.scrollView}>
          <Header />

          <View style={styles.body}>
            <View style={styles.sectionContainer}>
              <Text style={styles.sectionTitle}>Session Props</Text>

              <View style={styles.container}>
                <TouchableOpacity
                  style={styles.highlight}
                  onPress={() => setProperty()}>
                  <Text>Add my prop </Text>
                </TouchableOpacity>
                <TouchableOpacity
                  style={styles.highlight}
                  onPress={() => getProperties()}>
                  <Text>Get my props</Text>
                </TouchableOpacity>
                <TouchableOpacity
                  style={styles.highlight}
                  onPress={() => removeSessionProperty(exampleProp)}>
                  <Text>Remove my prop</Text>
                </TouchableOpacity>
              </View>
              <Text>
                {currentProps &&
                  Object.keys(currentProps).map((p) => `  ${p}  `)}
              </Text>
            </View>
          </View>
        </ScrollView>
      </SafeAreaView>
    </>
  );
};

const styles = StyleSheet.create({
  scrollView: {
    backgroundColor: Colors.lighter,
  },
  engine: {
    position: 'absolute',
    right: 0,
  },
  body: {
    backgroundColor: Colors.white,
  },
  sectionContainer: {
    marginTop: 32,
    paddingHorizontal: 24,
    marginBottom: '100%',
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
    color: Colors.black,
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
    color: Colors.dark,
  },
  highlight: {
    backgroundColor: '#EC6D48',
    borderRadius: 25,
    marginVertical: 10,
    padding: 10,
  },
  footer: {
    color: Colors.dark,
    fontSize: 12,
    fontWeight: '600',
    padding: 4,
    paddingRight: 12,
    textAlign: 'right',
  },
  container: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
});

export default App;
