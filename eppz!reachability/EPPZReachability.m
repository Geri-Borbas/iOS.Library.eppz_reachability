//
//  EPPZReachability.m
//  eppz!reachability
//
//  Created by Gardrobe on 6/16/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import "EPPZReachability.h"
#import <netinet/in.h>
#import <arpa/inet.h>


@interface EPPZReachability ()

@property (nonatomic, weak) id <EPPZReachabilityDelegate> delegate;
@property (nonatomic) SCNetworkReachabilityRef reachabilityRef;
@property (nonatomic, strong) EPPZReachabilityCompletitionBlock completition;

+(void)addReachabilityToIndex:(EPPZReachability*) reachability;
+(void)removeReachabilityFromIndex:(EPPZReachability*) reachability;
+(EPPZReachability*)reachabilityForHost:(NSString*) hostNameOrAddress;
+(void)stopListeningHost:(NSString*) hostNameOrIPaddress;

@end


@implementation EPPZReachability


+(EPPZReachability*)reachabilityInstanceForHost:(NSString*) hostNameOrAddress
{
    EPPZReachability *instance = [self reachabilityForHost:hostNameOrAddress];
    if (instance == nil) instance = [[self alloc] initWithHost:hostNameOrAddress];
    return instance;
}


#pragma mark - Synchronous reachability (works with IP addresses as well)

+(void)reachHost:(NSString*) hostNameOrAddress completition:(EPPZReachabilityCompletitionBlock) completition
{
    EPPZRLog(@"EPPZReachability ----------");
    EPPZRLog(@"EPPZReachability reachHost: '%@'", hostNameOrAddress);
    
    EPPZReachability *reachability = [self reachabilityInstanceForHost:hostNameOrAddress];
    reachability.completition = completition;
    [self addReachabilityToIndex:reachability];
    
    [reachability reach];
    
}


#pragma mark - Asynchronous reachability (do not works with IP addresses somewhy)

+(void)listenHost:(NSString*) hostNameOrAddress delegate:(id<EPPZReachabilityDelegate>) delegate
{
    EPPZRLog(@"EPPZReachability ----------");
    EPPZRLog(@"EPPZReachability listenHost: '%@'", hostNameOrAddress);
    
    EPPZReachability *reachability = [self reachabilityInstanceForHost:hostNameOrAddress];
    reachability.delegate = delegate;
    [self addReachabilityToIndex:reachability];
    
    [reachability listen];
}


#pragma mark - Initialize

-(id)initWithHost:(NSString*) hostNameOrAddress
{
    if (self = [super init])
    {
        SCNetworkReachabilityRef reachabilityRef;
        
        _hostNameOrAddress = hostNameOrAddress;
        if ([hostNameOrAddress isIPaddress]) //Pretty neat IP address regular expression check.
        {
            EPPZRLog(@"EPPZReachability initialize new instance for IP address: '%@'", hostNameOrAddress);
            
            //Initialize SCNetworkReachability with address.
            _address = hostNameOrAddress;
            
            static struct sockaddr_in hostAddress;
            bzero(&hostAddress, sizeof(hostAddress));
            hostAddress.sin_len = sizeof(hostAddress);
            hostAddress.sin_family = AF_INET;
            hostAddress.sin_addr.s_addr = inet_addr([self.hostNameOrAddress UTF8String]);
            reachabilityRef = SCNetworkReachabilityCreateWithAddress(NULL, (const struct sockaddr*)&hostAddress);
            EPPZRLog(@"EPPZReachability reachabilityRef %@", reachabilityRef);            
        }
        
        else
        {
            EPPZRLog(@"EPPZReachability initialize new instance for host name: '%@'", hostNameOrAddress);
            
            //Initialize SCNetworkReachability with hostName.
            _hostName = hostNameOrAddress;
            reachabilityRef = SCNetworkReachabilityCreateWithName(nil, [hostNameOrAddress UTF8String]);
            EPPZRLog(@"EPPZReachability reachabilityRef %@", reachabilityRef);            
        }
        
        self.reachabilityRef = reachabilityRef;
    }
    return self;
}


#pragma mark - Features

-(void)reach
{
    EPPZRLog(@"EPPZReachability reach '%@'", self.hostNameOrAddress);
    
    //Get flags.
    dispatch_async(dispatch_queue_create("com.eppz.reachability.reach", NULL), ^
    {
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))
        {
            [self parseFlags:flags];
            dispatch_async(dispatch_get_main_queue(), ^ //Dispatch completition callback on the main thread.
            {
                if (self.completition) self.completition(self);
            });
        }
        
        [self tearDown];
    });
}

-(void)listen
{
    EPPZRLog(@"EPPZReachability listen '%@'", self.hostNameOrAddress);
    
    //Set context, callback.
    SCNetworkReachabilityContext context = {0, (__bridge void*)self, NULL, NULL, NULL};
    SCNetworkReachabilitySetCallback(self.reachabilityRef, reachabilityCallback, &context);
    
    //Dispatch where callbacks happen.
    //SCNetworkReachabilitySetDispatchQueue(self.reachabilityRef, dispatch_queue_create("com.eppz.reachability.listen", NULL));
    SCNetworkReachabilityScheduleWithRunLoop(self.reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    
    //Dispatch a first callback anyway to work around IP address unwanted behaviour (more in http://eppz.eu/blog/?p=260 post).
    BOOL isAddressReachability = (self.address != nil);
    if (isAddressReachability)
    {
        dispatch_async(dispatch_queue_create("com.eppz.reachability.workaround", NULL), ^
        {
            SCNetworkReachabilityFlags flags;
            if (SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))
            {
                //Invoke callback 'by hand'.
                dispatch_async(dispatch_get_main_queue(), ^ //Dispatch delegate callback on the main thread.
                {
                    [self parseFlags:flags];
                    [self.delegate reachabilityChanged:self];
                });
            }
        });
    }
}

static void reachabilityCallback(SCNetworkReachabilityRef reachabilityRef, SCNetworkReachabilityFlags flags, void* info)
{
    if ([(__bridge id)info isKindOfClass:[EPPZReachability class]])
    {
        EPPZReachability *reachability = (__bridge EPPZReachability*)info; //Cast context object.
        EPPZRLog(@"EPPZReachability reachabilityCallback '%@'", reachability.hostNameOrAddress);
        
        dispatch_async(dispatch_get_main_queue(), ^ //Dispatch delegate callback on the main thread.
        {
            [reachability parseFlags:flags];
            [reachability.delegate reachabilityChanged:reachability];
        });
    }
    
    else
    {
        //Has happened while used dispatch_queue instead of CFRunLoop.
        EPPZRLog(@"EPPZReachability reachabilityCallback with unexpected context object %@", info);
    }
}

-(void)parseFlags:(SCNetworkReachabilityFlags) flags
{
    EPPZRLog(@"EPPZReachability parseFlags '%@'", self.hostNameOrAddress);
    
    _flags = flags;
    
    //Typecast flags to arbiraty BOOL properties.
    
        _cellularFlag = (flags & kSCNetworkReachabilityFlagsIsWWAN);
        _reachableFlag =  (flags & kSCNetworkReachabilityFlagsReachable);
        _transistentConnectionFlag = (flags & kSCNetworkReachabilityFlagsTransientConnection);
        _connectionRequiredFlag = (flags & kSCNetworkReachabilityFlagsConnectionRequired);
        _connectionOnTrafficFlag = (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic);
        _interventionRequiredFlag = (flags & kSCNetworkReachabilityFlagsInterventionRequired);
        _connectionOnDemandFlag = (flags & kSCNetworkReachabilityFlagsConnectionOnDemand);
        _localAddressFlag = (flags & kSCNetworkReachabilityFlagsIsLocalAddress);
        _directFlag = (flags & kSCNetworkReachabilityFlagsIsDirect);
    
    //Network status (from Apple's Reachability sample).
    
        _reachableViaWiFi = _reachableViaCellular = _reachable = NO; //Reset.
        
        _notReachable = (self.reachableFlag == NO);
        if (self.notReachable) return; //No other status if not reachable.
        
        _reachableViaWiFi = (self.connectionRequiredFlag == NO);
        if (self.connectionOnDemandFlag || self.connectionOnTrafficFlag) { _reachableViaWiFi = (self.interventionRequiredFlag == NO); }
        _reachableViaCellular = ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN);
        
        _reachable = (self.reachableViaWiFi || self.reachableViaCellular);
        _notReachable = (self.reachableViaWiFi == NO && self.reachableViaCellular == NO);   
}

-(void)dealloc
{ EPPZRLog(@"EPPZReachability dealloc '%@'", self.hostNameOrAddress); }


#pragma mark - Reachability collection maintanance 

__strong static NSMutableDictionary *_reachabilityIndex = nil;

+(NSMutableDictionary*)reachabilityIndex //Like a 'Class property'.
{
    if (_reachabilityIndex == nil) _reachabilityIndex = [NSMutableDictionary new];
    return _reachabilityIndex;
}

+(void)addReachabilityToIndex:(EPPZReachability*) reachability
{
    EPPZRLog(@"EPPZReachability addReachabilityToIndex '%@'", reachability.hostNameOrAddress);    
    
    if (reachability != nil)
    {
        //Replace previous reachability for this host.
        [[self reachabilityIndex] setObject:reachability forKey:reachability.hostNameOrAddress];
    }
    
    EPPZRLog(@"EPPZReachability reachabilityCount: <%i>", [[self reachabilityIndex] count]);
}

+(void)removeReachabilityFromIndex:(EPPZReachability*) reachability
{
    EPPZRLog(@"EPPZReachability removeReachabilityFromIndex '%@'", reachability.hostNameOrAddress);
    
    if (reachability != nil)
        if (reachability.hostNameOrAddress != nil)
            if ([[[self reachabilityIndex] allKeys] containsObject:reachability.hostNameOrAddress])
                [[self reachabilityIndex] removeObjectForKey:reachability.hostNameOrAddress];
    
    EPPZRLog(@"EPPZReachability reachabilityCount: <%i>", [[self reachabilityIndex] count]);        
}

+(EPPZReachability*)reachabilityForHost:(NSString*) hostNameOrAddress
{
    if (hostNameOrAddress != nil)
        if ([[[self reachabilityIndex] allKeys] containsObject:hostNameOrAddress])
            return [[self reachabilityIndex] objectForKey:hostNameOrAddress];
    return nil;
}

+(void)stopListeningHost:(NSString*) hostNameOrIPaddress
{
    //Tear down SCNetworkReachability instance.
    EPPZReachability *reachability = [self reachabilityForHost:hostNameOrIPaddress];
    [reachability tearDown];
}

-(void)tearDown
{    
    EPPZRLog(@"EPPZReachability tearDown '%@'", self.hostNameOrAddress);

    if (self.reachabilityRef != NULL)
    {
        SCNetworkReachabilityUnscheduleFromRunLoop(self.reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
        CFRelease(self.reachabilityRef);
    }
    
    [self.class removeReachabilityFromIndex:self];
}

@end
