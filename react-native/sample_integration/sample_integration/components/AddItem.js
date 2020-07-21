import React, {useState, useEffect} from 'react';
import {
  View,
  Text,
  StyleSheet,
  TextInput,
  TouchableOpacity,
} from 'react-native';
import {Icon} from 'react-native-eva-icons';
import {
  getSessionProperties,
  addSessionProperty,
  startView,
  endView,
} from 'react-native-embrace';

const AddItem = ({addItem}) => {
  const [text, setText] = useState('');
  const displayName = 'AddItem';
  const onChange = (textValue) => {
    setText(textValue);
  };

  useEffect(() => {
    // EMBRACE HINT:
    // Embrace will automatically capture class names for views.  Sometimes that's what you want,
    // other times it is better to customize the name of a view.
    // By default, Embrace will track native views.
    // If you’d like to track when a React component is mounted and unmounted,
    //  you can do so with the startView and endView functions.
    startView(displayName);

    async () => {
      // EMBRACE HINT:
      // Session properties defined as permanent persist across app launch.
      //  This means you can read those properties back and use them for application logic.
      // Notice that the getSessionProperties and addSessionProperty return promises.
      const sessionProps = await getSessionProperties();
      console.log('getProperties -> sessionProps', sessionProps);
    };
    endView(displayName);
  }, []);

  const setSessionItem = (value) => {
    // EMBRACE HINT:
    // Session properties are a great way to keep track of additional information about this session or this device.
    // For example it could be useful to know which items got added in each session.
    addSessionProperty('Session item:', value, false);
  };

  return (
    <View>
      <TextInput
        placeholder="Add Item..."
        style={styles.input}
        onChangeText={onChange}
        value={text}
      />
      <TouchableOpacity
        style={styles.btn}
        onPress={() => {
          addItem(text);
          setSessionItem(text);
          setText('');
        }}>
        <Text style={styles.btnText}>
          <Icon name="plus" fill="darkslateblue" width={18} height={18} />
          Add Item
        </Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  input: {
    height: 60,
    padding: 8,
    margin: 5,
  },
  btn: {
    backgroundColor: '#c2bad8',
    padding: 9,
    margin: 5,
  },
  btnText: {
    color: 'darkslateblue',
    fontSize: 20,
    textAlign: 'center',
  },
});

export default AddItem;
