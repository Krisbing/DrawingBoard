//
//  LZXDoodleViewController.h
//  lexue
//
//  Created by admin on 12-8-12.
//  Copyright (c) 2012年 lezhixing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZXDooleView.h"
#import "LZXCanvasViewGenerator.h"
#import "LZXCanvasBar.h"
#import "LZXBrowserTabView.h"


#define kLZXCanvasBarHight 50
#define LZXActionBarwidth  100 
#define kLZXTabBarHigh 30

@interface LZXDoodleViewController : UIViewController<LZXBrowserTabViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    @private
    LZXDooleView *doodleview;
    LZXBrowserTabView  *tabController;
    BOOL isOpen;
}
@property (nonatomic, strong)    UIImage *backgroundImage;
@property (nonatomic, strong)    LZXDooleView *doodleview;
@property (nonatomic, strong)    LZXCommandBtn *customBtn;
@property (nonatomic, strong)    UIButton *addButton;
@property (nonatomic, strong)    LZXCanvasBar     *canvasBar;
@property (nonatomic, strong)    UIPopoverController *popover;
@property (nonatomic, strong)    LZXBrowserTabView  * tabController;

- (void) loadCanvasBarWithGenerator:(LZXCanvasViewGenerator *)generator;

- (void) showCommentView:(NSString *)comment webImage:(UIImage *)image;

@end
