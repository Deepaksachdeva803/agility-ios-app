//
//  TransmitAccessCodeViewController.m
//  Open Tok Video Broadcasting Demo
//
//  Created by Praveen on 7/16/15.
//  Copyright (c) 2015 Sandeep Kumar. All rights reserved.
//

#import "TransmitAccessCodeViewController.h"

@interface TransmitAccessCodeViewController ()


@end

@implementation TransmitAccessCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.getEventId   = @"";
    self.getSessionID = @"";
    self.getApiKey = @"";

}

//JoinEventToStreamList
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"JoinEventToStreamList"])
    {
        StreamListViewController *streamListVC = [segue destinationViewController];
        streamListVC.getEventId   = self.getEventId;
        streamListVC.getSessionID = self.getSessionID;
        streamListVC.getApiKey    = self.getApiKey;
        streamListVC.streams = self.streams;
    }
}

-(void)getEventDataWithEventId:(NSString *)strEventId
{
    [SingletonClass showProgressHudWithMessage:@"Please wait" andView:self.view];
    [[ModelServiceses allocModelServices] callAPIWithURL:[NSString stringWithFormat:@"token/%@.json",strEventId] andParameters:nil withCompletionHandler:^(NSError *error, NSDictionary *response, NSInteger status) {
        
        [SingletonClass hideProgressHudWithView:self.view];
        if (!error)
        {
            NSLog(@"%@",response);
            NSDictionary *gettingTokenData = response;
            
            self.getEventId = [gettingTokenData objectForKey:@"event_id"];
            self.getSessionID = [gettingTokenData objectForKey:@"session_id"];
            self.getApiKey = [gettingTokenData objectForKey:@"api_key"];
            self.streams = [gettingTokenData objectForKey:@"streams"];
            
            if (self.getEventId.length)
            {
                [self performSegueWithIdentifier:@"JoinEventToStreamList" sender:self];
            }
        }
    }];
}

#pragma mark - text Field Delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    textField.text  =   string;
    if ([string length] > 0)
    {
        if ([textField isEqual:txtField_FirstValue])
        {
            [txtField_SecondValue becomeFirstResponder];
        }
        else if([textField isEqual:txtField_SecondValue])
        {
            [txtField_thirdValue becomeFirstResponder];
        }
        else if([textField isEqual:txtField_thirdValue])
        {
            [txtField_ForthValue becomeFirstResponder];
        }
        else if([textField isEqual:txtField_ForthValue])
        {
            [txtField_FifthValue becomeFirstResponder];
        }
        else if([textField isEqual:txtField_FifthValue])
        {
            [txtField_SixthValue becomeFirstResponder];
        }
        else if([textField isEqual:txtField_SixthValue])
        {
            [textField resignFirstResponder];
            if (txtField_FirstValue.text.length
                && txtField_SecondValue.text.length
                && txtField_thirdValue.text.length
                && txtField_ForthValue.text.length
                && txtField_FifthValue.text.length
                && string.length)
            {
                [self getEventDataWithEventId:@"4F04CB"];
            }
        }
    }
    return FALSE;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if ([txtField_FirstValue.text isEqualToString:@""])
//    {
//        [textField resignFirstResponder];
//    }
}

//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if ([txtField_SixthValue.text isEqual:textField])
//    {
//        [textField resignFirstResponder];
//        if (txtField_FirstValue.text.length
//            && txtField_SecondValue.text.length
//            && txtField_thirdValue.text.length
//            && txtField_ForthValue.text.length
//            && txtField_FifthValue.text.length
//            && txtField_SixthValue.text.length)
//        {
//            
//        }
//    }
//}

- (IBAction)btnClicked_Cancel:(id)sender
{
    txtField_FirstValue.text = @"";
    txtField_SecondValue.text = @"";

    txtField_thirdValue.text = @"";
    txtField_ForthValue.text = @"";

    txtField_FifthValue.text = @"";
    txtField_SixthValue.text = @"";
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
