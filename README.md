# LJIn-AppBrowser

This a simple but useful In-App browser.

![image](https://github.com/longjianjiang/LJIn-AppBrowser/blob/master/demo.gif) 

# Requirements
- iOS 7.0 or later
- ARC

# Usage
LJInAppBrowserController is main Class.
```objc
    LJInAppBrowserController *browser = [[LJInAppBrowserController alloc] init];
    browser.loadingProgressColor = [UIColor orangeColor];
    browser.urlStr = @"http://www.baidu.com";
    [self.navigationController pushViewController:browser animated:YES];
```

# Install
* Installation with CocoaPods：`pod 'LJIn-AppBrowser'`
* Manual import：
    * Drag All files in the `LJInAppBrowser` folder to project

# License
[Apache]: http://www.apache.org/licenses/LICENSE-2.0
[MIT]: http://www.opensource.org/licenses/mit-license.php
[GPL]: http://www.gnu.org/licenses/gpl.html
[BSD]: http://opensource.org/licenses/bsd-license.php
[MIT license][MIT].
