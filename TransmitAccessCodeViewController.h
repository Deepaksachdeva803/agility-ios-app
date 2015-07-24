//
//  TransmitAccessCodeViewController.h
//  Open Tok Video Broadcasting Demo
//
//  Created by Praveen on 7/16/15.
//  Copyright (c) 2015 Sandeep Kumar. All rights reserved.
//

#import "StreamListViewController.h"

@interface TransmitAccessCodeViewController : UIViewController<UITextFieldDelegate>

{
    IBOutlet UITextField *txtField_FirstValue;
    IBOutlet UITextField *txtField_SecondValue;
    IBOutlet UITextField *txtField_thirdValue;
    IBOutlet UITextField *txtField_ForthValue;
    IBOutlet UITextField *txtField_FifthValue;
    IBOutlet UITextField *txtField_SixthValue;
}
- (IBAction)btnClicked_Cancel:(id)sender;

@property (strong, nonatomic) NSString *getSessionID;
@property (strong, nonatomic) NSString *getEventId;
@property (strong, nonatomic) NSString *getApiKey;
@property (strong, nonatomic) NSArray *streams;

@end
