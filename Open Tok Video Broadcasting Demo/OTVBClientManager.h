//
//  OTVBClientManager.h
//  Open Tok Video Broadcasting Demo
//
//  Created by Praveen on 7/14/15.
//  Copyright (c) 2015 Sandeep Kumar. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void (^RequestCompletionHandler_ResponseDictonary) (NSError *error, NSDictionary *responseObject);
typedef void (^RequestCompletionHandler_ResponseArray) (NSError *error, NSArray *responseObject);
typedef void (^RequestCompletionHandler_ResponseID) (NSError *error, id responseObject);

@interface OTVBClientManager : AFHTTPSessionManager


+ (instancetype)sharedClient;
+ (int)wasAlertViewed;

+ (void)alertViewed:(BOOL)viewed;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void ( ^ ) ( NSURLSessionDataTask *task , id responseObject ))success
                       failure:(void ( ^ ) ( NSURLSessionDataTask *task , NSError *error ))failure;

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void ( ^ ) ( NSURLSessionDataTask *task , id responseObject ))success
                      failure:(void ( ^ ) ( NSURLSessionDataTask *task , NSError *error ))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
     constructingBodyWithBlock:(void ( ^ ) ( id<AFMultipartFormData> formData ))block
                       success:(void ( ^ ) ( NSURLSessionDataTask *task , id responseObject ))success
                       failure:(void ( ^ ) ( NSURLSessionDataTask *task , NSError *error ))failure;

@end

