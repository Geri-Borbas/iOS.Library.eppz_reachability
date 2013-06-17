//
//  EPPZRechabilityStatusView.m
//  eppz!tools
//
//  Created by Borbás Geri on 6/14/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZRechabilityStatusView.h"


@interface EPPZRechabilityStatusView ()
@property (nonatomic, weak) IBOutlet UILabel *hostLabel;
@property (nonatomic, weak) IBOutlet UIProgressView *listeningView;

@property (nonatomic, weak) IBOutlet UIProgressView *notReachableView;
@property (nonatomic, weak) IBOutlet UIProgressView *reachableViaCellularView;
@property (nonatomic, weak) IBOutlet UIProgressView *reachableViaWiFiView;

@end



@implementation EPPZRechabilityStatusView


-(void)showReachabilityStatus:(EPPZReachability*) reachability
{
    if (reachability.hostNameOrAddress != nil)
    {
        //From http://iphonedevwiki.net/index.php/AudioServices
        AudioServicesPlaySystemSound (1117);
        self.hostNameOrIPaddress = reachability.hostNameOrAddress;
    }
    
    //Show.
    NSString *hostLabelText = (reachability.hostNameOrAddress) ? reachability.hostNameOrAddress : @"";
    self.hostLabel.text = [NSString stringWithFormat:@" %@", hostLabelText];

    [self setLedForFlag:kSCNetworkReachabilityFlagsIsWWAN on:reachability.cellularFlag];
    [self setLedForFlag:kSCNetworkReachabilityFlagsReachable on:reachability.reachableFlag];
    [self setLedForFlag:kSCNetworkReachabilityFlagsTransientConnection on:reachability.transistentConnectionFlag];
    [self setLedForFlag:kSCNetworkReachabilityFlagsConnectionRequired on:reachability.connectionRequiredFlag];
    [self setLedForFlag:kSCNetworkReachabilityFlagsConnectionOnTraffic on:reachability.connectionOnTrafficFlag];
    [self setLedForFlag:kSCNetworkReachabilityFlagsInterventionRequired on:reachability.interventionRequiredFlag];
    [self setLedForFlag:kSCNetworkReachabilityFlagsConnectionOnDemand on:reachability.connectionOnDemandFlag];
    [self setLedForFlag:kSCNetworkReachabilityFlagsIsWWAN on:reachability.cellularFlag];
    [self setLedForFlag:kSCNetworkReachabilityFlagsIsLocalAddress on:reachability.localAddressFlag];
    [self setLedForFlag:kSCNetworkReachabilityFlagsIsDirect on:reachability.directFlag];
    
    [self setLed:self.notReachableView on:reachability.notReachable];
    [self setLed:self.reachableViaCellularView on:reachability.reachableViaCellular];
    [self setLed:self.reachableViaWiFiView on:reachability.reachableViaWiFi];
}

-(void)setLedForFlag:(uint32_t) flag on:(BOOL) isOn
{
    //Integer values of each SCNetwork flag used to mark 'led' views in IB.
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
    [self setLed:ledView on:isOn];
}

-(void)setLed:(UIProgressView*) ledView on:(BOOL) isOn
{ ledView.progressTintColor = (isOn) ? [UIColor colorWithHue:0.27 saturation:0.9 brightness:0.75 alpha:1.0] : [UIColor colorWithWhite:0.5 alpha:0.5]; }

-(void)setListening:(BOOL) listening
{
    _listening = listening;
    self.listeningView.progressTintColor = (listening) ? [UIColor colorWithHue:0.08 saturation:0.85 brightness:0.95 alpha:1.0] : [UIColor colorWithWhite:0.5 alpha:0.5];
}

-(void)reset
{
    self.hostNameOrIPaddress = @"";
    self.listening = NO;
    [self showReachabilityStatus:nil];
}


@end
