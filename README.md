# Samaritan

[![License: MPL 2.0](https://img.shields.io/badge/License-MPL%202.0-brightgreen.svg)](https://opensource.org/licenses/MPL-2.0)
![Platforms](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
[![Swift Version](https://img.shields.io/badge/Swift-5.7-F16D39.svg?style=flat)](https://developer.apple.com/swift)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
[![Twitter](https://img.shields.io/badge/twitter-@byaruhaf-blue.svg)](http://twitter.com/byaruhaf)

## Overview

Samaritan Browser, is an partial implementation of Safari functionality, which includes pages navigation and pages zoom features.
This branch was Compiled with Xcode 14.0.0, Swift 5.7 and supports iOS 13 and above.
Project Documentation generate using **Apples DocC** can be accessed using this link (Documentation)

## Implementation Details

### Navigation Implementation

Navigation is implemented with both Buttons and Gestures. Both sharing the same function.
The navigation functions use WKWebView functions (goForward & goBack) if those are not available like after State Restoration.
The navigation functions will switch and use navigation history persisted to disk.

#### Buttons

The state of back/forward Buttons adapt accordingly to reflect an ability for the user to go either back or forward.

#### Gestures

The swipe gestures are combination of both built in WKWebView swipe gestures and gestures added to the starter view.
When the webview is not hidden & webView.canGoBack is true then WKWebView swipe gestures are used.
If starter view is active or webView.canGoBack is false then swipe Gestures added to the starter view are used.  
Both the webview & startview gestures use a slide in transitions so users can seamlessly swipe between both views and they will act like one view.
using the same gestures.

|     Gestures Navigation     | Buttons Navigation                |
| :-------------------------: | :-------------------------------- |
| ![Navigation](Demo/Nav.gif) | ![Navigation](Demo/ButtonNav.gif) |

### Persistence Implementation

The Apps Persistance is implemented using both UserDefaults and Realm

#### UserDefaults

UserDefaults is used to store the Zoom value to be restored for both App Restarts and App Relaunches.
UserDefaults was selected, because zoom levels tend to be device specific.
A user may use Zoom = 150 in an iphone and Zoom = 85% on an ipad.

#### Realm

Realm is used to store the webview navigation history to be restored for App Relaunches.
History is generated from the `webView.backForwardList` during the `encodeRestorableState`
The state restoration framework intentionally discards any state information when the user manually kills an app, or when the state restoration process fails.
These checks exist so that your app doesn’t get stuck in an infinite loop of bad states and restoration crashes.

### Restore WKWebView navigation history

![Restore](Demo/Restore.gif)

### Zoom Implementation

The Apps Zoom is implemented using `webView?.setValue(pageZoom, forKey: "viewScale")` and and is restored in [webView(\_:didFinish:)](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455629-webview). Below is a video comparing Safari Zoom & Samaritan Zoom

[![Safari Zoom vs Samaritan Zoom](Demo/embed.png)](https://youtu.be/nOsr5MuHJPg "Safari Zoom vs Samaritan Zoom")

#### Alternatives Considered

Here are few alternative methods of zoom i tried out.

- pageZoom: using Instance Property [pageZoom](https://developer.apple.com/documentation/webkit/wkwebview/3516411-pagezoom). Main issue this only available for iOS 14.0+
- webkitTextSizeAdjust & evaluateJavaScript: Zoom is possible but not similar to safari
- setZoomScale for the scrollView: Zoom is possible but not similar to safari

### Known issues

- **WKWebView & Xcode 14 Bug**
  On Xcode 14 you get the following warning if you are using WKWebView. The warning doesn't appear in Xcode 13.4.1
  warning run: This method should not be called on the main thread as it may lead to UI unresponsiveness.

  ![Navigation](Demo/Bug2.png)

  Various Forums also reporting the same issue are listed below.

  - https://developer.apple.com/forums/thread/712074
  - https://developer.apple.com/forums/thread/714467
  - https://github.com/OneSignal/OneSignal-iOS-SDK/issues/1113
  - https://developer.apple.com/forums/thread/713290
  - https://groups.google.com/g/google-admob-ads-sdk/c/QQLDBQlO340

At the moment there is no fix we just have to wait for Apple to Squash this Bug.
