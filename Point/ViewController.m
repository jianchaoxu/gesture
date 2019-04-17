//
//  ViewController.m
//  Point
//
//  Created by 许健超 on 2019/4/15.
//  Copyright © 2019年 Abellstar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    int time;
    UIView *a1, *a2, *a3, *a4;
    CAShapeLayer *layer;
}
@property (nonatomic, strong) CAShapeLayer *lineLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self test2];
}

-(void)test2
{
    a1 = [[UIView alloc]initWithFrame:CGRectMake(20, 100, 10, 10)];
    a1.layer.cornerRadius = 5;
    a1.backgroundColor = [UIColor redColor];
    [self.view addSubview:a1];
    
    a2 = [[UIView alloc]initWithFrame:CGRectMake(220, 220, 10, 10)];
    a2.layer.cornerRadius = 5;
    a2.backgroundColor = [UIColor blueColor];
    [self.view addSubview:a2];
    
    a3 = [[UIView alloc]initWithFrame:CGRectMake(260, 420, 10, 10)];
    a3.layer.cornerRadius = 5;
    a3.backgroundColor = [UIColor blackColor];
    [self.view addSubview:a3];
    
    a4 = [[UIView alloc]initWithFrame:CGRectMake(40, 250, 10, 10)];
    a4.layer.cornerRadius = 5;
    a4.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:a4];
    
    UIBezierPath *bz = [UIBezierPath bezierPath];
    [bz moveToPoint:a1.center];
    [bz addLineToPoint:a2.center];
    [bz addLineToPoint:a3.center];
    [bz addLineToPoint:a4.center];
    [bz closePath];
    
    layer = [CAShapeLayer layer];
    layer.lineWidth = 2.0f;
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.path = bz.CGPath;
    layer.fillColor = [UIColor colorWithWhite:0.5 alpha:0.4].CGColor;
    [self.view.layer addSublayer:layer];
    
    UIPanGestureRecognizer *pangest = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGest:)];
    [a1 addGestureRecognizer:pangest];
    
    UIPanGestureRecognizer *pangest2 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGest:)];
    [a2 addGestureRecognizer:pangest2];
    
    UIPanGestureRecognizer *pangest3 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGest:)];
    [a3 addGestureRecognizer:pangest3];
    
    UIPanGestureRecognizer *pangest4 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGest:)];
    [a4 addGestureRecognizer:pangest4];
}


-(void)panGest:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint newCenter = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    
    if ([recognizer.view isEqual:a1]) {
        newCenter.y = MAX(recognizer.view.frame.size.height/2, newCenter.y);
        newCenter.y = MIN(a4.center.y - recognizer.view.frame.size.height, newCenter.y);
        newCenter.x = MAX(recognizer.view.frame.size.width/2, newCenter.x);
        newCenter.x = MIN(a2.center.x - recognizer.view.frame.size.width,newCenter.x);
    } else if ([recognizer.view isEqual:a2]) {
        newCenter.y = MAX(recognizer.view.frame.size.height/2, newCenter.y);
        newCenter.y = MIN(a3.center.y - recognizer.view.frame.size.height, newCenter.y);
        newCenter.x = MAX(a1.center.x + recognizer.view.frame.size.width, newCenter.x);
        newCenter.x = MIN(self.view.frame.size.width - recognizer.view.frame.size.width,newCenter.x);
    } else if ([recognizer.view isEqual:a3]) {
        newCenter.y = MAX(a2.center.y + recognizer.view.frame.size.height, newCenter.y);
        newCenter.y = MIN(self.view.frame.size.height - recognizer.view.frame.size.height, newCenter.y);
        newCenter.x = MAX(a4.center.x + recognizer.view.frame.size.width, newCenter.x);
        newCenter.x = MIN(self.view.frame.size.width - recognizer.view.frame.size.width,newCenter.x);
    } else if ([recognizer.view isEqual:a4]) {
        newCenter.y = MAX(a1.center.y + recognizer.view.frame.size.height, newCenter.y);
        newCenter.y = MIN(self.view.frame.size.height - recognizer.view.frame.size.height, newCenter.y);
        newCenter.x = MAX(recognizer.view.frame.size.width/2, newCenter.x);
        newCenter.x = MIN(a3.center.x - recognizer.view.frame.size.width, newCenter.x);
    }
    
    /*
    // 限制屏幕范围：
    newCenter.y = MAX(recognizer.view.frame.size.height/2, newCenter.y);
    newCenter.y = MIN(self.view.frame.size.height - recognizer.view.frame.size.height/2, newCenter.y);
    newCenter.x = MAX(recognizer.view.frame.size.width/2, newCenter.x);
    newCenter.x = MIN(self.view.frame.size.width - recognizer.view.frame.size.width/2,newCenter.x);
    */
    
    recognizer.view.center = newCenter;
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            [layer removeFromSuperlayer];
            break;
        case UIGestureRecognizerStateEnded: {
            UIBezierPath *bz = [UIBezierPath bezierPath];
            [bz moveToPoint:a1.center];
            [bz addLineToPoint:a2.center];
            [bz addLineToPoint:a3.center];
            [bz addLineToPoint:a4.center];
            [bz closePath];
            
            layer = [CAShapeLayer layer];
            layer.lineWidth = 2.0f;
            layer.strokeColor = [UIColor greenColor].CGColor;
            layer.path = bz.CGPath;
            layer.fillColor = [UIColor colorWithWhite:0.2 alpha:0.1].CGColor;
            [self.view.layer addSublayer:layer];
        }
            break;
        default:
            break;
    }
}

@end
