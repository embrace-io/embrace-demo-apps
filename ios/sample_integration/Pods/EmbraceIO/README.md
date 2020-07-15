![embrace](https://s3.amazonaws.com/embrace-downloads-prod/embrace.png)

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/EmbraceIO.svg)](https://img.shields.io/cocoapods/v/EmbraceIO.svg)
[![Platform](https://img.shields.io/cocoapods/p/EmbraceIO.svg?style=flat)](https://cocoadocs.org/docsets/EmbraceIO)

# Embrace iOS SDK #

Welcome to the iOS SDK! Embrace helps you monitor the performance and stability of your mobile apps and keep your users happy. We provide unmatched visibility into the experiences your users are having, and give you the information and insights you need to maximize the performance of your app.

To get started, head over to https://docs.embrace.io

Contact us on [Slack](https://embrace-io-community.slack.com/) or at [support@embrace.io](mailto:support@embrace.io)

## Settings

Settings can be specified in an `Embrace-Info.plist` file, which must be included in the main application bundle. The following settings are supported.

|Key|Type|Default|Description|
|---|---|---|---|
|API_KEY|string|N/A|The 5-character API key to identify your application.|
|CONFIG_HOSTNAME|string|config.emb-api.com|Hostname to fetch config from.|
|DATA_HOSTNAME|string|data.emb-api.com|Hostname to send data to.|
|DATA_DEV_HOSTNAME|string|data-dev.emb-api.com|Hostname to send dev data to.|
|IMAGES_HOSTNAME|string|images.emb-api.com|Hostname to send images to.|
|CRASH_REPORT_ENABLED|bool|false|Enable Embrace crash reporting.|
|STARTUP_MOMENT_SCREENSHOT_ENABLED|bool|true|Control whether screenshots are captured by startup moment.|
|TRACE_ID_HEADER_NAME|string|x-emb-trace-id|Sets name of the HTTP request header to extract trace ID from.|
|NETWORK[DOMAINS] |dictionary[string:integer]|{}|A list of domains with custom, per-session request capture limits.|
|NETWORK[DEFAULT_CAPTURE_LIMIT] |integer|1000|The default maximum number of requests that will be captured for a given domain in a session.  Applies for domains not in DOMAINS dictionary.|
|MAX_SESSION_SECONDS|integer|nil|Enables timed session mode when set, which will terminate each active session after the given number of seconds has passed.|
|WEBVIEW_ENABLE|bool|true|Control whether webview information is captured|
|WEBVIEW_STRIP_QUERYPARAMS|bool|false|Control whether webview query parameters are captured|
|DISABLED_URL_PATTERNS|array[string]|nil|A list of regex patterns, matching urls are completely ignored and never tracked|
|ENABLE_AUTOMATIC_VIEW_CAPTURE|bool|true|Control whether automatic view capture is enabled, disable this if you are using custom view API|

## Logging guidelines

* Errors for things that customers have an ability to affect and failed because of something they did
* Warnings for things that customers have an ability to affect, but their current action did not lead to an outright failure
* Info for things that are basic normal behavior.
* Debug for things that we are interested in, but is not something that a customer will have much use for, even if it is a critical error.
* Trace for things that we don't want to see in our logs during normal development

