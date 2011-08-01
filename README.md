# PGWakeOnLanPlugin 
by [Simon Yeldon](http://ghosty.co.uk/PGWakeOnLan)

## About
PGWakeOnLan is a [PhoneGap](http://www.phonegap.com) plugin that will send a [Wake-on-LAN](http://en.wikipedia.org/wiki/Wake-on-LAN) magic packet to the machine you specify from within your PhoneGap project.

## Dependancies 

### iOS
* iPhone PhoneGap 1.0.0 (http://github.com/phonegap/phonegap-iphone)
* RegexKitLite 4.0 (http://regexkit.sourceforge.net/RegexKitLite/index.html)

### Android
Alright, hold your horses.  Let me write the code first.

## Adding the plugin to your project 

### iOS
1. Place the WakeOnLan.h and WakeOnLan.m to your Plugins folder
2. Place the WakeOnLan.js in your www folder and link it into your project using a &lt;script&gt; tag
3. Download RegexKitLite and add it to your project
4. Add the required librariy libicucore.dylib to your project
5. Open up your PhoneGap.plist file (in Resources) and add the key ```wakeonlan``` and the value ```WakeOnLan``` to the end of the plugins declaration.

### Android
Chill winston.

## Using the plugin 
To use the plugin call the function ```window.plugins.wol.wake(macAddress, success, fail);``` somewhere in your JavaScript

### Example
```javascript
window.plugins.wol.wake("00:00:00:00:00:00", function(success) {
        console.log("Success: "+success);
    }, function(fail) {
        console.log("There was an error: "+fail);
    }
);
```

## Acknowledgements
iOS code inspired heavily by [openwol](http://code.google.com/p/openwol/).

iOS regex provided by [RegexKitLite](http://regexkit.sourceforge.net/RegexKitLite/index.html).

Android code inspired by [Jibbler](http://www.jibble.org/wake-on-lan/).
