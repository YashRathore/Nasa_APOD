//
//  WebServiceManager.h
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWebService.h"

NS_ASSUME_NONNULL_BEGIN

// return parameters
#define RETPARAM_RESPONSE           @"retparameterresponse"
#define RETPARAM_RESULT             @"retparameterresult"
#define RETPARAM_TAG                @"retparametertag"
#define RETPARAM_ERROR              @"retparametererror"
#define RETPARAM_ERROR_MESSAGE      @"retparametererrormessage"
#define RETPARAM_ERROR_TYPE         @"retparametererrortype"
#define RETPARAM_ERROR_SUBTYPE      @"retparametererrorsubtype"
#define RETPARAM_ERROR_CODE         @"retparametererrorcode"
#define RETPARAM_VALUE              @"retparametervalue"

@protocol WebServiceDelegate

-(void) webServiceResponse:(NSDictionary*)dic;

@end

@interface WebServiceManager : NSObject<PWebServiceDelegate>
{
    NSString*       _WsUrl;
    NSMutableDictionary*    _Connectors;
    
@private
    IWebService* _webService;
    
    BOOL        _ManagerInitialized;
    
    NSInteger   _MaxUnsuccessfulAttemps;
    NSInteger   _FreezeDurationAfterLock; // in seconds
    NSInteger   _CurrentUnsuccessfulAttempts;
    BOOL        _AccountLocked;
    NSDate*     _LockTime;
    
    NSString*   _APIKey;
    
    BOOL        _finished;
}

@property (nonatomic, strong) NSMutableDictionary*  connectors;
@property (nonatomic, strong) NSString*             wsUrl;

-(id)initwithConfiguration:(NSDictionary*)configDictionary   withInputParameters:(NSDictionary*)paramDictionary;

-(void) treatCall:(NSMutableDictionary*)callDic withDelegate:(NSObject<WebServiceDelegate>*)delegate;

-(void) initLock;
-(void) saveLock;
-(BOOL) isLocked;
-(void) addAttempt;

@end

NS_ASSUME_NONNULL_END
