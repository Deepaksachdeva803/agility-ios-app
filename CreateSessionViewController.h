//
//  CreateSessionViewController.h
//  Open Tok Video Broadcasting Demo
//
//  Created by Sandeep Kumar on 7/24/15.
//  Copyright (c) 2015 Sandeep Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonClass.h"
@interface CreateSessionViewController : UIViewController

{
    SingletonClass *objConstant;

}
@property (strong, nonatomic) IBOutlet UIButton *btn_CreateSession;

@property (strong, nonatomic) IBOutlet UIButton *btn_JoinSession;
- (IBAction)createSession_buttonClick:(id)sender;
- (IBAction)joinSession_buttonClick:(id)sender;

@property (strong, nonatomic) NSString *getSessionID;
@property (strong, nonatomic) NSString *getEventId;
@property (strong, nonatomic) NSString *getApiKey;

@end
