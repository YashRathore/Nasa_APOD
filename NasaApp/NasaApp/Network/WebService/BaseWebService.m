//
//  BaseWebService.m
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import "BaseWebService.h"
#import "IWebServiceCall.h"
#import "BaseWebServiceCall.h"


@implementation BaseWebService
@synthesize delegate = _delegate;

-(id) init
{
    self = [super init];
    if(self)
    {
        _ServerUrls = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return self;
}


-(NSObject<PWebServiceCall>*) newCall
{
    BaseWebServiceCall* call = [[BaseWebServiceCall alloc] init];
    return call;
}

-(NSString*) getUrl:(NSString*)name
{
    NSString* res = [_ServerUrls objectForKey:name];
    
    if(res == nil)
    {
        res = [_ServerUrls objectForKey:MAIN_URL];
    }
    return res;
}

-(void) addUrl:(NSString*)url forName:(NSString*)name
{
    [_ServerUrls setValue:url forKey:name];
}

-(void) addHeader:(NSString*)name withValue:(NSString*)value
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

-(void) callWs:(IWebServiceConnector*)connector withResponseBlock:(MyCompletionBlock)completionBlock
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end

