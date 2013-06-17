//
//  NSString+EPPZReachability.m
//  eppz!reachability
//
//  Created by Gardrobe on 6/16/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import "NSString+EPPZReachability.h"


@implementation NSString (EPPZReachability)


#pragma mark - Features

-(BOOL)isIPaddress { return [NSString isIPaddress:self]; }
+(BOOL)isIPaddress:(NSString*) string
{
    NSString *result;
    if (string != nil &&
        [string isKindOfClass:self])
    {
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:@"^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
                                      options:0
                                      error:&error];
        NSRange range = [regex rangeOfFirstMatchInString:string
                                                 options:0
                                                   range:NSMakeRange(0, string.length)];
        if (range.location != NSNotFound)
            result = [string substringWithRange:range];
    }
    
    return (result != nil);
}


#pragma mark - Tests

+(void)testIsIPaddress
{
    [self testIsIPaddress:nil];
    [self testIsIPaddress:(NSString*)@[@"NSArray"]];
    [self testIsIPaddress:@"192.168.0. 0"];
    [self testIsIPaddress:@"wreck.168.0.0"];
    [self testIsIPaddress:@"999.168.0.0"];
    [self testIsIPaddress:@"192.168.0.999"];
    [self testIsIPaddress:@"256.256.256.256"];
    [self testIsIPaddress:@"192.168.0.0:8888"];
    [self testIsIPaddress:@"192.168.0.0"];    
    [self testIsIPaddress:@"0.0.0.0"];
    [self testIsIPaddress:@"4.4.4.4"];
    [self testIsIPaddress:@"8.8.8.8"];
}

+(void)testIsIPaddress:(NSString*) string
{ NSLog(@"NSString testIsIPaddress:'%@' result: %@", string, ([NSString isIPaddress:string]) ? @"YES" : @"NO"); }


@end
