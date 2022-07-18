//
//  GetNowPlayingResponseHandler.m
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import "GetAPODByRangeResponseHandler.h"
#import "SimpleResponse.h"
#import "NasaApp-Swift.h"

@implementation GetAPODByRangeResponseHandler

-(void) initialize;
{
    [super initialize];
    self.apodArray = [NSMutableArray array];
}

-(IWebServiceResponse*) handleInput:(NSData*)input
{
    IWebServiceResponse* response = nil;
    
    if(input == nil)
    {
        response = [SimpleResponse getKoResponse];
    }
    else
    {
        NSError* error;
        NSDictionary* parsedData = [NSJSONSerialization JSONObjectWithData:input options:0 error:&error];
        
        if (parsedData == nil)
        {
            response = [SimpleResponse getKoResponse];
            _HasError = YES;
            _ErrorType = STATUS_CODE_UNKNOWN_ERROR;
            _ErrorSubType = STATUS_CODE_UNKNOWN_ERROR;
        }
        else
        {
            for (NSDictionary* apodRecord in parsedData) {
                
                APODModel *model = [[APODModel alloc]
                                    initWithTitle:[apodRecord valueForKey:RETPARAM_TITLE]
                                    mediaType:[apodRecord valueForKey:RETPARAM_MEDIA_TYPE]
                                    sdUrl:[apodRecord valueForKey:RETPARAM_URL]
                                    hdUrl:[apodRecord valueForKey:RETPARAM_HD_URL]
                                    releaseDate:[apodRecord valueForKey:RETPARAM_DATE]
                                    pictureDetail:[apodRecord valueForKey:RETPARAM_EXPLANATION]
                                    copyrightMessage:[apodRecord valueForKey:RETPARAM_COPYRIGHT]
                                    serviceVersion:[apodRecord valueForKey:RETPARAM_SERVICE_VERSION]
                                    favourite:[apodRecord valueForKey:RETPARAM_FAVOURITE]
                                    image:nil];
                [self.apodArray addObject:model];
            }
            
            if(self.apodArray.count == 0)
            {
                response = [SimpleResponse getKoResponse];
            }
            else
            {
                response = [SimpleResponse getOkResponse];
            }
        }
    }
    
    return response;
}

-(void) handleHeaders:(NSDictionary*) headers
{
    //Currently nothing to do
    [super handleHeaders:headers];
}

-(IWebServiceResponse*) handleHttpCode:(NSInteger)httpCode
{
    return [super handleHttpCode:httpCode];
}

-(void) fillResponse:(NSMutableDictionary*)response
{
    [super fillResponse:response];
    [response setObject:self.apodArray forKey:RETPARAM_RANGE_ARRAY];
}

- (IWebServiceResponse *)handleError:(NSError *)error{
    SimpleResponse* response = nil;
    
    if([error.domain isEqualToString:APP_ERROR_DOMIAN])
    {
        switch (error.code)
        {
            case DATA_NOT_FOUND:
            {
                response = [[SimpleResponse alloc] init];
                response.isOk = NO;
                _StatusCode = STATUS_CODE_DATA_NOT_FOUND;
            }
                break;
            default:
                response = [[SimpleResponse alloc] init];
                response.isOk = NO;
                _StatusCode = STATUS_CODE_UNKNOWN_ERROR;
                break;
        }
    }
    else{
        response = (SimpleResponse*)[super handleError:error];
    }
    return (IWebServiceResponse *)response;
}

@end

