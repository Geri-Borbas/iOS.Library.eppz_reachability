//
//  RCReachabilityClientViewController.m
//  eppz!reachability
//
//  Created by Gardrobe on 6/16/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import "RCReachabilityClientViewController.h"
#import "EPPZReachability.h"



@implementation RCReachabilityClientViewController


#pragma mark - Interactions

-(void)textFieldDidBeginEditing:(UITextField*) textField
{
    [EPPZReachability stopListeningHost:self.statusView.hostNameOrIPaddress delegate:self];
    [self.statusView reset];
}

-(BOOL)textFieldShouldReturn:(UITextField*) textField
{
    //Switch between modes.
    if (self.reachabilityModeSegmentedControl.selectedSegmentIndex == 0)
        [self reachHost:textField.text];
    else
        [self listenHost:textField.text];
    
    //Hide keyboard.
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Reachability

-(void)reachHost:(NSString*) hostNameOrIPaddress
{
    //Reachability.
    [EPPZReachability reachHost:hostNameOrIPaddress
                     completion:^(EPPZReachability *reachability)
    {
        //UI.
        [self.statusView showReachabilityStatus:reachability];
    }];
}

-(void)listenHost:(NSString*) hostNameOrIPaddress
{
    //UI.
    self.statusView.hostNameOrIPaddress = hostNameOrIPaddress;
    self.statusView.listening = YES;
    
    //Reachability.
    [EPPZReachability listenHost:hostNameOrIPaddress delegate:self];
}

-(void)reachabilityChanged:(EPPZReachability*) reachability
{
    //UI.
    [self.statusView showReachabilityStatus:reachability];
}


@end
