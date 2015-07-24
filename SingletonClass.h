//
//  SingletonClass.h
//  Open Tok Video Broadcasting Demo
//
//  Created by Praveen on 7/13/15.
//  Copyright (c) 2015 Sandeep Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>
#import <OpenTok/OpenTok.h>

@interface SingletonClass : NSObject

+(SingletonClass*)sharedMemory;

+(void)showProgressHudWithMessage:(NSString*)message andView:(UIView*)view;
+(void)hideProgressHudWithView:(UIView*)view;

@property (strong, nonatomic) NSString *getSessionID;
@property (strong, nonatomic) NSString *getToken;
@property (strong, nonatomic) NSString *getEventId;
@property (strong, nonatomic) NSString *getApiKey;

@property (strong, nonatomic) NSString *streamId;
@property (strong, nonatomic) NSString *streamName;


@property (strong, nonatomic) OTSession* _session;
@property bool isPublisherForStream;
@property (strong, nonatomic) NSMutableArray *arraySelectedTokens;

@end
