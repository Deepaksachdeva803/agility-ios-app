//
//  SingletonClass.m
//  Open Tok Video Broadcasting Demo
//
//  Created by Praveen on 7/13/15.
//  Copyright (c) 2015 Sandeep Kumar. All rights reserved.
//

#import "SingletonClass.h"

static SingletonClass *objConstant;
static MBProgressHUD *hud;
@implementation SingletonClass

+(SingletonClass*)sharedMemory
{
    if (!objConstant)
    {
        objConstant = [[SingletonClass alloc]init];
    }
    return objConstant;
}

#pragma mark - MBProgressHud show or hide

+(void)showProgressHudWithMessage:(NSString *)message andView:(UIView *)view
{
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.mode = MBProgressHUDModeIndeterminate;
    [view setUserInteractionEnabled:NO];
}

+(void)hideProgressHudWithView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
    [view setUserInteractionEnabled:YES];
}

@end
