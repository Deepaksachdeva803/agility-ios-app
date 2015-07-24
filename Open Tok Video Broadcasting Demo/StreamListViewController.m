//
//  ViewController.m
//  Open Tok Video Broadcasting Demo
//
//  Created by Sandeep Kumar on 7/7/15.
//  Copyright (c) 2015 Sandeep Kumar. All rights reserved.
//

#import "StreamListViewController.h"
#import "CameraViewController.h"
//#import <OpenTok/OpenTok.h>
#import "StreamingDataTableViewCell.h"
#import "TransmitAccessCodeViewController.h"

@interface StreamListViewController ()

@end

@implementation StreamListViewController
@synthesize streams;

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrayStreams = [NSMutableArray new];
    
    tableView_StreamData.tableHeaderView = viewTableHeader;
    tableView_StreamData.tableFooterView = viewTableFooter;
    rectViewTableHeader = viewTableFooter.frame;
    
    objConstant = [SingletonClass sharedMemory];
    objConstant.isPublisherForStream =YES;
    _btnStart.layer.borderWidth = 1.0f;
    _btnStart.layer.borderColor = [UIColor grayColor].CGColor;
    _btnStart.clipsToBounds = YES;
    _btnExit.layer.borderWidth = 1.0f;
    _btnExit.layer.borderColor = [UIColor grayColor].CGColor;
    _btnExit.clipsToBounds = YES;
    
    if (!streams.count)
    {
        [self getEventDataWithEventId:self.getEventId withOpenView:NO];
    }
    else
    {
        strEvent_ID = self.getEventId;
        session_id = self.getSessionID;
        api_key = self.getApiKey;
    }
    
    NSString *strFirst = self.getEventId;
    NSString *strLast = self.getEventId;
    if (self.getEventId.length == 6)
    {
        strFirst = [self.getEventId substringWithRange:NSMakeRange(0, 3)];
        strLast = [self.getEventId substringWithRange:NSMakeRange(3, 3)];
        lbl_EventId.text = [NSString stringWithFormat:@"%@-%@",strFirst,strLast];
    }
    else
    {
        lbl_EventId.text = strFirst;
    }
    
    //    [self getTokenID];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)getEventDataWithEventId:(NSString *)strEventId withOpenView:(BOOL)isOpen
{
    [SingletonClass showProgressHudWithMessage:@"Please wait" andView:self.view];
    [[ModelServiceses allocModelServices] callAPIWithURL:[NSString stringWithFormat:@"token/%@.json",strEventId] andParameters:nil withCompletionHandler:^(NSError *error, NSDictionary *response, NSInteger status) {
        
        [SingletonClass hideProgressHudWithView:self.view];
        if (!error)
        {
            NSLog(@"%@",response);
            NSDictionary *gettingTokenData = response;
            strEvent_ID = [gettingTokenData objectForKey:@"event_id"];
            session_id = [gettingTokenData objectForKey:@"session_id"];
            api_key = [gettingTokenData objectForKey:@"api_key"];
            streams = [gettingTokenData objectForKey:@"streams"];
            [self reloadDataTable];
            
            if (isOpen)
            {
                [self btnClickedStart:nil];
            }
        }
    }];
}

-(void)getNewStreamWithEventId:(NSString *)strEventId withStreamName:(NSString *)streamName
{
    [SingletonClass showProgressHudWithMessage:@"Please wait" andView:self.view];
    NSDictionary *parm =  @{@"stream" : @{
                                    @"name":[NSString stringWithFormat:@"%@",streamName]
                                    }
                            };
    
    
    [[ModelServiceses allocModelServices] callPostAPIWithURL:[NSString stringWithFormat:@"token/%@/streams.json",strEventId] andParameters:parm withCompletionHandler:^(NSError *error, NSDictionary *response, NSInteger status) {
        
        [SingletonClass hideProgressHudWithView:self.view];
        if (!error)
        {
            txtField_TrasmitStreemName.text = @"";
            [self getEventDataWithEventId:strEventId withOpenView:YES];
            //            NSLog(@"%@",response);
            //            NSDictionary *gettingTokenData = response;
            //            strEvent_ID = [gettingTokenData objectForKey:@"event_id"];
            //            session_id = [gettingTokenData objectForKey:@"session_id"];
            //            api_key = [gettingTokenData objectForKey:@"api_key"];
            //            streams = [gettingTokenData objectForKey:@"streams"];
            //            [self reloadDataTable];
        }
    }];
}

-(void)getTokenID
{
    [SingletonClass showProgressHudWithMessage:@"Please wait" andView:self.view];
    [[ModelServiceses allocModelServices] callPostAPIWithURL:@"token.json" andParameters:nil withCompletionHandler:^(NSError *err , NSDictionary *dictResponse, NSInteger statusCode)
     {
         NSLog(@"%@",dictResponse);
         NSDictionary *gettingTokenData =dictResponse;
         objConstant.getEventId   = [gettingTokenData objectForKey:@"event_id"];
         objConstant.getSessionID = [gettingTokenData objectForKey:@"session_id"];
         objConstant.getApiKey    = [gettingTokenData objectForKey:@"api_key"];
         
         objConstant.isPublisherForStream = NO;
         lbl_EventId.text  = objConstant.getEventId;
         [SingletonClass hideProgressHudWithView:self.view];
         
         [self getStreamList];
         
     }];
}

-(void)getStreamList
{
    if (objConstant.getEventId != NULL)
    {
        [SingletonClass showProgressHudWithMessage:@"Loading streaming" andView:self.view];
        NSString *objEventId = @"EC75ED"; //objConstant.getEventId;
        
        [[ModelServiceses allocModelServices] callAPIWithURL:[NSString stringWithFormat:@"token/%@.json",objEventId] andParameters:nil withCompletionHandler:^(NSError *err , NSDictionary *dictResponse, NSInteger statusCode)
         {
             NSLog(@"%@",dictResponse);
             
             NSArray *objGettingstreams = [dictResponse valueForKey:@"streams"];
             
             objConstant.streamId   =  [objGettingstreams valueForKey:@"id"];
             objConstant.streamName =  [objGettingstreams valueForKey:@"name"];
             objConstant.getToken   =  [objGettingstreams valueForKey:@"token"];
             
             arrayStreams = [NSMutableArray arrayWithArray:objGettingstreams];
             [self reloadDataTable];
             [SingletonClass hideProgressHudWithView:self.view];
         }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Get event Id first!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}

#pragma mark Button Clicked

- (IBAction)btnClickedStart:(id)sender
{
    if (!txtField_TrasmitStreemName.text.length)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter Stream Name" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self openPubsisher];
//    [self getNewStreamWithEventId:self.getEventId withStreamName:txtField_TrasmitStreemName.text];
    
}

-(void)openPubsisher
{
    if (streams.count)
    {
        NSDictionary *dict = [streams objectAtIndex:streams.count-1];
        objConstant.isPublisherForStream = YES;
        CameraViewController *objCameraViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"cameraVC"];
        objCameraViewController.dictStream = dict;
        
        objCameraViewController.strEvent_ID = strEvent_ID;
        objCameraViewController.session_id = session_id;
        objCameraViewController.api_key = api_key;
        
        [self.navigationController pushViewController:objCameraViewController animated:YES];
    }
}

- (IBAction)btnClickedExit:(id)sender
{
    
}

#pragma mark TableView Deligate and DataSources

-(void)reloadDataTable
{
//    if (streams.count)
//    {
//        tableView_StreamData.tableHeaderView = viewTableHeader;
////        CGRect rect = rectViewTableHeader;
////        rect.size.height = 200;
////        viewTableFooter.frame = rect;
////        rectViewTableHeader = viewTableFooter.frame;
//    }
//    else
//    {
//        tableView_StreamData.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
////        CGRect rect = rectViewTableHeader;
////        rect.size.height = 200;
////        viewTableFooter.frame = rect;
////        rectViewTableHeader = viewTableFooter.frame;
//    }
    [tableView_StreamData reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return streams.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell Identifier";
    StreamingDataTableViewCell *cell = (StreamingDataTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *arrayNibs = [[NSBundle mainBundle]loadNibNamed:@"StreamingDataTableViewCell" owner:self options:nil];
        cell = [arrayNibs firstObject];
    }
    
    NSDictionary *dict = [streams objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *strStreamName = dict[@"name"];
    if (!strStreamName || [strStreamName isKindOfClass:[NSNull class]] || !strStreamName.length)
    {
        strStreamName = [NSString stringWithFormat:@"Stream %@",dict[@"id"]];
    }
    cell.tableCell_LabelText.text = strStreamName;
    cell.tabelCell_ImageView.image = [UIImage imageNamed:@"screen_monitor"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [streams objectAtIndex:indexPath.row];
    objConstant.isPublisherForStream = NO;
    CameraViewController *objCameraViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"cameraVC"];
    objCameraViewController.dictStream = dict;
    
    objCameraViewController.strEvent_ID = strEvent_ID;
    objCameraViewController.session_id = session_id;
    objCameraViewController.api_key = api_key;
    
    [self.navigationController pushViewController:objCameraViewController animated:YES];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
