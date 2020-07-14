# Embrace sample application

This sample project demonstrates many of the features of Embrace so you can better understand how to use them within your own application.

The application is based off the React Native CLI Quickstart.

As you read through the code, look out for "Embrace Hint" comments.  These explain why we're making the calls were making, and may give you some ideas of how to use Embrace yourself.

## Running this app
To try this sample against your own integration, first sign up for an Embrace API key [here](https://dash.embrace.io)

Since we are using a react-native version over 0.60 there's no need for you to link the dependencies manually. 

### Instructions for running IOS
Embrace is integrated with this project using cocoa pods.  Make sure you run "pod update" from the root folder to get the latest version. 

This project contains an Embrace-Info.plist. Open that file and replace "USE_YOUR_KEY" with your real key.

### Instructions for running Android 
This project contains an embrace-config.json. The config file supports many options you can find [here](https://github.com/embrace-io/embrace-android-sdk3#config-settings)

For the initial integration the only two necessary keys are `app_id` and `api_token`

## Further reading
To learn more about Embrace visit our website: https://embrace.io/
Or check out of full documentation: https://docs.embrace.io/
