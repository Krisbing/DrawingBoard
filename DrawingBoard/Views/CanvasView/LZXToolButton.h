//
//  LZXToolButton.h
//  lexue
//
//  Created by songjie on 13-4-17.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {    
    LZXPen,                //钢笔
    LZXfluorescencePen,    //荧光笔
    LZXRoundness,          //圆形
    LZXRectangle,          //矩形
    LZXLine,               //直线
    LZXTextVIew,           //批注
    LZXEraser ,             //橡皮
    LZXScrawlImage      //图片
    
} LZXTooltype;

@interface LZXToolButton : UIButton

@property (nonatomic, strong) UILabel *sizeLable;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat spacingSize;
@property (nonatomic, assign) LZXTooltype toolType;
@property (nonatomic, strong) UIColor* savedColor;

@end
