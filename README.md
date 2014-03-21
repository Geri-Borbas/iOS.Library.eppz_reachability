## eppz!reachability

A pretty comfortable reachability class to make our life easier. Block-based on-demand implementaion won't scatter you code, nor block your main thread. **It also works fine with IP addresses as well (!)**.
```Objective-C
// Get status on-demand.
[EPPZReachability reachHost:hostNameOrIPaddress
                 completion:^(EPPZReachability *reachability)
{ if (reachability.reachable) [self postSomething]; }];
```

Also there is an option to observe reachability status without any need to reference any instance on client side.

```Objective-C
// Listen.
[EPPZReachability listenHost:hostNameOrIPaddress delegate:self];

// Get notified.
-(void)reachabilityChanged:(EPPZReachability*) reachability
{
    if (reachability.reachableViaCellular) [self skipThumbnails];
}
```


### Design
Network reachability is unfairly overmystyfied (at least it was for me) due to the really confusing sample implementation provided by Apple. Actually to ask for a particular hostname reachability information is three lines of code.

```Objective-C
SCNetworkReachabilityRef reachabilityRef = SCNetworkReachabilityCreateWithName(NULL, [@"google.com" UTF8String]);
SCNetworkReachabilityFlags reachabilityFlags;
SCNetworkReachabilityGetFlags(reachabilityRef, &reachabilityFlags);
```

The rest is just implementation sugar. Three innocent lines of code. No notifications (which I instinctively don’t like), no run loops, no any weird stuff, like external setting an objects instance variables. Just the pure feature. The sample above uses a synchronous call I found in SCNetworkReachabiliy documentation called [SCNetworkReachabilityGetFlags](http://developer.apple.com/library/ios/documentation/SystemConfiguration/Reference/SCNetworkReachabilityRef/Reference/reference.html#//apple_ref/c/func/SCNetworkReachabilityGetFlags). So I built this implementation from the ground up to have a more Cocoa Reachability, and to get rid of any unnecessary stuff.

My personal favourite is that this implementation **just works fine with IP addresses as well** (this is the main reason I wrote this Nth reachability wrapper actually). I've struggeled with this issue for days, you can read more about it at [Why asynchronous SCNetworkReachability not works with IP addresses?](http://eppz.eu/blog/?p=260). So factory methods accepts both hostnames and IP addresses.

```Objective-C
+(void)listenHost:(NSString*) hostNameOrAddress delegate:(id<EPPZReachabilityDelegate>) delegate; 
+(void)reachHost:(NSString*) hostNameOrAddress completion:(EPPZReachabilityCompletionBlock) completion;
```
As you may notice there are no any instances returned, since the class maintains a collection of EPPZReachability objects. I have not tested under every circumstances, so if you experience any misbehaviour please let me know by leaving a comment at the corresponding blog post [Simplest Reachability ever](http://eppz.eu/blog/?p=241) (though, I'm gonna use it in production soon).
Hope you like it as I do.


#### License
> Licensed under the [Open Source MIT license](http://en.wikipedia.org/wiki/MIT_License).

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/f18318946db21ca9cc72e360610682c2 "githalytics.com")](http://githalytics.com/eppz/eppz-reachability)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/eppz/eppz-reachability/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

