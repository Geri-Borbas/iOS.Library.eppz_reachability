//
//  EPPZReachability.h
//  eppz!reachability
//
//  Created by Gardrobe on 6/16/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

//iOS Frameworks needs to be included.
#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "NSString+EPPZReachability.h"


//May enable for debugging/inspecting.
#define EPPZ_REACHABILITY_LOGGING NO
#define EPPZRLog if (EPPZ_REACHABILITY_LOGGING) NSLog


//Completition block.
@class EPPZReachability;
typedef void(^EPPZReachabilityCompletitionBlock)(EPPZReachability* reachability);


//Delegate.
@protocol EPPZReachabilityDelegate <NSObject>
-(void)reachabilityChanged:(EPPZReachability*) reachability; //Will call back on the main thread.
@end


@interface EPPZReachability : NSObject


#pragma mark - Reachability information

//User-defined trough factory.
@property (nonatomic, readonly) NSString *hostNameOrAddress;
@property (nonatomic, readonly) NSString *hostName;
@property (nonatomic, readonly) NSString *address;

//Networ status flags (for humans).
@property (nonatomic, readonly) BOOL reachable;
@property (nonatomic, readonly) BOOL notReachable;
@property (nonatomic, readonly) BOOL reachableViaCellular;
@property (nonatomic, readonly) BOOL reachableViaWiFi;

//Reachability flags and their aliases (for the curious minds).
@property (nonatomic, readonly) SCNetworkReachabilityFlags flags;
@property (nonatomic, readonly) BOOL cellularFlag;
@property (nonatomic, readonly) BOOL reachableFlag;
@property (nonatomic, readonly) BOOL transistentConnectionFlag;
@property (nonatomic, readonly) BOOL connectionRequiredFlag;
@property (nonatomic, readonly) BOOL connectionOnTrafficFlag;
@property (nonatomic, readonly) BOOL interventionRequiredFlag;
@property (nonatomic, readonly) BOOL connectionOnDemandFlag;
@property (nonatomic, readonly) BOOL localAddressFlag;
@property (nonatomic, readonly) BOOL directFlag;


#pragma mark - Features

+(void)listenHost:(NSString*) hostNameOrAddress delegate:(id<EPPZReachabilityDelegate>) delegate; 
+(void)stopListeningHost:(NSString*) hostNameOrAddress delegate:(id<EPPZReachabilityDelegate>) delegate;

//This method is a one shot method, reachability instance will deallocated after use.
+(void)reachHost:(NSString*) hostNameOrAddress completition:(EPPZReachabilityCompletitionBlock) completition; //Will call back on the main thread.


@end
