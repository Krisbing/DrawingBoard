//
//  LZXCanvasBar.h
//  lexue
//
//  Created by songjie on 13-4-12.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZXObject.h"
#import "ACEDrawingView.h"
#import "LZXCommandBtn.h"
#import "LZXToolPopoverController.h"
#import "LZXBrowserTabView.h"

#define kToolMargin 50
#define kBtnMargin 4


@interface LZXCanvasBar : UIImageView<UIActionSheetDelegate>
{
   // UIView *colorPtch; //选中的颜色视图
    ACEDrawingView *canvasView;
    NSMutableArray *saveHistoryArray;
    LZXToolPopoverController     *toolPopoverController;
    LZXEraserPopoverController *eraserPopoverController;
    UIActionSheet * assistActionSheet;
    LZXCommandBtn *changeBtn;
    LZXCommandBtn *recordBtn;
    LZXCommandBtn *undoBtn;
    LZXCommandBtn *redoBtn;
    LZXCommandBtn *deleateBtn;
    LZXCommandBtn *saveBtn;
    LZXCommandBtn *assistBtn;
    NSMutableArray *buttonArray;
    UIView *vgView;
}
@property (nonatomic,strong) UIColor  *penColor;
@property (nonatomic,strong) NSMutableArray *buttonArray;
@property (nonatomic,strong) ACEDrawingView *canvasView;
@property (nonatomic,strong) LZXBrowserTabView *browserTabView;
@property (nonatomic,strong) LZXCommandBtn *undoBtn;
@property (nonatomic,strong) LZXCommandBtn *redoBtn;
@property (nonatomic,strong) LZXCommandBtn *changeBtn;


@property (nonatomic,strong) UIActionSheet * assistActionSheet;
@property (nonatomic,strong) LZXCommandBtn *assistBtn;

- (void) initFeedbackBtn;
- (void)verifyTypeWithBtn:(LZXToolButton *)barBtn;
- (void) showToolPopoverWithObj:(LZXToolButton *)button;
- (ACEDrawingToolType)restoreCurrentToolType;

@end
