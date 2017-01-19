//
//  LZXBlockBoardViewController.m
//  lexue
//
//  Created by admin on 13-3-4.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import "LZXBlockBoardViewController.h"
#import "LZXAppDelegate.h"
#import "LZXAccount.h"
#import "AFNetworking.h"
#import "LZXConstants.h"
#import "LZXUtils.h"
#import "GCDAsyncSocket.h"

#import "NSData+Base64.h"

@interface LZXBlockBoardViewController ()

@end

@implementation LZXBlockBoardViewController
@synthesize doodleView;
@synthesize canvasBar;
@synthesize popover;

- (id)initWithBlockBoard:(UIImage*)image WithTime:(NSString*)startTime WithTeacherID:(NSString*)thID WithActiveId:(NSString*)activeId{
    self = [super init];
    if (self) {
        [self loadCanvasBarWithGenerator:[[StudentCanvasBarGenerator alloc] init]];//学生
        CGRect frame = CGRectMake(50, 50, kMainScreenWidth-100,kMainScreenHeight-50);
        doodleView = [[LZXDooleView alloc] initWithFrame:frame];
        doodleView.drawView.formPush = YES;//标志他是从教师端推送过来的。
        [doodleView setImage:image];
        [self.view addSubview:doodleView];
        [canvasBar setCanvasView:doodleView.drawView];
        activeTime=startTime;
        nowTeacherID=thID;
        sendActiveId=activeId;
        timeUsed=0;
        oldTime= CFAbsoluteTimeGetCurrent();
    }
    return self;
}
#pragma mark -
#pragma mark Loading a CanvasView from a CanvasViewGenerator

- (void) loadCanvasBarWithGenerator:(LZXCanvasViewGenerator *)generator
{
    CGRect aFrame = CGRectMake(0, 0, kMainScreenWidth, 50);
    canvasBar = [generator canvasBarWithFrame:aFrame];
    LOG(@"%@",canvasBar.recordBtn);
    if(canvasBar.recordBtn){
        [canvasBar.recordBtn setHidden:YES];
        [canvasBar.recordBtn removeFromSuperview];
    }
    [canvasBar initFeedbackBtn];
    [canvasBar receiveObject:^(id object) {
        LOG(@"test:%@",object);
        customBtn = (UIButton *)object;
        NSString *title = [NSString stringWithFormat:@"%@",customBtn.titleLabel.text];
        if([title isEqual:@"提交"]){
            UIImage *sendDoodleImage = [LZXUtils rectScreenshot:doodleView frameRect:CGRectMake(0, 0, doodleView.frame.size.width, doodleView.frame.size.height)];
            NSData *newImageData = UIImageJPEGRepresentation(sendDoodleImage,1.0);
            NSData *imageData=newImageData;
            if ([newImageData length]>204800) {
                imageData = UIImageJPEGRepresentation(sendDoodleImage,0.25);
            }else if ([newImageData length]>102400) {
                imageData = UIImageJPEGRepresentation(sendDoodleImage,0.5);
            }
            //NSData* imageData=UIImagePNGRepresentation(sendDoodleImage);
            CFTimeInterval newTime= CFAbsoluteTimeGetCurrent();
            timeUsed=newTime-oldTime;
            [self performSelectorInBackground:@selector(sendStudentImageData:) withObject:imageData];
            [self toSendForSocket:imageData];
        }
        if([title isEqual:@"关闭"]){
            //    将上方导航条显示在正确位置
            [self.view removeFromSuperview];
        }
        if([title isEqual:@"切换背景"]){
            [self changeBackgroundImage];
        }
        if([title isEqual:@"撤销"]){
            [canvasBar.canvasView undoLatestStep];
        }
        if([title isEqual:@"删除"]){
            [canvasBar.canvasView clear];
        }
        if([title isEqual:@"录制"]){
            [customBtn setTitle:@"停止" forState:UIControlStateNormal];
            doodleView.drawView.isRecording=YES;
            ///[capture performSelector:@selector(startRecording)];
        }else if ([title isEqual:@"停止"]){
            [customBtn setTitle:@"录制" forState:UIControlStateNormal];
            doodleView.drawView.isRecording=NO;
            //[capture performSelector:@selector(stopRecording)];
        }

       

    }];
    canvasBar.backgroundColor = [UIColor whiteColor];
    [self setCanvasBar:canvasBar];

    [self.view addSubview:canvasBar];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame=[[UIScreen mainScreen] bounds];
    //添加屏幕录制cff
   /* capture=[[THCapture alloc] init];
    capture.frameRate = 35;
    capture.delegate = self;
    capture.captureLayer = self.view.layer;*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if([DEVICE_CURRENT floatValue] < 6.0){
        return (interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight);
    }
    else{
        return UIInterfaceOrientationMaskLandscape;
    }
}


- (BOOL)shouldAutorotate {
    return YES;
}


- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}*/
- (void)changeBackgroundImage
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"本地图片", @"拍照",nil];
    [sheet showFromRect:[customBtn frame] inView:self.view animated:YES];
}

-(void)toSendForSocket:(NSData*)imageData
{
    if ([[[LZXAppDelegate sharedAppDelegate] getTeacherSocket] count]) {
        NSString*imageStr=[imageData base64EncodedString];
        NSString* usedTime=[NSString stringWithFormat:@"%.3f",timeUsed];
        GCDAsyncSocket*socket=[[[LZXAppDelegate sharedAppDelegate] getTeacherSocket] objectAtIndex:0];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                INTERACTIVESTART,@"command",
                                [LZXAccount sharedInstance].userXM,@"name",
                                usedTime,@"time",
                                [NSString stringWithFormat:[SERVER stringByAppendingString:GET_STUDENT_AVATAR], [LZXAccount sharedInstance].userName],@"picPath",
                                imageStr,@"image",nil];
        NSMutableData* sendData=[LZXSendData getSendDataWithDic:params];
        [socket writeData:sendData withTimeout:-1 tag:0];
        [socket readDataWithTimeout:-1 tag:0];
        [self.view removeFromSuperview];
    }
    else
    {
        [[LZXAppDelegate sharedAppDelegate] showAlertViewWithMessage:@"已与老师断开连接。"];
    }
}
//
// header_t header;
//-(void)toSendPushData:(NSDictionary*)params
//{
//    GCDAsyncSocket*socket=[[[LZXAppDelegate sharedAppDelegate] getTeacherSocket] objectAtIndex:0];
//    NSData *paramsData = [NSKeyedArchiver archivedDataWithRootObject:params];
//    header.size = paramsData.length;
//    header.type_id = 7;
//    NSMutableData *headData = [NSMutableData dataWithBytes:&header length:sizeof(header)];
//    [headData appendData:paramsData];
//    [socket writeData:headData withTimeout:-1 tag:0];
//    [socket readDataWithTimeout:-1 tag:0];
//}


-(void)sendStudentImageData:(NSData*)imageData
{
    NSString* timeStr=[NSString stringWithFormat:@"%f",timeUsed*1000];
    timeStr=[timeStr substringWithRange:NSMakeRange(0, [timeStr length]-7)];
    NSURL *url = [NSURL URLWithString:[SERVER stringByAppendingString:SUBMIT_INTERACTIVE_URL]];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:sendActiveId, @"activeId",[LZXAccount sharedInstance].userName, @"userId", timeStr, @"useTime",nowTeacherID,@"teacherId",nil];
    NSMutableURLRequest *urlrequest = [httpClient multipartFormRequestWithMethod:@"POST" path:[SERVER stringByAppendingString:SUBMIT_INTERACTIVE_URL]                                                                       parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:imageData name:@"interactive4Student" fileName:[NSString stringWithFormat:@"interactive4Student.png"] mimeType:nil];
    }];
    urlrequest.timeoutInterval = 5;
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlrequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    }];
    [operation start];
}

#pragma mark -
#pragma mark UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (popover) {
        [popover dismissPopoverAnimated:YES];
    }
    //    将上方导航条显示在正确位置
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [doodleView setImage:image];
    [doodleView setNeedsDisplay];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //    将上方导航条显示在正确位置
    if (popover) {
        [popover dismissPopoverAnimated:YES];
    }
    else{
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
	imagePicker.allowsEditing = NO;
    if (buttonIndex == 0){
        imagePicker.sourceType= UIImagePickerControllerSourceTypePhotoLibrary;
        popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [popover presentPopoverFromRect:customBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        } else {
            [self presentModalViewController:imagePicker animated:YES];
        }
        
    }else if (buttonIndex == 1){
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
//            imagePicker.modalInPopover = YES;
//            imagePicker.wantsFullScreenLayout = YES;
//            imagePicker.toolbarHidden = YES;
//            //    将上方导航条隐藏
//            [[UIApplication sharedApplication] setStatusBarHidden:YES];
//            [self presentModalViewController:imagePicker animated:YES];
            //if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f){
                popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
                [popover presentPopoverFromRect:customBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            } else {
                [self presentModalViewController:imagePicker animated:YES];
            }
            return;
        }
    }
}
//适配图片大小
-(CGSize)getimagesize:(UIView*)img ww:(float)ww hh:(float)hh{
    float w = img.frame.size.width;
    float h = img.frame.size.height;
    if (w >ww) {
        h = h*ww/w;
        w=ww;
        if (h > hh) {
            w = w*hh/h;
            h = hh;
        }
    }
    else {
        if (h > hh) {
            h=hh;
            w = w*hh/h;
        }
        else {
            w = img.frame.size.width;
            h = img.frame.size.height;
        }
    }
    return CGSizeMake(w, h);
}

#pragma mark -
#pragma mark THCaptureDelegate
- (void)recordingFinished:(NSString*)outputPath
{
    [self mergedidFinish:outputPath WithError:nil];
    LOG(@"recoding finished");
}

- (void)recordingFaild:(NSError *)error
{
    LOG(@"recoding error");
}

- (void)video: (NSString *)videoPath didFinishSavingWithError:(NSError *) error
  contextInfo: (void *)contextInfo{
	if (error) {
		LOG(@"%@",[error localizedDescription]);
	}
}

- (void)mergedidFinish:(NSString *)videoPath WithError:(NSError *)error
{
    //音频与视频合并结束，存入相册中
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath)) {
		UISaveVideoAtPathToSavedPhotosAlbum(videoPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
	}
}


@end
