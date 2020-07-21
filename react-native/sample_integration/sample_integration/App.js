import React, {useState, useEffect} from 'react';
import {StyleSheet, FlatList, Alert, SafeAreaView} from 'react-native';

import Header from './components/Header';
import ListItem from './components/ListItem';
import AddItem from './components/AddItem';
import {startMoment, endMoment, logBreadcrumb} from 'react-native-embrace';
import useConstructor from './util/custom_hooks';

const App = () => {
  // Flag true if user is currently editing an item
  const [editStatus, editStatusChange] = useState(false);
  // State to capture information about the item being edited
  const [editItemDetail, editItemDetailChange] = useState({
    id: null,
    text: null,
  });
  const [checkedItems, checkedItemChange] = useState([]);

  // EMBRACE HINT:
  // Storing constants like moment or breadcrumb names make typos less likely.
  const mountedMoment = 'App Mounted';

  useConstructor(() => {
    //This only happens ONCE and it happens BEFORE the initial render.

    // EMBRACE HINT:
    // Moments are a great way to measure the performance and abandonment of workflows within your application.
    // We recommend to wrap non user interruptable flows with moments. For example, here we are measuring how long
    // it takes this component to render.
    startMoment(mountedMoment);
  });
  const [items, setItems] = useState([
    {
      id: '1',
      text: 'Milk',
    },
    {
      id: '2',
      text: 'Eggs',
    },
    {
      id: '3',
      text: 'Bread',
    },
    {
      id: '4',
      text: 'Juice',
    },
  ]);

  useEffect(() => {
    //This only happens ONCE. But it happens AFTER the initial render

    // EMBRACE HINT:
    // This is where we end our edit item moment.  We wanted to measure this interaction as it is core to our user experience.
    // By measuring user interactions in this manner you can start to understand how app performance impacts your user journey.
    // Always make sure to end moments you start, Embrace considered any non-ended moment to be an abandonment by the user
    endMoment(mountedMoment);
  });

  const deleteItem = (targetID) => {
    setItems((prevItems) => {
      return prevItems.filter(({id}) => id !== targetID);
    });
  };

  // Submit the users edits to the overall items state
  const saveEditItem = (id, text) => {
    setItems((prevItems) => {
      return prevItems.map((item) =>
        item.id === editItemDetail.id ? {id, text: editItemDetail.text} : item,
      );
    });
    // Flip edit status back to false
    editStatusChange(!editStatus);
  };

  // Event handler to capture users text input as they edit an item
  const handleEditChange = (text) => {
    editItemDetailChange({id: editItemDetail.id, text});
  };

  const addItem = (text) => {
    // EMBRACE HINT:
    // As you can see from this project, Embrace is much more than just a simple crash tracker.  If you do want to try out
    // Embrace's crash tracking capabilities, simply uncomment the lines below and click the add button with the input field empty.
    //  Make sure that your application is running in release mode with the debugger detached to ensure the crash is captured correctly.
    // see: https://embrace.io/docs/react-native/crash-reporting/for more information

    //EXAMPLE CRASH:
    // const undefinedFunc = () => {
    //   undefined.function();
    // };

    if (!text) {
      //EXAMPLE CRASH:
      // undefinedFunc()
      Alert.alert(
        'No item entered',
        'Please enter an item when adding to your shopping list',
        [
          {
            text: 'Understood',
            style: 'cancel',
          },
        ],
        {cancelable: true},
      );
    } else {
      setItems((prevItems) => {
        return [{id: '5', text}, ...prevItems];
      });
    }
  };

  // capture old items ID and text when user clicks edit
  const editItem = (id, text) => {
    editItemDetailChange({
      id,
      text,
    });
    return editStatusChange(!editStatus);
  };

  const itemChecked = (id, text) => {
    // EMBRACE HINT:
    // Embrace has two options for logging events: breadcrumbs and logs.  This is an example of breadcrumb.
    // Breadcrumbs are lightweight logs that add little overhead to your application.
    // You can use them to add context to sessions.

    const isChecked = checkedItems.filter(
      (checkedItem) => checkedItem.id === id,
    );
    isChecked.length
      ? // remove item from checked items state (uncheck)
        checkedItemChange((prevItems) => {
          logBreadcrumb(`[App.js] trying to uncheck ${text}`);
          return [...prevItems.filter((item) => item.id !== id)];
        })
      : // Add item to checked items state
        checkedItemChange((prevItems) => {
          logBreadcrumb(`[App.js] trying to check ${text}`);
          return [...prevItems.filter((item) => item.id !== id), {id, text}];
        });
  };

  return (
    <SafeAreaView style={styles.container}>
      <Header title="Shopping List" />
      <AddItem addItem={addItem} />
      <FlatList
        data={items}
        renderItem={({item}) => (
          <ListItem
            item={item}
            deleteItem={deleteItem}
            editItem={editItem}
            isEditing={editStatus}
            editItemDetail={editItemDetail}
            saveEditItem={saveEditItem}
            handleEditChange={handleEditChange}
            itemChecked={itemChecked}
            checkedItems={checkedItems}
          />
        )}
      />
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});

export default App;
