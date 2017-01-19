//
//  NEOColorPickerBaseViewController.h
//
//  Created by Karthik Abram on 10/23/12.
//  Copyright (c) 2012 Neovera Inc.
//

/*
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/


#define NEOColorPicker4InchDisplay()  [UIScreen mainScreen].bounds.size.height == 568

//添加最喜欢的颜色
@interface NEOColorPickerFavoritesManager : NSObject

@property (readonly, nonatomic, strong) NSOrderedSet *favoriteColors;

+ (NEOColorPickerFavoritesManager *) instance;

- (void) addFavorite:(UIColor *)color;


@end


@interface NEOColorPickerBaseView : UIView

//@property (nonatomic, weak) id <NEOColorPickerViewDelegate> delegate;

@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, assign) BOOL disallowOpacitySelection;
@property (nonatomic, strong) NSString* selectedColorText;

- (void) setupShadow:(CALayer *)layer;

@end
