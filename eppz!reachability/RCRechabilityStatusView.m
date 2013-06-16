//
//  RCRechabilityStatusView.m
//  eppz!tools
//
//  Created by Borbás Geri on 6/14/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "RCRechabilityStatusView.h"

@implementation RCRechabilityStatusView


-(void)showReachabilityFlags:(SCNetworkReachabilityFlags) flags
{
    //Show.
    [self setLedForFlags:flags flag:kSCNetworkReachabilityFlagsIsWWAN];
    [self setLedForFlags:flags flag:kSCNetworkReachabilityFlagsReachable];
    [self setLedForFlags:flags flag:kSCNetworkReachabilityFlagsTransientConnection];
    [self setLedForFlags:flags flag:kSCNetworkReachabilityFlagsConnectionRequired];
    [self setLedForFlags:flags flag:kSCNetworkReachabilityFlagsConnectionOnTraffic];
    [self setLedForFlags:flags flag:kSCNetworkReachabilityFlagsInterventionRequired];
    [self setLedForFlags:flags flag:kSCNetworkReachabilityFlagsConnectionOnDemand];
    [self setLedForFlags:flags flag:kSCNetworkReachabilityFlagsIsLocalAddress];
    [self setLedForFlags:flags flag:kSCNetworkReachabilityFlagsIsDirect];
    self.hostLabel.text = [NSString stringWithFormat:@" %@", self.latestHost];
}

-(void)setLedForFlags:(SCNetworkConnectionFlags) flags flag:(uint32_t) flag
{
    //Integer values of each flag used to mark 'led' views in IB.
    /*
    kSCNetworkReachabilityFlagsTransientConnection	= 1<<0,     1
    kSCNetworkReachabilityFlagsReachable            = 1<<1,     2
    kSCNetworkReachabilityFlagsConnectionRequired	= 1<<2,     4
    kSCNetworkReachabilityFlagsConnectionOnTraffic	= 1<<3,     8
    kSCNetworkReachabilityFlagsInterventionRequired	= 1<<4,     16
    kSCNetworkReachabilityFlagsConnectionOnDemand	= 1<<5,     32
    kSCNetworkReachabilityFlagsIsLocalAddress       = 1<<16,    65536
    kSCNetworkReachabilityFlagsIsDirect             = 1<<17,    131072
    kSCNetworkReachabilityFlagsIsWWAN               = 1<<18,    262144
    */

    UIProgressView *ledView = (UIProgressView*)[self viewWithTag:flag];
    ledView.progressTintColor = (flags & flag) ? [UIColor colorWithHue:0.27 saturation:0.9 brightness:0.75 alpha:1.0] : [UIColor colorWithWhite:0.5 alpha:0.5];
}

-(void)reset
{
    self.latestHost = @"";
    [self showReachabilityFlags:0];
}


@end
