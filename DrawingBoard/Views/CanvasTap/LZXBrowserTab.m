//
//  LZXBrowserTab.m
//  lexue
//
//  Created by songjie on 13-4-22.
//  Copyright (c) 2013年 lezhixing. All rights reserved.
//

#import "LZXBrowserTab.h"
//define width of a tab ,here is the width of the image used to render tab;
//#define TAB_WIDTH 154
#define TAB_WIDTH (kMainScreenWidth - 64 - 35/*colse width*/) / [ delegate.tabsArray count]
#define TAB_HEIGHT 40

@interface LZXBrowserTab ()
{
   // CALayer *tapSelectedLayer;
    CALayer *tapLayer;
}

@end

@implementation LZXBrowserTab
@synthesize title;
@synthesize titleFont;
@synthesize selected=_selected;
@synthesize tabNormalImage;
@synthesize tabSelectedImage;
@synthesize normalTitleColor;
@synthesize selectedTitleColor;
@synthesize reuseIdentifier;
@synthesize imageView;
@synthesize imageViewClose;
@synthesize textLabel;
@synthesize index;
@synthesize delegate;

#pragma mark -
#pragma mark init
-(id)initWithReuseIdentifier:(NSString *)aReuseIdentifier andDelegate:(id)aDelegate
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        delegate = aDelegate;
       
        reuseIdentifier = aReuseIdentifier;
        self.normalTitleColor = [UIColor whiteColor];
        self.selectedTitleColor = [UIColor blackColor];
        
        self.tabSelectedImage = [UIImage imageNamed:@"tab_selected.png"];
        self.tabNormalImage = [UIImage imageNamed:@"tab_normal.png"] ;
        

        self.titleFont = [UIFont systemFontOfSize:18];
        
        //tap 底视图
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView];
        //选择
        tapLayer = [CALayer layer];
        tapLayer.backgroundColor = [UIColor clearColor].CGColor;
        tapLayer.shadowOffset = CGSizeMake(0, 2);
        tapLayer.shadowRadius = 5.0;
        tapLayer.shadowOpacity = 0.8;
        tapLayer.shadowColor = [UIColor blackColor].CGColor;
        tapLayer.borderColor =[[UIColor blackColor]colorWithAlphaComponent:0.2f].CGColor;
        tapLayer.borderWidth = 1.0;
        tapLayer.masksToBounds = NO;
        [imageView.layer addSublayer:tapLayer];
        
        //tap 上的标签
        textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
        self.textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:textLabel];
        
        //关闭按钮
        UIImage *closeImageNormal = [UIImage imageNamed:@"tab_close.png"];
        imageViewClose = [[UIButton alloc] initWithFrame:self.bounds];
        self.imageViewClose.backgroundColor = [UIColor clearColor];
        [imageViewClose setImage:closeImageNormal forState:UIControlStateNormal];
        imageViewClose.hidden = YES;
        [imageViewClose addTarget:self action:@selector(closetap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:imageViewClose];
        
        //滑动手势
        panGuesture = [[UIPanGestureRecognizer alloc] initWithTarget:delegate
                                                              action:@selector(handlePanGuesture:)];
        //panGuesture.delegate = delegate;
        [self addGestureRecognizer:panGuesture];
        //
        [self setSelected:YES];

    }
    return self;
}

-(void)setSelected:(BOOL)isSelected
{
    _selected = isSelected;
    //没啥用的处理逻辑
    if (isSelected) {
        self.textLabel.textColor = selectedTitleColor;
//        imageView.image = self.tabSelectedImage;
        //imageView.backgroundColor = [UIColor orangeColor];
        tapLayer.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2f].CGColor;
        if (self.delegate.numberOfTabs>1) {
            imageViewClose.hidden = NO;
        }else{
            imageViewClose.hidden = YES;
        }
        
    }else{
        self.textLabel.textColor = normalTitleColor;
       // imageView.image = self.tabNormalImage;
        //imageView.backgroundColor = [UIColor brownColor];
        tapLayer.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.2f].CGColor;
        imageViewClose.hidden = YES;
    }
}
-(void)prepareForReuse
{
    self.textLabel.text = nil;
    self.index = 0;
    self.delegate = nil;
    _selected = NO;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 
 }
 */

-(void)layoutSubviews
{
    title = self.textLabel.text;
    CGSize titleSize = [title sizeWithFont:titleFont];
    imageView.frame = self.bounds;
    tapLayer.frame = self.bounds;
//    self.textLabel.backgroundColor = [UIColor yellowColor];
    self.textLabel.frame = CGRectMake((self.bounds.size.width - titleSize.width)/2 , (self.bounds.size.height - titleSize.height)/2, titleSize.width,titleSize.height);
//    imageViewClose.backgroundColor = [UIColor redColor];
   imageViewClose.frame =  CGRectMake(self.bounds.origin.x + self.bounds.size.width - 26, self.bounds.origin.y + 3, 25, 25);
   
    
    [super layoutSubviews];
}


#pragma mark -
#pragma mark - TouchEvent

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setSelected:YES];
    [self.delegate setSelectedTabIndex:self.index animated:NO];
    
    
}

- (void)closetap:(id)sender
{
      [self.delegate removeTabAtIndex:self.index animated:YES];
}
@end
