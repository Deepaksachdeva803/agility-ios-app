//
//  OTVBClientManager.m
//  Open Tok Video Broadcasting Demo
//
//  Created by Praveen on 7/14/15.
//  Copyright (c) 2015 Sandeep Kumar. All rights reserved.
//

#import "OTVBClientManager.h"

static NSString * const CSAPIBaseURLString = @"https://agility-demo.herokuapp.com/";

static BOOL alertViewed = NO;

@implementation OTVBClientManager

{
    int retry;
}

+ (instancetype)sharedClient
{
    static OTVBClientManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:CSAPIBaseURLString]];
        /*
         * If we want to do pinning, switch to AFSSLPinningModePublicKey. However, then the public
         * key has to be added to the bundle, and if the public key ever changes old versions of the app
         * will stop working - malmer
         */
        [_sharedClient setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]];

    });
    AFNetworkReachabilityManager *reachabilityManager = _sharedClient.reachabilityManager;
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
    {
        NSOperationQueue *operationQueue = _sharedClient.operationQueue;
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                NSLog(@"");
                   [operationQueue setSuspended:YES];
                break;
        }
    }];
    [reachabilityManager startMonitoring];
    return _sharedClient;
}

- (BOOL)connected
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

//Override to include key and signature as parameters when making api calls.
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void ( ^ ) ( NSURLSessionDataTask *task , id responseObject ))success
                      failure:(void ( ^ ) ( NSURLSessionDataTask *task , NSError *error ))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    for(NSString *key in [parameters allKeys])
    {
        [params setObject:[parameters objectForKey:key] forKey:key];
    }
    
    if ([self connected])
    {
        [[self requestSerializer] setTimeoutInterval:30];
        
        [OTVBClientManager alertViewed:NO];
        
        return [super GET:(NSString *)URLString parameters:(NSDictionary *)params
                  success:(void ( ^ ) ( NSURLSessionDataTask *task , id responseObject ))success
                  failure:(void ( ^ ) ( NSURLSessionDataTask *task , NSError *error ))failure];
    }
    
    if (![self connected])
    {
        if (retry < 3)
        {
            // try again in a few
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self GET:URLString parameters:parameters success:success failure:failure];
            });
            
            retry++;
        }
        else
        {
            NSLog(@"No more retries");
                        
            if (![OTVBClientManager wasAlertViewed])
            {
                UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Sorry, an error occurred" message:@"Please check your Internet connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [error show];
            }
            retry = 0;
        }
    }
    
    return nil;
}

+ (int)wasAlertViewed
{
    return alertViewed;
}

+ (void)alertViewed:(BOOL)viewed
{
    alertViewed = viewed;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [OTVBClientManager alertViewed:YES];
}

//Override to include key and signature as parameters when making api calls.
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void ( ^ ) ( NSURLSessionDataTask *task , id responseObject ))success
                       failure:(void ( ^ ) ( NSURLSessionDataTask *task , NSError *error ))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    for(NSString *key in [parameters allKeys])
    {
        [params setObject:[parameters objectForKey:key] forKey:key];
    }
    
    if ([self connected])
    {
        [[self requestSerializer] setTimeoutInterval:30];
        
        [OTVBClientManager alertViewed:NO];
        
        return [super POST:(NSString *)URLString parameters:(NSDictionary *)params
                   success:(void ( ^ ) ( NSURLSessionDataTask *task , id responseObject ))success
                   failure:(void ( ^ ) ( NSURLSessionDataTask *task , NSError *error ))failure];
    }
    
    if (![self connected])
    {
        if (retry < 3)
        {
            // try again in a few
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self POST:URLString parameters:parameters success:success failure:failure];
            });
            retry++;
        }
        else
        {
            NSLog(@"No more retries");
            [self dismissLoading];
            
            if (![OTVBClientManager wasAlertViewed])
            {
                UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Sorry, an error occurred" message:@"Please check your Internet connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [error show];
            }
            retry = 0;
        }
    }
    
    return nil;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
     constructingBodyWithBlock:(void ( ^ ) ( id<AFMultipartFormData> formData ))block
                       success:(void ( ^ ) ( NSURLSessionDataTask *task , id responseObject ))success
                       failure:(void ( ^ ) ( NSURLSessionDataTask *task , NSError *error ))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    for(NSString *key in [parameters allKeys])
    {
        [params setObject:[parameters objectForKey:key] forKey:key];
    }
    
    if ([self connected])
    {
        [[self requestSerializer] setTimeoutInterval:30];
        
        [OTVBClientManager alertViewed:NO];
        
        return [super POST:(NSString *)URLString
                parameters:(NSDictionary *)params
 constructingBodyWithBlock:(void ( ^ ) ( id<AFMultipartFormData> formData ))block
                   success:(void ( ^ ) ( NSURLSessionDataTask *task , id responseObject ))success
                   failure:(void ( ^ ) ( NSURLSessionDataTask *task , NSError *error ))failure];
        
    }
    
    if (![self connected])
    {
        if (retry < 3)
        {
            // try again in a few
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self POST:URLString parameters:parameters success:success failure:failure];
            });
            retry++;
        }
        else
        {
            NSLog(@"No more retries");
            [self dismissLoading];
            
            if (![OTVBClientManager wasAlertViewed])
            {
                UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Sorry, an error occurred" message:@"Please check your Internet connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [error show];
            }
            retry = 0;
        }
    }
    
    return nil;
}

- (void)dismissLoading
{
    NSLog(@"dismissLoading");
    //    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    //
    //    UIViewController *root = appDelegate.window.rootViewController;
    
    //    [root hideLoading];
    
    //    [root setupNavigationBar];
    
    //    NSLog(@"o q tem nesse button? %@", root.rightButton);
}

@end

