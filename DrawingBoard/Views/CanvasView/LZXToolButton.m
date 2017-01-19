//
//  LZXToolButton.m
//  lexue
//
//  Created by songjie on 13-4-17.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import "LZXToolButton.h"
#import <QuartzCore/QuartzCore.h>
#import "LZXObject.h"

@implementation LZXToolButton
@synthesize toolType;
@synthesize sizeLable;
@synthesize fontSize  = _fontSize;
@synthesize spacingSize = _spacingSize;
@synthesize savedColor = _savedColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setShowsTouchWhenHighlighted:YES];
        sizeLable = [[UILabel alloc] initWithFrame:CGRectMake(22, 21, 15, 15)];
        sizeLable.layer.cornerRadius = 3.0;
        sizeLable.textColor = [UIColor orangeColor];
        sizeLable.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
        sizeLable.textAlignment = NSTextAlignmentCenter;
        sizeLable.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4f];
        [self addSubview:sizeLable];
        
        [self becomeFirstResponder];//首先让自己变成第一响应
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
        longPress.minimumPressDuration = 0.5; //定义按的时间
        [self addGestureRecognizer:longPress];

    }
    return self;
}
-(void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
         NSLog(@"%@",gestureRecognizer.view);
        
        [self sendObject:gestureRecognizer.view];
    }
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    return YES;
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
