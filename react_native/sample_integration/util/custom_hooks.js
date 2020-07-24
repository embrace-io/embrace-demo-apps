import {useState} from 'react';

// constructor-like feature
export default function useConstructor(callBack = () => {}) {
  const [hasBeenCalled, setHasBeenCalled] = useState(false);
  if (hasBeenCalled) {
    return;
  }
  callBack();
  setHasBeenCalled(true);
}
