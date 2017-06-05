
//
//  ViewController.m
//  iOS-gesture
//
//  Created by 🍎应俊杰🍎 doublej on 2017/6/2.
//  Copyright © 2017年 doublej. All rights reserved.
//
#ifdef DEBUG
#   define YJJLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define YJJLog(...)
#endif
#define SYSTEMWINDOW [UIApplication sharedApplication].keyWindow
#define Screen_Width ([UIScreen mainScreen].bounds.size.width)
#define PI 3.1415926
#define Screen_Height ([UIScreen mainScreen].bounds.size.height)
#define MAPCENTER CGPointMake(SYSTEMWINDOW.center.x, SYSTEMWINDOW.center.y-64)
#define RGB_Color(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#import "UILabel+LabAutoFrame.h"
#import "ViewController.h"
#import "JSON.h"
@interface ViewController ()
{
    NSMutableArray *muArr;//文字区域坐标数组
    NSMutableArray *labMutArr;//单元块文字区
    UIWebView * mapView;
    UIView    * mapBaseView;
    int sVGWidth;
    UIPinchGestureRecognizer *pinchGestureRecognizer;

}
@property(nonatomic,strong)UITapGestureRecognizer* tapGestureRecognizer;
@property(nonatomic,assign)CGPoint iconPoint;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    muArr     = [[NSMutableArray alloc]init];//单元块坐标数组
    labMutArr = [[NSMutableArray alloc]init];//单元块文字区
    self.view.backgroundColor = [UIColor whiteColor];
    mapBaseView = [[UIView alloc]init];
    mapBaseView.frame = CGRectMake(0,0, 1276,1371);
    [self.view addSubview:mapBaseView];
    self.iconPoint   = mapBaseView.frame.origin;
    mapBaseView.backgroundColor = [UIColor orangeColor];
    //map单元块数据
    NSString *pathaa = [[NSBundle mainBundle] pathForResource:@"testa" ofType:@"txt"];
    NSString *strContentaa = [NSString stringWithContentsOfFile:pathaa
                                                       encoding:NSUTF8StringEncoding error:nil];
    NSArray *arraa        = [strContentaa JSONValue];
    [self nameJsonLabArr:arraa];
    
    //缩放手势
    pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                       action:@selector(handlePinch:)];
    pinchGestureRecognizer.delegate = self;
    [mapBaseView addGestureRecognizer:pinchGestureRecognizer];
    //旋转手势
    UIRotationGestureRecognizer *rotateRecognizer;
    rotateRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(handleRotate:)];
    [mapBaseView addGestureRecognizer:rotateRecognizer];
    rotateRecognizer.delegate = self;
    //拖拽手势
    UIPanGestureRecognizer *panGestureRecognizer;
    panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                  action:@selector(handlePan:)];
    [mapBaseView addGestureRecognizer:panGestureRecognizer];
    mapBaseView.userInteractionEnabled = YES;
    CGRect scareFrame = mapBaseView.frame;
    CGFloat wScare    = Screen_Width/scareFrame.size.width;
    pinchGestureRecognizer.scale = wScare;
    [self handlePinch:pinchGestureRecognizer];
    mapBaseView.center = MAPCENTER;
    mapBaseView.center = self.view.center;
}

#pragma mark - 地图单元数据加载
-(void)nameJsonLabArr:(NSArray*)labNameArr
{
    if (muArr.count>0) {
        [muArr removeAllObjects];
    }
    for (int i =0;i<labNameArr.count;i++) {
        
        NSDictionary *dica = [labNameArr objectAtIndex:i];
        NSString *name = [dica objectForKey:@"name"];
        NSString *xx = [dica objectForKey:@"x"];
        NSString *yy = [dica objectForKey:@"y"];
        NSString *ww = [dica objectForKey:@"w"];
        NSString *hh = [dica objectForKey:@"h"];
        NSString* x1 = [NSString stringWithFormat:@"%i",[xx intValue]-8];
        NSString* y1 = [NSString stringWithFormat:@"%i",[yy intValue]-8];
        NSString* x2 = [NSString stringWithFormat:@"%i",[xx intValue]+[ww intValue]+8];
        NSString* y2 = [NSString stringWithFormat:@"%i",[yy intValue]-8];
        NSString* x3 = [NSString stringWithFormat:@"%i",[xx intValue]+[ww intValue]-8];
        NSString* y3 = [NSString stringWithFormat:@"%i",[yy intValue]+[hh intValue]+8];
        NSString* x4 = [NSString stringWithFormat:@"%i",[xx intValue]+8];
        NSString* y4 = [NSString stringWithFormat:@"%i",[yy intValue]+[hh intValue]+8];
        NSArray *arr1 = [[NSArray alloc]initWithObjects:x1,y1,x2,y2,x3,y3,x4,y4,name,nil];
        UILabel *labb = [[UILabel alloc]init];
        labb.backgroundColor = [UIColor whiteColor];
        labb.layer.masksToBounds = YES;
        labb.layer.cornerRadius  = 3;
        labb.textColor = [UIColor blackColor];
        CALayer *layer = [labb layer];
        layer.borderColor = RGB_Color(136, 136, 136, 1).CGColor;
        layer.borderWidth = 1;
        [mapBaseView addSubview:labb];
        labb.tag = i;
        labb.font = [UIFont systemFontOfSize:15];
        labb.text = [name substringFromIndex:6];
        labb.textAlignment = NSTextAlignmentCenter;
        [labb setWidthWithString:[NSString stringWithFormat:@"%@ ",labb.text]];
        labb.frame = CGRectMake(([x1 intValue]+[x2 intValue]-labb.frame.size.width)/2, ([y1 intValue]+[y3 intValue]-20)/2, labb.frame.size.width, 15);
        [muArr addObject:arr1];
        [labMutArr addObject:labb];
    }
}

#pragma mark - 地图手势
- (void)handlePan:(UIPanGestureRecognizer*) recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self.view];
}

- (void) handlePinch:(UIPinchGestureRecognizer*) recognizer
{
    mapBaseView.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    for (int i=0; i<labMutArr.count; i++) {//使文字区域在地图缩放时大小不变
        UILabel *labb = [labMutArr objectAtIndex:i];
        labb.transform = CGAffineTransformScale(labb.transform,
                                                1/recognizer.scale,1/recognizer.scale);
    }
    [self recognizerUPdate:recognizer andType:1];
    recognizer.scale = 1;
}

- (void) handleRotate:(UIRotationGestureRecognizer*) recognizer
{
    mapBaseView.transform = CGAffineTransformRotate(mapBaseView.transform, recognizer.rotation);
    if (labMutArr.count>0){//使文字区域在地图旋转时保持水平
            for (int i=0; i<labMutArr.count; i++) {
                UILabel *labb = [labMutArr objectAtIndex:i];
                labb.transform = CGAffineTransformRotate(labb.transform, -recognizer.rotation);
            }
        }
    [self recognizerUPdate:recognizer andType:2];
    recognizer.rotation = 0;
}

#pragma mark - 实时跟新地图手势中心点
- (void)recognizerUPdate:(id) recognizera andType:(int)type
{
    UIPinchGestureRecognizer *recognizer;
    if (type==1){
        recognizer = recognizera;
    }else{
        recognizer = recognizera;
    }
    if (recognizer.numberOfTouches==2) {
        CGPoint onoPoint = [recognizer locationOfTouch:0 inView:recognizer.view];
        CGPoint twoPoint = [recognizer locationOfTouch:1 inView:recognizer.view];
        CGPoint anchorPoint;
        anchorPoint.x = (onoPoint.x + twoPoint.x) / 2 / recognizer.view.bounds.size.width;
        anchorPoint.y = (onoPoint.y + twoPoint.y) / 2 / recognizer.view.bounds.size.height;
        [self setAnchorPoint:anchorPoint forView:recognizer.view];
    }
}

#pragma mark - 设立旋转中心点
- (void)setDefaultAnchorPointforView:(UIView *)view
{
    [self setAnchorPoint:CGPointMake(0.5f, 0.5f) forView:view];
}

#pragma mark -旋转中心点计算
- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint oldOrigin      = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin      = view.frame.origin;
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}

//设置多手势支持
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer: (UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
