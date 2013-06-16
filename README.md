## ![eppz!tools](http://eppz.eu/layout/common/eppz_50_GitHub.png) eppz!reachability
Currently this project shows that IP address reachability is not working when using anynchronous method of SCNetworkReachability class. I hooked up a really brief interface to prove this, and yet I cannot see any solution actually.


- - -

Later on, this repository will hold the simplest Reachability wrapper ever (actually it wraps SCNetworkReachability directly).

Network reachability is unfairly overmystyfied due to the really confusing sample implementation provided by Apple. Actually to ask for a particular hostname reachability information is three lines of code.
```Objective-C
SCNetworkReachabilityRef reachabilityRef = SCNetworkReachabilityCreateWithName(NULL, [@"google.com" UTF8String]);
SCNetworkReachabilityFlags reachabilityFlags;
SCNetworkReachabilityGetFlags(reachabilityRef, &reachabilityFlags);
```

#### License
> Licensed under the [Open Source MIT license](http://en.wikipedia.org/wiki/MIT_License).
