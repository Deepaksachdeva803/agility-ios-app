//
//  CameraViewController.h
//  Open Tok Video Broadcasting Demo
//
//  Created by Praveen on 7/13/15.
//  Copyright (c) 2015 Sandeep Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonClass.h"

@interface CameraViewController : UIViewController
{
    SingletonClass *objConstant;
    IBOutlet UIButton *btnChangeCam;
    IBOutlet UIButton *btnSound;
    IBOutlet UIButton *btnDisconnectStreaming;
    
    IBOutlet UILabel *lbl_EvenID;
    NSString *token;
    
    
    IBOutlet UIView *viewForStream;

}
@property (strong, nonatomic) NSDictionary *dictStream;
@property (strong, nonatomic) NSString *strEvent_ID;
@property (strong, nonatomic) NSString *session_id;
@property (strong, nonatomic) NSString *api_key;

@end
