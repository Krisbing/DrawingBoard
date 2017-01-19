//
//  ChangeBackgroundImageCommand.m
//  lexueCanvas
//
//  Created by lezhixing on 13-5-17.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import "ChangeBackgroundImageCommand.h"
#import "UIView+UIImage.h"

@implementation ChangeBackgroundImageCommand
- (void) execute
{
    
    LZXCoordinatingController *coordinatingController = [LZXCoordinatingController sharedInstance];
    canvasViewController = [coordinatingController canvasViewController];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"本地图片",@"涂鸦库",@"拍照",nil];
    [sheet showFromRect:[[canvasViewController customBtn]  frame] inView:canvasViewController.view animated:YES];

}
#pragma mark -
#pragma mark UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([canvasViewController popover]) {
        [[canvasViewController popover] dismissPopoverAnimated:YES];
    }
    //    将上方导航条显示在正确位置
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(isGraffiti == NO)
    {
        [[canvasViewController doodleview] setImage:image];
        [[canvasViewController doodleview] setNeedsDisplay];
    }else
    {
        CGSize viewSize = [canvasViewController doodleview].frame.size;
        float scale = MAX(image.size.width/viewSize.width,image.size.height/viewSize.height );
        if(scale > 1.0){
            scale = 1.0/scale;
            image = [[canvasViewController doodleview] scaleImage:image toScale:scale];
        }
        [[[canvasViewController doodleview] drawView] showImageView:image];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //    将上方导航条显示在正确位置
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (canvasViewController.popover) {
        [canvasViewController.popover dismissPopoverAnimated:YES];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    if (buttonIndex == 0){
        imagePicker.sourceType= UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        canvasViewController.popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [canvasViewController.popover  presentPopoverFromRect:[canvasViewController customBtn].frame inView:canvasViewController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        } else {
            [canvasViewController presentModalViewController:imagePicker animated:YES];
        }
        isGraffiti = NO;
        
    }
    else if (buttonIndex == 1)
    {
        /*涂鸦 可悬浮 可放大缩小*/
        imagePicker.sourceType= UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        canvasViewController.popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [canvasViewController.popover  presentPopoverFromRect:[canvasViewController customBtn].frame inView:canvasViewController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        } else {
            [canvasViewController presentModalViewController:imagePicker animated:YES];
        }
        isGraffiti = YES;
    }
    else if (buttonIndex == 2) {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            imagePicker.modalInPopover = YES;
            imagePicker.wantsFullScreenLayout = YES;
            imagePicker.toolbarHidden = YES;
            //    将上方导航条隐藏
            [canvasViewController presentViewController:imagePicker animated:YES completion:nil];
            isGraffiti = NO;
            return;
        }
    }

}

//
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//   }

@end
