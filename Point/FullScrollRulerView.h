//
//  FullScrollRulerView.h
//  AbellStar_Light
//
//  Created by apple on 2018/4/27.
//  Copyright © 2018年 xjc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FullScrollRulerView;

@protocol FullScrollRulerDelegate <NSObject>

-(void)jcScrollRulerView:(FullScrollRulerView *)rulerview valueChange:(float)value;

@end

@interface FullScrollRulerView : UIView

@property (nonatomic, weak) id <FullScrollRulerDelegate> delegate;

@property (nonatomic, strong) UIColor *trianingleColor;

@property (nonatomic, strong) UIColor *bgColor;


-(instancetype)initWithFrame:(CGRect)frame
                 theMinValue:(float)minValue
                 theMaxValue:(float)maxValue
                     theStep:(float)step
                     theUnit:(NSString *)unit
                      theNum:(NSInteger)betweenNum
                     timearr:(NSMutableArray *)timesarr;

-(void)setRealValue:(float)realValue animated:(BOOL)animated;

+(CGFloat)rulerViewHeight;

-(void)setDefaultValue:(float)defaultValue animated:(BOOL)animated;

@end
