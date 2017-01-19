//
//  LZXBlockBoardViewController.h
//  lexue
//
//  Created by admin on 13-3-4.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZXDooleView.h"
#import "LZXCanvasViewGenerator.h"
#import "LZXCanvasBar.h"
//#import "THCapture.h"
@interface LZXBlockBoardViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,/*THCaptureDelegate,*/UINavigationControllerDelegate>{
    
    UIButton *customBtn;
   // THCapture *capture;
    NSString* sendActiveId;
    NSString* activeTime;
    float timeUsed;
    NSString* nowTeacherID;
    CFTimeInterval oldTime;
}
@property (nonatomic,strong) LZXDooleView *doodleView;
@property (nonatomic,strong) LZXCanvasBar *canvasBar;
@property (nonatomic, strong) UIPopoverController *popover;

- (id)initWithBlockBoard:(UIImage*)image WithTime:(NSString*)startTime WithTeacherID:(NSString*)thID WithActiveId:(NSString*)activeId;

- (void) loadCanvasBarWithGenerator:(LZXCanvasViewGenerator *)generator;

@end
