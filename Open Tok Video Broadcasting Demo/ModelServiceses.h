//
//  ModelServiceses.h
//  Open Tok Video Broadcasting Demo
//
//  Created by Praveen on 7/14/15.
//  Copyright (c) 2015 Sandeep Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelServiceses : NSObject
{
    
}

//Service Completion Block
typedef void (^ModelServiceHandler)(NSError *error,NSDictionary *response ,NSInteger status);


//Alloc Memory
+(ModelServiceses*)allocModelServices;


//Service Methods
-(void) callAPIWithURL:(NSString *)urlString andParameters:(NSDictionary *)parameters withCompletionHandler:(ModelServiceHandler)competionBlock;
-(void) callPostAPIWithURL:(NSString *)urlString andParameters:(NSDictionary *)parameters withCompletionHandler:(ModelServiceHandler)competionBlock;
@end
