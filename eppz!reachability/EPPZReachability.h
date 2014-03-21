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


#define EPPZ_REACHABILITY_LOGGING NO
#define EPPZRLog if (EPPZ_REACHABILITY_LOGGING) NSLog


@class EPPZReachability;
typedef void(^EPPZReachabilityCompletionBlock)(EPPZReachability* reachability);
typedef void(^EPPZReachabilityCompletitionBlock)(EPPZReachability* reachability) DEPRECATED_MSG_ATTRIBUTE("Use `EPPZReachabilityCompletionBlock` instead.");


@protocol EPPZReachabilityDelegate <NSObject>
-(void)reachabilityChanged:(EPPZReachability*) reachability;
@end


@interface EPPZReachability : NSObject


#pragma mark - User defined

@property (nonatomic, readonly) NSString *hostNameOrAddress;
@property (nonatomic, readonly) NSString *hostName;
@property (nonatomic, readonly) NSString *address;


#pragma mark - Network status flag aliases

@property (nonatomic, readonly) BOOL reachable;
@property (nonatomic, readonly) BOOL notReachable;
@property (nonatomic, readonly) BOOL reachableViaCellular;
@property (nonatomic, readonly) BOOL reachableViaWiFi;


#pragma mark - Reachability flags

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

/*!
 
 Listens to the given host (or IP) with delegate callbacks
 on change. The created instance gonna be retained internally.
 Call `stopListeningHost:delegate:` to release instance.
 
 @param hostNameOrAddress Host name or IP address to listen to.
 @param delegate
 Delegate object that is to be listening to reachability changes.
 Methods will be called on main thread
 
*/
+(void)listenHost:(NSString*) hostNameOrAddress
         delegate:(id<EPPZReachabilityDelegate>) delegate;

/*!
 
 Stops a previously started host (or IP) listening.

 @param hostNameOrAddress Host name or IP address is beign listened to.
 @param delegate Delegate object that is listening to reachability changes.
 
 */
+(void)stopListeningHost:(NSString*) hostNameOrAddress
                delegate:(id<EPPZReachabilityDelegate>) delegate;

/*!
 
 A one shot method that inspect a host (or IP) if it is reachable.
 Reachability instance gonna be deallocated after completion callback.
 
 @param hostNameOrAddress Host name or IP address to inspect.
 @param completion
 Completion callback upon reachability state retrival. Will be called
 on main thread.
 
 */
+(void)reachHost:(NSString*) hostNameOrAddress
      completion:(EPPZReachabilityCompletionBlock) completion;

/*
 
 Previous version with bad wording.
 
 */
+(void)reachHost:(NSString*) hostNameOrAddress
    completition:(EPPZReachabilityCompletitionBlock) completition DEPRECATED_MSG_ATTRIBUTE("Use `reachHost:completion:` instead.");


@end
