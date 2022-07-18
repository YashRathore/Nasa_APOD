//
//  SearchAPODConnector.m
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import "SearchAPODConnector.h"
#import "Macros.h"

@implementation SearchAPODConnector

-(void) initialize:(NSDictionary*)connectorParam
{
    [super initialize:connectorParam];
    
}

-(void) prepareCall:(NSDictionary*)dictionary
{
    [super prepareCall:dictionary];
    self.date = [dictionary objectForKey:MAPPING_DATE_PARAMETER];
}

-(NSObject<PWebServiceCall>*) getCall
{
    NSObject<PWebServiceCall>* call = [super getCall];
    
    //if we need to add header in request
//    if(self.date != nil)
//    {
//        [call addHeader:@"date" withValue:self.date];
//    }
    return call;
}

-(NSString*) getUrlPostString
{
    return [NSString stringWithFormat:SEARCH_APOD_ENDPOINT,API_KEY,self.date];
}

-(BOOL) canLock{
    return [super canLock];
}

-(NSData*) buildBody{
    return [super buildBody];
}

-(NSInteger) getCallTimeout{
    return [super getCallTimeout];
}

@end

