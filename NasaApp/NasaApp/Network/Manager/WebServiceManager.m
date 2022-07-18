//
//  WebServiceManager.m
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import "WebServiceManager.h"
#import "IWebServiceCall.h"
#import "IWebServiceConnector.h"
#import "APODWebService.h"
#import "Macros.h"

#define CONNECTORS                        @"connectors"
#define CONNECTOR_CLASS                   @"class"

#define    PREFS_ACCOUNT_LOCKED            @"accountlocked"
#define    PREFS_ACCOUNT_LOCKED_TIME       @"accountlockedtime"
#define    PREFS_ACCOUNT_LOCKED_ATTEMPT    @"accountlockedattempt"

@implementation WebServiceManager
@synthesize connectors = _Connectors;
@synthesize wsUrl = _WsUrl;

-(id)init{
    self = [super init];
    if(self){
        _WsUrl = nil;
        _Connectors = nil;
        
        _ManagerInitialized = NO;
        
        _MaxUnsuccessfulAttemps = 4;
        _FreezeDurationAfterLock = 200; // in seconds
        _CurrentUnsuccessfulAttempts = 0;
        _AccountLocked = NO;
        _LockTime = nil;
        
        _APIKey = nil;
    }
    return self;
}

-(id)initwithConfiguration:(NSDictionary*)configDictionary   withInputParameters:(NSDictionary*)paramDictionary
{
    WebServiceManager* wsManager = [self init];
    [wsManager initwithConfiguration:configDictionary withParameters:paramDictionary];
    return wsManager;
}

-(IWebServiceConnector*) getConnector:(NSString*)name
{
    IWebServiceConnector* connector = [_Connectors objectForKey:name];
    return connector;
}

-(void) treatCall:(NSMutableDictionary*)callDic withDelegate:(NSObject<WebServiceDelegate>*)delegate
{
    NSMutableDictionary* respDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [respDic setValue:[callDic objectForKey:MAPPING_CONNECTOR_NAME] forKey:RETPARAM_TAG];
    
    IWebServiceConnector* connector = [self getConnector:MAPPING_CONNECTOR_NAME];
    
    if([connector canLock] && [self isLocked])
    {
        NSMutableDictionary* error = [NSMutableDictionary dictionaryWithCapacity:1];
        [error setValue:[NSNumber numberWithInt:ERROR_TYPE_LOCK] forKey:RETPARAM_ERROR_TYPE];
        [respDic setValue:error forKey:RETPARAM_ERROR];
        [respDic setValue:[NSNumber numberWithInt:-1] forKey:RETPARAM_RESULT];
        [delegate performSelectorOnMainThread:@selector(webServiceResponse:) withObject:respDic waitUntilDone:NO];
    }
    else
    {
        NSEnumerator* keyEnumerator = [callDic keyEnumerator];
        NSString* key = [keyEnumerator nextObject];
        while (key != nil)
        {
            if([key caseInsensitiveCompare:MAPPING_APIKEY_PARAMETER])//SetAPI Key
            {
                [callDic setValue:[self getAPIKey] forKey:MAPPING_APIKEY_PARAMETER];
                break;
            }
            key = [keyEnumerator nextObject];
        }
        
        if(connector == nil)
        {
            NSMutableDictionary* error = [NSMutableDictionary dictionaryWithCapacity:1];
            [error setValue:[NSNumber numberWithInt:ERROR_TYPE_INTERNAL] forKey:RETPARAM_ERROR_TYPE];
            [error setValue:[NSNumber numberWithInt:ERROR_WS_NO_CONNECTOR] forKey:RETPARAM_ERROR_SUBTYPE];
            [respDic setValue:error forKey:RETPARAM_ERROR];
            [respDic setValue:[NSNumber numberWithInt:-1] forKey:RETPARAM_RESULT];
            [delegate performSelectorOnMainThread:@selector(webServiceResponse:) withObject:respDic waitUntilDone:NO];
        }
        else
        {
            [connector prepareCall:callDic];
            [_webService callWs:connector withResponseBlock:^(BOOL success, NSError *error, NSData * _Nullable result) {
                
                IWebServiceResponseHandler* rHandler = [connector getResponseHandler];
                [rHandler fillResponse:respDic];
                
                [connector removeResponseHandler];
                [delegate performSelectorOnMainThread:@selector(webServiceResponse:) withObject:respDic waitUntilDone:NO];
            }];
        }
    }
}

//
-(void)initwithConfiguration:(NSDictionary*)configParams   withParameters:(NSDictionary*)paramDictionary
{
    NSString* wsClassName = [configParams objectForKey:MAPPING_WEB_SERVICE_CLASS];
    
    Class wsClass = NSClassFromString(wsClassName);
    if(wsClass != nil)
    {
        _webService = [[wsClass alloc] init];
    }
    
    if(_webService != nil)
    {
        self.connectors = [NSMutableDictionary dictionaryWithCapacity:1];
        _MaxUnsuccessfulAttemps = [[configParams objectForKey:MAPPING_MAX_ATTEMPTS] intValue];
        _FreezeDurationAfterLock = [[configParams objectForKey:MAPPING_FREEZE_DURATION] intValue];

        [self initLock];
       
        self.wsUrl = [configParams objectForKey:MAPPING_URL];
        [_webService addUrl:_WsUrl forName:MAIN_URL];
        
        [_webService addUrl:_WsUrl forName:[configParams objectForKey:MAPPING_SERVICE_NAME]];
        [_webService addUrl:_WsUrl forName:[configParams objectForKey:MAPPING_SERVICE_NAME_WIFI]];

        NSString* connectorClassName = [configParams objectForKey:MAPPING_CONNECTOR_CLASS];
        
        Class connectorClass = NSClassFromString(connectorClassName);
        IWebServiceConnector* connector = nil;
        if(connectorClass != nil)
        {
            connector = [[connectorClass alloc] init];
        }
        
        if(connector != nil)
        {
            [connector initialize:configParams];
            [self.connectors setValue:connector forKey:MAPPING_CONNECTOR_NAME];
        }
        
        
        //To map multiple connectors
        /*
         NSDictionary* connectors = [paramDictionary objectForKey:CONNECTORS];
         for(NSString* connectorName in connectors)
         {
         NSDictionary* connectorParam = [connectors objectForKey:connectorName];
         NSString* connectorClassName = [connectorParam objectForKey:CONNECTOR_CLASS];
         
         Class connectorClass = NSClassFromString(connectorClassName);
         IWebServiceConnector* connector = nil;
         if(connectorClass != nil)
         {
         connector = [[connectorClass alloc] init];
         }
         if(connector != nil)
         {
         [connector initialize:configParams];
         [self.connectors setValue:connector forKey:connectorName];
         }
         }*/
        
        if([self.connectors count] > 0)
        {
            _ManagerInitialized = true;
        }
    }
}



-(bool)isStarted
{
    return YES;
}

#pragma mark - PWebServiceDelegate
- (void)finishLoading;
{
    _finished = YES;
}

#pragma mark - utility functions
-(void) initLock
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    _CurrentUnsuccessfulAttempts = 0;
    NSNumber* currentUnsuccessfulAttempts = [defaults valueForKey:PREFS_ACCOUNT_LOCKED_ATTEMPT];
    if(currentUnsuccessfulAttempts)
    {
        _CurrentUnsuccessfulAttempts = [currentUnsuccessfulAttempts intValue];
    }
    
    _AccountLocked = NO;
    NSNumber* accountLocked = [defaults valueForKey:PREFS_ACCOUNT_LOCKED];
    if(accountLocked)
    {
        _AccountLocked = [accountLocked boolValue];
    }
    
    _LockTime = [defaults valueForKey:PREFS_ACCOUNT_LOCKED_TIME];
    
    if([_LockTime compare:[NSDate date]] == NSOrderedAscending)
    {
        _CurrentUnsuccessfulAttempts = 0;
        _AccountLocked = NO;
    }
}

-(void) saveLock
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithInteger:_CurrentUnsuccessfulAttempts] forKey:PREFS_ACCOUNT_LOCKED_ATTEMPT];
    [defaults setValue:[NSNumber numberWithBool:_AccountLocked] forKey:PREFS_ACCOUNT_LOCKED];
    [defaults setValue:_LockTime forKey:PREFS_ACCOUNT_LOCKED_TIME];
}

-(BOOL)isLocked
{
    if(_AccountLocked)
    {
        if([_LockTime compare:[NSDate date]] == NSOrderedAscending)
        {
            _CurrentUnsuccessfulAttempts = 0;
            _AccountLocked = false;
        }
        [self saveLock];
    }
    return _AccountLocked;
}

-(void) addAttempt
{
    _CurrentUnsuccessfulAttempts++;
    
    if(_CurrentUnsuccessfulAttempts >= _MaxUnsuccessfulAttemps)
    {
        _AccountLocked = YES;
        _LockTime = [[NSDate date] dateByAddingTimeInterval:_FreezeDurationAfterLock];
    }
    [self saveLock];
}

-(NSString*) getAPIKey;
{
    if(_APIKey == nil)
    {
        _APIKey = API_KEY;
    }
    return _APIKey;
}

@end

