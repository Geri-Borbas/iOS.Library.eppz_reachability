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


@implementation RCViewController


#pragma mark - Interactions

-(void)textFieldDidBeginEditing:(UITextField*) textField
{ [self.statusView reset]; }

-(BOOL)textFieldShouldReturn:(UITextField*) textField
{
    //Invoke reachability.
    [self reach:textField.text];
    
    //Hide keyboard.
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Reachability

-(void)reach:(NSString*) host
{
    //Save for UI.
    self.statusView.latestHost = host;
    
    //Create Reachability.
    
        SCNetworkReachabilityRef reachabilityRef;
    
        BOOL hostSeemsIPaddress = ([[[host componentsSeparatedByString:@"."] objectAtIndex:0] integerValue] != 0);
        if (hostSeemsIPaddress) //Reachability for host address.
        {
            struct sockaddr_in hostAddress;
            hostAddress.sin_family = AF_INET;
            hostAddress.sin_addr.s_addr = inet_addr([host UTF8String]);
            reachabilityRef = SCNetworkReachabilityCreateWithAddress(NULL, (const struct sockaddr*)&hostAddress);
        }
        
        else //Reachability for host name.
        {
            reachabilityRef = SCNetworkReachabilityCreateWithName(nil, [host UTF8String]);
        }
    
        //Add this viewController as context object.
        SCNetworkReachabilityContext context = {0, (__bridge void*)self, NULL, NULL, NULL};
    
    //Get reachability status.
    
        BOOL asynchronous = self.rechabilityModeSegmentedControl.selectedSegmentIndex;
        if (asynchronous) //The asynchronous way, NOT WORKS (!!!) with IP addresses as host.
        {
            //Set callback, dispatch callbacks on a background thread.
            SCNetworkReachabilitySetCallback(reachabilityRef, reachabilityCallback, &context);
            SCNetworkReachabilitySetDispatchQueue(reachabilityRef, dispatch_queue_create("com.eppz.reachability", nil));
        }
        else //The synchronous way, works well with IP addresses as host.

        {
            //Get flags.
            SCNetworkReachabilityFlags flags;
            if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
                [self.statusView showReachabilityFlags:flags];
    }
}

static void reachabilityCallback(SCNetworkReachabilityRef reachabilityRef, SCNetworkReachabilityFlags flags, void* info)
{
    RCViewController *viewController = (__bridge RCViewController*)info; //Cast context object.
    dispatch_async(dispatch_get_main_queue(), ^{ [viewController.statusView showReachabilityFlags:flags]; }); //UI updates only on the main thread.
    
    //Tear down reachability instance.
    CFRelease(reachabilityRef);
}


@end

