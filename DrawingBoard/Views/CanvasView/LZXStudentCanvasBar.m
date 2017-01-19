//
//  LZXStudentCanvasBar.m
//  lexue
//
//  Created by songjie on 13-4-12.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import "LZXStudentCanvasBar.h"
#import <QuartzCore/QuartzCore.h>

@implementation LZXStudentCanvasBar
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *backgroundImage = [UIImage imageNamed:@"切换背景.png"];
        changeBtn.frame = CGRectMake(vgView.frame.origin.x + vgView.frame.size.width + 80, 10, backgroundImage.size.width, backgroundImage.size.height);

    }
    return self;
}
//查看历史记录
- (void)buttonClick:(UIButton *)sender{
    [self sendObject:sender];
}
- (void)initFeedbackBtn
{
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.backgroundColor=[UIColor colorWithRed:58.0/255 green:158.0/255 blue:33.0/255 alpha:1.0];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.frame = CGRectMake(5 + 20, 5, 50, 40);
    [submitButton.layer setMasksToBounds:YES];
    submitButton.layer.cornerRadius=4.0;
    [self addSubview:submitButton];
    //关闭
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.backgroundColor=[UIColor colorWithRed:58.0/255 green:158.0/255 blue:33.0/255 alpha:1.0];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame = CGRectMake(submitButton.frame.origin.x + submitButton.frame.size.width + 20 - 5, 5, 50, 40);
    [closeButton.layer setMasksToBounds:YES];
    closeButton.layer.cornerRadius=4.0;
    [self addSubview:closeButton];
}
@end
