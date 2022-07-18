//
//  GetAPODByRangeConnector.m
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import "GetAPODByRangeConnector.h"
#import "Macros.h"

@implementation GetAPODByRangeConnector

-(void) initialize:(NSDictionary*)connectorParam
{
    [super initialize:connectorParam];
    
}

-(void) prepareCall:(NSDictionary*)dictionary
{
    [super prepareCall:dictionary];
    self.startDate = [dictionary objectForKey:MAPPING_START_DATE_PARAMETER];
    self.endDate = [dictionary objectForKey:MAPPING_END_DATE_PARAMETER];
}

-(NSObject<PWebServiceCall>*) getCall
{
    NSObject<PWebServiceCall>* call = [super getCall];
    
    //if we need to add header in request
    //    if(self.startDate)
    //    {
    //        [call addHeader:@"start_date" withValue:self.startDate];
    //    }
    return call;
}

-(NSString*) getUrlPostString
{
    return [NSString stringWithFormat:GET_APOD_RANGE_ENDPOINT,API_KEY,self.startDate,self.endDate];
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

