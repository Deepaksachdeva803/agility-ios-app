//
//  CameraViewController.m
//  Open Tok Video Broadcasting Demo
//
//  Created by Praveen on 7/13/15.
//  Copyright (c) 2015 Sandeep Kumar. All rights reserved.
//

#import "CameraViewController.h"
#import <OpenTok/OpenTok.h>


@interface CameraViewController ()
<OTSessionDelegate,OTPublisherDelegate,OTSubscriberDelegate,OTPublisherKitDelegate>

@end

@implementation CameraViewController
{
    OTSession* _session;
    OTPublisher* _publisher;
    OTSubscriber* _subscriber;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    objConstant = [SingletonClass sharedMemory];
    
    token = self.dictStream[@"token"];
    // Creating the session with open talk server.
    _session = [[OTSession alloc] initWithApiKey:self.api_key
                                       sessionId:self.session_id
                                        delegate:self];
    // Call the Connect method.
    [self doConnect];
    
//    lbl_EvenID.text  = self.strEvent_ID;
    
    NSString *strFirst = self.strEvent_ID;
    NSString *strLast = self.strEvent_ID;
    if (self.strEvent_ID.length == 6)
    {
        strFirst = [self.strEvent_ID substringWithRange:NSMakeRange(0, 3)];
        strLast = [self.strEvent_ID substringWithRange:NSMakeRange(3, 3)];
        lbl_EvenID.text = [NSString stringWithFormat:@"%@-%@",strFirst,strLast];
    }
    else
    {
        lbl_EvenID.text = strFirst;
    }

}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (UIUserInterfaceIdiomPhone == [[UIDevice currentDevice]
                                      userInterfaceIdiom])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark subscriber

- (void)doSubscribe:(OTStream*)stream
{
    _subscriber = [[OTSubscriber alloc] initWithStream:stream
                                              delegate:self];
    OTError *error = nil;
    [_session subscribe:_subscriber error:&error];
    if (error)
    {
        [self showAlert:[error localizedDescription]];
    }
    _subscriber.view.backgroundColor = [UIColor redColor];
    [SingletonClass hideProgressHudWithView:self.view];
}

/**
 * Cleans the subscriber from the view hierarchy, if any.
 * NB: You do *not* have to call unsubscribe in your controller in response to
 * a streamDestroyed event. Any subscribers (or the publisher) for a stream will
 * be automatically removed from the session during cleanup of the stream.
 */
- (void)cleanupSubscriber
{
    [_subscriber.view removeFromSuperview];
    _subscriber = nil;
}
- (void)session:(OTSession*)mySession
  streamCreated:(OTStream *)stream
{
    NSLog(@"session streamCreated (%@)", stream.streamId);
    
    // Step 3a: (if NO == subscribeToSelf): Begin subscribing to a stream we
    // have seen on the OpenTok session.
    if (nil == _subscriber && !objConstant.isPublisherForStream)
    {
        [self doSubscribe:stream];
    }
}
- (void)session:(OTSession*)session
streamDestroyed:(OTStream *)stream
{
    NSLog(@"session streamDestroyed (%@)", stream.streamId);
    
    if ([_subscriber.stream.streamId isEqualToString:stream.streamId])
    {
        [self cleanupSubscriber];
    }
}

- (void)  session:(OTSession *)session
connectionCreated:(OTConnection *)connection
{
    NSLog(@"session connectionCreated (%@)", connection.connectionId);
}

- (void)    session:(OTSession *)session
connectionDestroyed:(OTConnection *)connection
{
    NSLog(@"session connectionDestroyed (%@)", connection.connectionId);
    if ([_subscriber.stream.connection.connectionId
         isEqualToString:connection.connectionId])
    {
        [self cleanupSubscriber];
    }
}

- (void) session:(OTSession*)session
didFailWithError:(OTError*)error
{
    NSLog(@"didFailWithError: (%@)", error);
}

# pragma mark - OTSubscriber delegate callbacks

- (void)subscriberDidConnectToStream:(OTSubscriberKit*)subscriber
{
    NSLog(@"subscriberDidConnectToStream (%@)",
          subscriber.stream.connection.connectionId);
    [_subscriber.view setFrame:CGRectMake(0,
                                          0,
                                          viewForStream.frame.size.width,
                                          viewForStream.frame.size.height)];
    
    [viewForStream addSubview:_subscriber.view];
    
    [viewForStream bringSubviewToFront:btnChangeCam];
}

- (void)subscriber:(OTSubscriberKit*)subscriber
  didFailWithError:(OTError*)error
{
    NSLog(@"subscriber %@ didFailWithError %@",
          subscriber.stream.streamId,
          error);
}

# pragma mark - OTPublisher delegate callbacks

- (void)publisher:(OTPublisherKit*)publisher
  streamDestroyed:(OTStream *)stream
{
    [self cleanupPublisher];
}

- (void)publishxzer:(OTPublisherKit*)publisher
   didFailWithError:(OTError*) error
{
    NSLog(@"publisher didFailWithError %@", error);
    [self cleanupPublisher];
}

//Connection method for subscriber and publisher
- (void)doConnect
{
    if (objConstant.isPublisherForStream)
    {
        [SingletonClass showProgressHudWithMessage:@"Publisher streaming is loading." andView:self.view];
    }
    else
    {
        [SingletonClass showProgressHudWithMessage:@"Subscriber Streaming is loading." andView:self.view];
    }
    OTError *error = nil;
    NSString *streamToken = token;
    if (false)
    {
        streamToken = token;
    }
    [_session connectWithToken:streamToken error:&error];
    if (error)
    {
        [self showAlert:[error localizedDescription]];
    }
}

/**
 * Sets up an instance of OTPublisher to use with this session. OTPubilsher
 * binds to the device camera and microphone, and will provide A/V streams
 * to the OpenTok session.
 */
- (void)doPublish
{
    _publisher = [[OTPublisher alloc]
                  initWithDelegate:self
                  name:[[UIDevice currentDevice] name]];
    
    OTError *error = nil;
    [_session publish:_publisher error:&error];
    
    if (error)
    {
        [self showAlert:[error localizedDescription]];
    }
    [_publisher.view setFrame:CGRectMake(0, 0, viewForStream.frame.size.width, viewForStream.frame.size.height)];
    [viewForStream addSubview:_publisher.view];
    [viewForStream bringSubviewToFront:btnChangeCam];
    [viewForStream bringSubviewToFront:btnSound];
    [viewForStream bringSubviewToFront:btnDisconnectStreaming];
    [SingletonClass hideProgressHudWithView:self.view];
}

/**
 * Cleans up the publisher and its view. At this point, the publisher should not
 * be attached to the session any more.
 */
- (void)cleanupPublisher
{
    [_publisher.view removeFromSuperview];
    _publisher = nil;
    // this is a good place to notify the end-user that publishing has stopped.
}

# pragma mark - OTSession delegate callbacks
- (void)sessionDidConnect:(OTSession*)session
{
    NSLog(@"sessionDidConnect (%@)", session.sessionId);
    
    // Step 2: We have successfully connected, now instantiate a publisher and
    // begin pushing A/V streams into OpenTok.
    if (objConstant.isPublisherForStream)
        [self doPublish];
}

- (void)sessionDidDisconnect:(OTSession*)session
{
    NSString* alertMessage =
    [NSString stringWithFormat:@"Session disconnected: (%@)",
     session.sessionId];
    NSLog(@"sessionDidDisconnect (%@)", alertMessage);
}

- (void)showAlert:(NSString *)string
{
    // show alertview on main UI
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OTError"
                                                        message:string
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil] ;
        [alert show];
    });
}
- (void)dealloc
{
    
}
- (IBAction)btnClickedChangeCam:(id)sender
{
    if (_publisher)
    {
        if (_publisher.cameraPosition == AVCaptureDevicePositionFront)
        {
            _publisher.cameraPosition = AVCaptureDevicePositionBack;
        }
        else
        {
            _publisher.cameraPosition = AVCaptureDevicePositionFront;
        }
    }
}
- (IBAction)btnClickedSoundStop:(id)sender
{
    if (_publisher)
    {
        if (_publisher.publishAudio == YES)
        {
            _publisher.publishAudio = NO;
        }
        else
        {
            _publisher.publishAudio = YES;
        }
    }
    else
    {
        if (_subscriber.subscribeToAudio == YES)
        {
            _subscriber.subscribeToAudio = NO;
        }
        else
        {
            _subscriber.subscribeToAudio = YES;
        }
    }
}

- (IBAction)btnClickedDisconnectStreaming:(id)sender
{
    if (_session)
    {
        [self sessionDidDisconnect:_session];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
