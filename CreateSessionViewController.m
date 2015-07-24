//
//  CreateSessionViewController.m
//  Open Tok Video Broadcasting Demo
//
//  Created by Sandeep Kumar on 7/24/15.
//  Copyright (c) 2015 Sandeep Kumar. All rights reserved.
//

#import "CreateSessionViewController.h"
#import "TransmitAccessCodeViewController.h"

@interface CreateSessionViewController ()

@end

@implementation CreateSessionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
    [[self.btn_CreateSession layer] setBorderWidth:2.0f];
    [[self.btn_CreateSession layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.btn_JoinSession layer] setBorderWidth:2.0f];
    [[self.btn_JoinSession layer] setBorderColor:[UIColor blackColor].CGColor];

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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CreateStreamToStreamList"])
    {
        StreamListViewController *streamListVC = [segue destinationViewController];
        streamListVC.getEventId   = self.getEventId;
        streamListVC.getSessionID = self.getSessionID;
        streamListVC.getApiKey    = self.getApiKey;
    }
    else if ([segue.identifier isEqualToString:@"CreateStreamToJoinEvent"])
    {
//        TransmitAccessCodeViewController *transmitAccessCodeVC = [segue destinationViewController];
        
    }
}

#pragma mark - Actions

- (IBAction)createSession_buttonClick:(id)sender
{
    [SingletonClass showProgressHudWithMessage:@"Please wait" andView:self.view];
    [[ModelServiceses allocModelServices] callPostAPIWithURL:@"token.json"
                                               andParameters:nil
                                       withCompletionHandler:^(NSError *err , NSDictionary *dictResponse, NSInteger statusCode)
     {
         NSLog(@"%@",dictResponse);
         NSDictionary *gettingTokenData = dictResponse;
         
         self.getEventId   = [gettingTokenData objectForKey:@"event_id"];
         self.getSessionID = [gettingTokenData objectForKey:@"session_id"];
         self.getApiKey    = [gettingTokenData objectForKey:@"api_key"];

         objConstant.isPublisherForStream = NO;
         [SingletonClass hideProgressHudWithView:self.view];
         [self performSegueWithIdentifier:@"CreateStreamToStreamList" sender:self];
         
     }];
}

- (IBAction)joinSession_buttonClick:(id)sender
{
    [self performSegueWithIdentifier:@"CreateStreamToJoinEvent" sender:self];

}
@end
