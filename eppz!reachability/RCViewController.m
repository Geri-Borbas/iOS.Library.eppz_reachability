//
//  RCViewController.m
//  eppz!tools
//
//  Created by Borbás Geri on 6/14/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "RCViewController.h"

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>


@implementation RCViewController


#pragma mark - Interactions

-(BOOL)textFieldShouldReturn:(UITextField*) textField
{
    //Invoke reachability.
    [self reach:textField.text];
    
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Reachability

static void reachabilityCallback(SCNetworkReachabilityRef reachabilityRef, SCNetworkReachabilityFlags flags, void* info)
{
    RCViewController *viewController = (__bridge RCViewController*)info;
    [viewController showReachabilityFlags:flags];
    
    //Tear down reachability.
    SCNetworkReachabilityUnscheduleFromRunLoop(reachabilityRef, CFRunLoopGetMain(), kCFRunLoopDefaultMode);
    CFRelease(reachabilityRef);
}

-(void)reach:(NSString*) hostName
{
	SCNetworkReachabilityRef reachabilityRef = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]); //Create.
    SCNetworkReachabilityContext context = {0, (__bridge void*)self, nil, nil, nil}; //Add self as a context.
    
    //The synchronous way, works well with IP addresses as hostname.
    if (YES)
    {
        //Get flags.
        SCNetworkReachabilityFlags flags;
        SCNetworkReachabilityGetFlags(reachabilityRef, &flags);
        
        //Show.
        [self showReachabilityFlags:flags];
    }
    
    //The asynchronous way, NOT WORKS (!!!) with IP addresses as hostname.
    else
    {
        //Add reachabilityCallback() as callback function.
        SCNetworkReachabilitySetCallback(reachabilityRef, reachabilityCallback, &context);
        
        //Schedule for the main runloop.
        SCNetworkReachabilityScheduleWithRunLoop(reachabilityRef, CFRunLoopGetMain(), kCFRunLoopDefaultMode);
    }
}

-(void)showReachabilityFlags:(SCNetworkReachabilityFlags) flags
{
    //Human readable.
    NSString *reachabilityFlags = [NSString stringWithFormat:@"Reachability flags: %c%c%c%c%c%c%c%c%c",
                                   (flags & kSCNetworkReachabilityFlagsIsWWAN)				 ? 'W' : '-',
                                   (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
                                   (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
                                   (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
                                   (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
                                   (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
                                   (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
                                   (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
                                   (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-'];
    
    //UI sugar.
    self.statusLabel.alpha = 1.0;
    self.statusLabel.text = reachabilityFlags;
    [UIView animateWithDuration:2.0 animations:^{ self.statusLabel.alpha = 0.0; }];
}

@end

