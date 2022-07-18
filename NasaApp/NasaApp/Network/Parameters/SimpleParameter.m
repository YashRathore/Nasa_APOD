//
//  SimpleParameter.m
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import "SimpleParameter.h"

@implementation SimpleParameter

@synthesize name = _name;
@synthesize value = _value;

-(id) initWithName:(NSString*)name andValue:(NSString*)value
{
    self = [super init];
    if(self)
    {
        self.name = name;
        self.value = value;
    }
    return self;
}

-(NSString*) getName
{
    return _name;
}

-(NSString*) getValue
{
    return _value;
}



+(IWebServiceParameter*) simpleParameterWithName:(NSString*)name andIntValue:(NSInteger)value;
{
    IWebServiceParameter* param = (IWebServiceParameter*)[[SimpleParameter alloc] initWithName:name andValue:[NSString stringWithFormat:@"%ld",(long)value]];
    return param;
}

+(IWebServiceParameter*) simpleParameterWithName:(NSString*)name andStringValue:(NSString*)value;
{
    IWebServiceParameter* param = (IWebServiceParameter*)[[SimpleParameter alloc] initWithName:name andValue:value];
    return param;
}

@end

