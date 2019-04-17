//
//  FullScrollRulerView.m
//  AbellStar_Light
//
//  Created by apple on 2018/4/27.
//  Copyright © 2018年 xjc. All rights reserved.
//

#define TextColorGrayAlpha 1.0 //文字的颜色灰度
#define TextRulerFont  [UIFont systemFontOfSize:8]

#define RulerGap         3 //单位距离
#define RulerLong        30
#define RulerShort       20
#define TrangleWidth     8
#define CollectionHeight 40
#define UIColorHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define DEVICE_WIDTH  [UIScreen mainScreen].bounds.size.width

#import "FullScrollRulerView.h"

@interface FullJCTriangleView : UIView

@end

@implementation FullJCTriangleView
-(void)drawRect:(CGRect)rect
{
    [[UIColor clearColor] set]; //设置背景颜色
    UIRectFill([self bounds]);//拿到当前视图准备好的画板
    CGContextRef context = UIGraphicsGetCurrentContext();//利用path路径进行绘制三角形
    CGContextBeginPath(context);//标记
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, TrangleWidth, 0);
    CGContextAddLineToPoint(context, TrangleWidth/2.0, TrangleWidth/2.0);
    
    CGContextMoveToPoint(context,TrangleWidth/2.0, TrangleWidth/2.0);
    CGContextAddLineToPoint(context,TrangleWidth/2.0,CollectionHeight-TrangleWidth/2);
    
    CGContextMoveToPoint(context, TrangleWidth/2.0, CollectionHeight-TrangleWidth/2);
    CGContextAddLineToPoint(context, TrangleWidth, CollectionHeight);
    CGContextAddLineToPoint(context, 0, CollectionHeight);
    
    CGContextSetLineCap(context, kCGLineCapButt);//线结束时是否绘制端点，该属性不设置。有方形，圆形，自然结束3中设置
    CGContextSetLineJoin(context, kCGLineJoinBevel);//线交叉时设置缺角。有圆角，尖角，缺角3中设置
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    [UIColorHex(0xfe4d58) setFill];//设置填充色
    [UIColorHex(0xfe4d58) setStroke];//设置边框色
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path，后属性表示填充
}

@end

/********************* JCRulerView **********************************/
@interface FullJCRulerView : UIView
@property (nonatomic, assign)NSInteger betweenNumber;
@property (nonatomic, assign)int minValue;
@property (nonatomic, assign)int maxValue;
@property (nonatomic, copy)NSString *unit;
@property (nonatomic, assign)CGFloat step;
@property (nonatomic, strong) NSMutableArray *timesarr;

@end

@implementation FullJCRulerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGFloat startX      = 0;
    CGFloat lineCenterX = RulerGap;
    CGFloat shortLineY  = rect.size.height * 2 / 3;
    CGFloat longLineY   = rect.size.height - 10; //- RulerShort;
    CGFloat topY        = rect.size.height / 3;
    float w = RulerGap * _betweenNumber;
    
    //矩形
    for (int i = 0; i<_timesarr.count; i++) {
        NSNumber *nn = _timesarr[i];
        float ms = [nn floatValue] - [nn intValue];
        if (ms >0) {
            CGMutablePathRef path = CGPathCreateMutable();//创建路径并获取句柄
            CGRect rectangle = CGRectMake(w * ms, 0.0f, 1.0f, longLineY);//指定矩形
            CGPathAddRect(path,NULL, rectangle);    //将矩形添加到路径中
            CGContextRef currentContext = UIGraphicsGetCurrentContext();  //获取上下文
            CGContextAddPath(currentContext, path);  //将路径添加到上下文
            [UIColorHex(0x3e7e86) setFill];   //设置矩形填充色
            [UIColorHex(0x3e7e86) setStroke]; //矩形边框颜色
            CGContextSetLineWidth(currentContext,1.0f);//边框宽度
            CGContextDrawPath(currentContext, kCGPathFillStroke);//绘制
            CGPathRelease(path);
        }
    }
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);//设置线的宽度，
    CGContextSetLineCap(context,kCGLineCapButt);
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.5);//设置线的颜色，默认是黑色
    
    for (int i = 0; i <= _betweenNumber; i ++) {
        if (i%_betweenNumber == 0) {
            CGContextMoveToPoint(context, startX+lineCenterX*i, 0);
            NSString *num = [NSString stringWithFormat:@"%.f%@",i*_step+_minValue,_unit];
            if ([num floatValue] > 1000000) {
                num = [NSString stringWithFormat:@"%.f万%@",[num floatValue]/10000.f,_unit];
            }
            
            NSDictionary *attribute = @{
                                        NSFontAttributeName:TextRulerFont,
                                        NSForegroundColorAttributeName:UIColorHex(0xdddddd)
                                        };
            CGFloat width = [num boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size.width;
            [num drawInRect:CGRectMake(startX+lineCenterX*i-width/2, longLineY, width, 10) withAttributes:attribute];
            CGContextAddLineToPoint(context, startX+lineCenterX*i, longLineY);
        } else {
            CGContextMoveToPoint(context, startX+lineCenterX*i, topY);
            CGContextAddLineToPoint(context, startX+lineCenterX*i, shortLineY);
        }
        CGContextStrokePath(context);//开始绘制
    }
}
@end

/*********************** JCHeaderRulerView **********************************/
@interface FullJCHeaderRulerView : UIView
@property (nonatomic, assign) int minValue;
@property (nonatomic, copy) NSString *unit;
@end

@implementation FullJCHeaderRulerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor  =  [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGFloat longLineY = rect.size.height - 10; //- RulerShort;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineCap(context, kCGLineCapButt);
    
    CGContextMoveToPoint(context, rect.size.width, 0);
    NSString *num = [NSString stringWithFormat:@"%d%@",_minValue,_unit];
    //DLog(@"header ruler view num = %@",num);
    if ([num floatValue] > 1000000) {
        num = [NSString stringWithFormat:@"%.f万%@",[num floatValue]/10000.f,_unit];
    }
    
    NSDictionary *attribute = @{
                                NSFontAttributeName:TextRulerFont,
                                NSForegroundColorAttributeName:UIColorHex(0xdddddd)
                                };
    CGFloat width = [num boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size.width;
    [num drawInRect:CGRectMake(rect.size.width-width/2, longLineY, width, 10) withAttributes:attribute];
    CGContextAddLineToPoint(context,rect.size.width, longLineY);
    CGContextStrokePath(context);//开始绘制
}
@end

/************************* JCFooterRulerView ********************************/
@interface FullJCFooterRulerView : UIView
@property (nonatomic, assign)int maxValue;
@property (nonatomic,  copy)NSString *unit;
@end

@implementation FullJCFooterRulerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor  =  [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGFloat longLineY = rect.size.height - 10; //- RulerShort;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineCap(context, kCGLineCapButt);
    
    CGContextMoveToPoint(context, 0, 0);//起始点
    NSString *num = [NSString stringWithFormat:@"%d%@",_maxValue,_unit];
    NSLog(@"footer ruler view num = %@",num);
    if ([num floatValue] > 1000000) {
        num = [NSString stringWithFormat:@"%.f万%@",[num floatValue]/10000.f,_unit];
    }
    NSDictionary *attribute = @{
                                NSFontAttributeName:TextRulerFont,
                                NSForegroundColorAttributeName:UIColorHex(0xdddddd)
                                };
    CGFloat width = [num boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size.width;
    [num drawInRect:CGRectMake(0 - width/2, longLineY, width, 10) withAttributes:attribute];
    CGContextAddLineToPoint(context, 0, longLineY);
    CGContextStrokePath(context);//开始绘制
}
@end

/*********************** JCScrollRulerView **********************************/
static NSString *firstcell  = @"JCHeaderRulerView";
static NSString *lastcell   = @"JCFooterRulerView";
static NSString *normalcell = @"JCRulerView";

@interface FullScrollRulerView ()<UIScrollViewDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) FullJCTriangleView   *triangle;
@property (nonatomic, assign) float            realValue;
@property (nonatomic, copy)   NSString         *unit;//单位
@property (nonatomic, assign) float            stepNum;//分多少个区
@property (nonatomic, assign) float            minValue;//游标的最小值
@property (nonatomic, assign) float            maxValue;//游标的最大值
@property (nonatomic, assign) float            step;//间隔值，每两条相隔多少值
@property (nonatomic, assign) NSInteger        betweenNum;
@property (nonatomic, strong) NSMutableArray   *timesArr;
@end

@implementation FullScrollRulerView

-(instancetype)initWithFrame:(CGRect)frame
                 theMinValue:(float)minValue
                 theMaxValue:(float)maxValue
                     theStep:(float)step
                     theUnit:(NSString *)unit
                      theNum:(NSInteger)betweenNum
                     timearr:(NSMutableArray *)timesarr
{
    self = [super initWithFrame:frame];
    if (self) {
        _minValue   = minValue;
        _maxValue   = maxValue;
        _step       = step;
        _stepNum    = (_maxValue-_minValue)/_step/betweenNum;
        _unit       = unit;
        _betweenNum = betweenNum;
        _timesArr   = timesarr;
        _bgColor    = [UIColor clearColor];
        self.backgroundColor    = [UIColor clearColor];
        [self addSubview:self.collectionView];
        [self addSubview:self.triangle];
    }
    return self;
}

-(FullJCTriangleView *)triangle
{
    if (!_triangle) {
        _triangle = [[FullJCTriangleView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2 - 0.5 - TrangleWidth/2, 0, TrangleWidth, CollectionHeight)];
        _triangle.backgroundColor   = [UIColor clearColor];
    }
    return _triangle;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, CollectionHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = _bgColor;
        _collectionView.bounces         = YES;
        _collectionView.showsHorizontalScrollIndicator  = NO;
        _collectionView.showsVerticalScrollIndicator    = NO;
        _collectionView.dataSource      = self;
        _collectionView.delegate        = self;
        _collectionView.contentSize     = CGSizeMake(_stepNum * _step + DEVICE_WIDTH/2, CollectionHeight);
        
        NSArray *arr = @[firstcell,lastcell,normalcell];
        for (int i = 0; i < arr.count; i ++) {
            [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:arr[i]];
        }
    }
    return _collectionView;
}

-(void)setBgColor:(UIColor *)bgColor
{
    _bgColor = bgColor;
    _collectionView.backgroundColor = _bgColor;
}

-(void)setRealValue:(float)realValue
{
    [self setRealValue:realValue animated:NO];
}

-(void)setRealValue:(float)realValue animated:(BOOL)animated
{
    _realValue      = realValue;
    [_collectionView setContentOffset:CGPointMake((int)realValue*RulerGap, 0) animated:animated];
}

+(CGFloat)rulerViewHeight
{
    return 5 + CollectionHeight;
}

-(void)setDefaultValue:(float)defaultValue animated:(BOOL)animated
{
    _realValue = defaultValue;
    [_collectionView setContentOffset:CGPointMake(((defaultValue-_minValue)/(float)_step)*RulerGap, 0) animated:animated];
}

#pragma mark UICollectionViewDataSource & Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2 + _stepNum;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:firstcell forIndexPath:indexPath];
        FullJCHeaderRulerView *headerView = [cell.contentView viewWithTag:2000];
        if (!headerView) {
            headerView = [[FullJCHeaderRulerView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, CollectionHeight)];
            headerView.tag              =  2000;
            headerView.minValue         = _minValue;
            headerView.unit             = _unit;
            [cell.contentView addSubview:headerView];
        }
        return cell;
    } else if (indexPath.item == _stepNum +1) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lastcell forIndexPath:indexPath];
        FullJCFooterRulerView *footerView = [cell.contentView viewWithTag:2001];
        if (!footerView){
            footerView = [[FullJCFooterRulerView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, CollectionHeight)];
            footerView.tag              = 2001;
            footerView.maxValue         = _maxValue;
            footerView.unit             = _unit;
            [cell.contentView addSubview:footerView];
        }
        return cell;
    } else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:normalcell forIndexPath:indexPath];
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        FullJCRulerView *rulerView = [cell.contentView viewWithTag:2002];
        if (!rulerView){
            rulerView  = [[FullJCRulerView alloc]initWithFrame:CGRectMake(0, 0, RulerGap * _betweenNum, CollectionHeight)];
            rulerView.tag               = 2002;
            rulerView.step              = _step;
            rulerView.unit              = _unit;
            rulerView.betweenNumber     = _betweenNum;
            rulerView.timesarr          = _timesArr[indexPath.item-1];
            [cell.contentView addSubview:rulerView];
        }
        rulerView.minValue = _step*(indexPath.item-1)*_betweenNum+_minValue;
        rulerView.maxValue = _step*indexPath.item*_betweenNum;
        [rulerView setNeedsDisplay];
        return cell;
    }
}

-(CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0 || indexPath.item == _stepNum + 1)
        return CGSizeMake(self.frame.size.width/2, CollectionHeight);
    else
        return CGSizeMake(RulerGap * _betweenNum, CollectionHeight);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

#pragma mark -UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //int value = scrollView.contentOffset.x/RulerGap;
    //float totalValue = value * _step +_minValue;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {//拖拽时没有滑动动画
    if (!decelerate) {
        [self setRealValue:round(scrollView.contentOffset.x/(RulerGap)) animated:YES];
        int value = scrollView.contentOffset.x/RulerGap;
        float totalValue = value * _step +_minValue;
        if (self.delegate && [self.delegate respondsToSelector:@selector(jcScrollRulerView:valueChange:)]) {
            [self.delegate jcScrollRulerView:self valueChange:totalValue];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setRealValue:round(scrollView.contentOffset.x/(RulerGap)) animated:YES];
    int value = scrollView.contentOffset.x/RulerGap;
    float totalValue = value * _step +_minValue;
    if (self.delegate && [self.delegate respondsToSelector:@selector(jcScrollRulerView:valueChange:)]) {
        [self.delegate jcScrollRulerView:self valueChange:totalValue];
    }
}

@end
