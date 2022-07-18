//
//  SimpleResponse.m
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import "SimpleResponse.h"


@implementation SimpleResponse

@synthesize isOk = _isOk;

+(IWebServiceResponse*) getOkResponse
{
    SimpleResponse* response = [[SimpleResponse alloc] init];
    response.isOk = YES;
    return (IWebServiceResponse*)response;
}

+(IWebServiceResponse*) getKoResponse
{
    SimpleResponse* response = [[SimpleResponse alloc] init];
    response.isOk = NO;
    return (IWebServiceResponse*)response;
}

@end
