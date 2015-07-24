//
//  ViewController.h
//  Open Tok Video Broadcasting Demo
//
//  Created by Sandeep Kumar on 7/7/15.
//  Copyright (c) 2015 Sandeep Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonClass.h"

@interface StreamListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

{
     SingletonClass *objConstant;
     OTSession* _session;
    NSMutableArray *arrayStreams;
    ModelServiceses *objModelServiceses;
    IBOutlet UITableView *tableView_StreamData;
    IBOutlet UILabel *lbl_EventId;
    
    IBOutlet UITextField *txtField_TrasmitStreemName;
    
    
    CGRect rectViewTableHeader;
    IBOutlet UIView *viewTableFooter;
    IBOutlet UIView *viewTableHeader;
    
    //////////
    NSString *strEvent_ID;
    NSString *session_id;
    NSString *api_key;
}

@property (strong, nonatomic) IBOutlet UIButton *btnStart;
@property (strong, nonatomic) IBOutlet UIButton *btnExit;

@property (strong, nonatomic) NSString *getSessionID;
@property (strong, nonatomic) NSString *getEventId;
@property (strong, nonatomic) NSString *getApiKey;
@property (strong, nonatomic) NSArray *streams;

@end

