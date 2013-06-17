## ![eppz!tools](http://eppz.eu/layout/common/eppz_50_GitHub.png) eppz!reachability
The simplest Reachability wrapper ever.

- - -

```Objective-C
SCNetworkReachabilityRef reachabilityRef = SCNetworkReachabilityCreateWithName(NULL, [@"google.com" UTF8String]);
SCNetworkReachabilityFlags reachabilityFlags;
SCNetworkReachabilityGetFlags(reachabilityRef, &reachabilityFlags);
```

#### License
> Licensed under the [Open Source MIT license](http://en.wikipedia.org/wiki/MIT_License).
