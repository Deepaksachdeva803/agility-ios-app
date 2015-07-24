//
//  ModelServiceses.m
//  Open Tok Video Broadcasting Demo
//
//  Created by Praveen on 7/14/15.
//  Copyright (c) 2015 Sandeep Kumar. All rights reserved.
//

#import "ModelServiceses.h"
#import <AFNetworking/AFNetworking.h>

@implementation ModelServiceses

static NSString *baseURL = @"https://agility-server.herokuapp.com/";
static ModelServiceses *objModelServiceses;


//initiate Model Serviceses
+(ModelServiceses*)allocModelServices
{
    
    if (!objModelServiceses)
    {
        objModelServiceses = [[ModelServiceses alloc] init];
    }
    
    return objModelServiceses;
}

-(void) callAPIWithURL:(NSString *)urlString andParameters:(NSDictionary *)parameters withCompletionHandler:(ModelServiceHandler)competionBlock
{
    NSURL *mainURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseURL,urlString]];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:mainURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"charset=utf-8"];

    [manager GET:@"" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
         NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
         NSLog(@"Response statusCode: %li", (long)response.statusCode);
         NSInteger stat = response.statusCode;
         
         NSDictionary *responseDict = responseObject;
         competionBlock(nil,responseDict,stat);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
         NSLog(@"Response statusCode: %li", (long)response.statusCode);
         NSInteger stat = response.statusCode;
         
         competionBlock(error,nil,stat);
         
     }];
}

-(void) callPostAPIWithURL:(NSString *)urlString andParameters:(NSDictionary *)parameters withCompletionHandler:(ModelServiceHandler)competionBlock
{
    NSURL *mainURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseURL,urlString]];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:mainURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"charset=utf-8"];
    
    [manager POST:@"" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
         NSLog(@"Response statusCode: %li", (long)response.statusCode);
         NSInteger stat = response.statusCode;
         
         NSDictionary *responseDict = responseObject;
         competionBlock(nil,responseDict,stat);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
         NSLog(@"Response statusCode: %li", (long)response.statusCode);
         NSInteger stat = response.statusCode;
         competionBlock(error,nil,stat);
         
     }];
}

@end

