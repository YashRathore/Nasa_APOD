//
//  SimpleParameter.h
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWebServiceParameter.h"

NS_ASSUME_NONNULL_BEGIN

@interface SimpleParameter : NSObject<PWebServiceParameter>
{
@private
    NSString*   _name;
    NSString*   _value;
    
}

@property (nonatomic, strong) NSString*    name;
@property (nonatomic, strong) NSString*    value;

-(id) initWithName:(NSString*)name andValue:(NSString*)value;

+(IWebServiceParameter*) simpleParameterWithName:(NSString*)name andIntValue:(NSInteger)value;

+(IWebServiceParameter*) simpleParameterWithName:(NSString*)name andStringValue:(NSString*)value;

@end

NS_ASSUME_NONNULL_END
