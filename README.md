## ![eppz!tools](http://eppz.eu/layout/common/eppz_50_GitHub.png) eppz!reachability
Simplest Reachability wrapper ever (actually it wraps SCNetworkReachability directly).

Network reachability is unfairly overmystyfied due to the really confusing sample implementation provided by Apple. Actually to ask for a particular hostname reachability information is four lines of code.
```Objective-C
[EPPZAlert alertWithTitle:@"Alert!"
                  message:@"Please choose a task below."
             buttonTitles:@[@"Clean", @"Upload", @"Cancel"]
             completition:^(NSString *selectedButtonTitle)
    {
        if ([selectedButtonTitle isEqualToString:@"Clean"])
            [self clean];
     
        if ([selectedButtonTitle isEqualToString:@"Upload"])
            [self upload];
    }];
```
- - -
Added some factory presets trough a category [EPPZAlert+Factory](https://github.com/eppz/eppz-alert/blob/master/eppz!alert/EPPZAlert%2BFactory.h#L20), so you can make it more explicit like these calls below.
```Objective-C
[EPPZAlert alertWithTitle:@"Select an answer!"
                  message:nil
                      yes:^() { [EPPZAlert alertWithTitle:@"That was a Yes!" message:@"You can belive me."]; }
                       no:^() { [EPPZAlert alertWithTitle:@"That was a No!" message:@"When I say to you."]; }
                   cancel:^() { [EPPZAlert alertWithTitle:@"That was a Cancel!" message:@"I can easily recognize."]; }]; }];
```

#### License
> Licensed under the [Open Source MIT license](http://en.wikipedia.org/wiki/MIT_License).
