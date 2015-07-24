//
//  ErrorHelper.h
//  Open Tok Video Broadcasting Demo
//
//  Created by Praveen on 7/14/15.
//  Copyright (c) 2015 Sandeep Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorHelper : NSObject

+ (NSError *)authenticationFailedWithDescription:(NSString *)description;

+ (NSError *)parsingErrorWithDescription:(NSString *)description;

+ (NSError *)apiErrorFromDictionary:(NSDictionary *)dictionary;

+(NSError *)authorizationFailedwithTopic:(NSString *)topic;

@end

