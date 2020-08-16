package com.io.embrace.sampleintegration;

import android.app.Application;

import io.embrace.android.embracesdk.Embrace;

public class SampleIntegrationApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
        initSdk();
    }

    private void initSdk() {
        // EMBRACE HINT:
        // Always initialize Embrace as early as possible and in-line with the launch methods your application is using
        // Embrace can't measure what it can't see, so initializing as early as possible gets you the most information to work with.
        //
        // Note: If you want to also use other reporting system such as Crashlytics, that's ok!  Just make sure to initialize Embrace
        // first so we can ensure our compatibility with Crashlytics.
        Embrace.getInstance().start(this);

        // EMBRACE HINT:
        // Always remember to end the startup moment.  This is the best way to measure app launch performance and abandonment.
        // Make sure to call this function when your actual app launch is finished, so if you are loading UI or other data wait
        // to call this until you are finished.
        Embrace.getInstance().endAppStartup();

        // EMBRACE HINT:
        // Embrace's platform is built around user sessions.  Finding your users when they have a problem requires that Embrace knows some
        // unique information about your user.  We recommend sharing an anonymized version of your internal user id.  This way your
        // users will appear in searches when you look, while Embrace will not be able to link sessions back to specific users -- only you can.
        Embrace.getInstance().setUserIdentifier("internal_user_id_1234");

        // EMBRACE HINT:
        // Session properties are a great way to keep track of additional information about this session or this device.  For example if your
        // application runs on kiosk hardware in retail stores, you could add the store id as a permanent property.  Now you can filter and
        // search based on your deployed locations. Properties with the same key overwrite each other.
        // In this example we're tracking the way the application was launched, we want to know which sessions are the result of a push notification.
        Embrace.getInstance().addSessionProperty("normal", "launch type", false);
    }
}
