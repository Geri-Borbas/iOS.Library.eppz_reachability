//
//  NSString+EPPZReachability.h
//  eppz!reachability
//
//  Created by Gardrobe on 6/16/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (EPPZReachability)


-(BOOL)isIPaddress;
+(BOOL)isIPaddress:(NSString*) string;
+(void)testIsIPaddress;


@end
