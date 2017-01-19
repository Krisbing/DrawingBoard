//
//  NEOColorPickerViewController.h
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
#import "NEOColorPickerBaseView.h"
#import "LZXObject.h"

#import "RSBrightnessSlider.h"
#import "RSColorPickerView.h"

#define kTransitionDuration	0.75

@interface LZXColorPickerView : NEOColorPickerBaseView<RSColorPickerViewDelegate>{
    RSColorPickerView *colorPicker;//选择颜色
	RSBrightnessSlider *brightnessSlider;
    UIView *colorPacthView;
}

@property (nonatomic, strong)  UIView   *simpleColorGrid;
@property (nonatomic, strong)  UIButton *buttonHue;
@property (nonatomic, strong)  UILabel  *selectedColorLabel;
@property (nonatomic, strong)  NSString *favoritesTitle;

- (void)creatColorView;
- (UIView *)creatFreeColorView;
- (void)colorChangeAction:(id)sender;
- (void)updateSelectedColor:(UIColor *)selectedColor;
@end
