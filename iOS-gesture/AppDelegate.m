//
//  AppDelegate.m
//  iOS-gesture
//
//  Created by doublej on 2017/6/2.
//  Copyright © 2017年 doublej. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
/*
 
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
 //    labMutArr = [[NSMutableArray alloc]init];//单元块文字区
 self.view.backgroundColor = [UIColor whiteColor];
 NSString *filePath = [[NSBundle mainBundle]pathForResource:@"b3c" ofType:@"svg"];
 NSData *svgData        = [NSData dataWithContentsOfFile:filePath];
 sVGWidth = 1366;
 //    mapView = [[UIWebView alloc]initWithFrame:CGRectMake(0,0, 1276,1371)];
 //    mapView.backgroundColor = [UIColor redColor];
 //    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
 //    NSURL *baseURL         = [[NSURL alloc] initFileURLWithPath:resourcePath isDirectory:YES];
 //    mapView.scrollView.backgroundColor = [UIColor redColor];
 //    mapView.backgroundColor            = [UIColor orangeColor];
 //
 //    [mapView       loadData:svgData
 //                   MIMEType:@"image/svg+xml"
 //           textEncodingName:@"UTF-8"
 //                    baseURL:baseURL];
 //    mapView.scrollView.scrollEnabled = NO;
 mapBaseView = [[UIView alloc]init];
 mapBaseView.frame = CGRectMake(0,0, 1276,1371);
 mapBaseView.backgroundColor = [UIColor orangeColor];
 [self.view addSubview:mapBaseView];
 //    [mapBaseView addSubview:mapView];
 self.iconPoint   = mapBaseView.frame.origin;
 
 NSString *pathaa = [[NSBundle mainBundle] pathForResource:@"testa" ofType:@"txt"];
 NSString *strContentaa = [NSString stringWithContentsOfFile:pathaa
 encoding:NSUTF8StringEncoding error:nil];
 NSArray *arraa        = [strContentaa JSONValue];
 [self nameJsonLabArr:arraa];
 
 //    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
 //                                                                        action:@selector(handleTapGesture:)];
 //    _tapGestureRecognizer.delegate = self;
 
 [mapBaseView addGestureRecognizer:self.tapGestureRecognizer];
 pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
 action:@selector(handlePinch:)];
 pinchGestureRecognizer.delegate = self;
 [mapBaseView addGestureRecognizer:pinchGestureRecognizer];
 UIRotationGestureRecognizer *rotateRecognizer;
 rotateRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self
 action:@selector(handleRotate:)];
 [mapBaseView addGestureRecognizer:rotateRecognizer];
 rotateRecognizer.delegate = self;
 UIPanGestureRecognizer *panGestureRecognizer;
 panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
 action:@selector(handlePan:)];
 [mapBaseView addGestureRecognizer:panGestureRecognizer];
 mapBaseView.userInteractionEnabled = YES;
 CGRect scareFrame = mapBaseView.frame;
 CGFloat wScare    = Screen_Width/scareFrame.size.width;
 pinchGestureRecognizer.scale = wScare;
 [self handlePinch:pinchGestureRecognizer];
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
 //        [labMutArr addObject:labb];
 labb.tag = i;
 labb.font = [UIFont systemFontOfSize:15];
 labb.text = [name substringFromIndex:6];
 labb.textAlignment = NSTextAlignmentCenter;
 [labb setWidthWithString:[NSString stringWithFormat:@"%@ ",labb.text]];
 labb.frame = CGRectMake(([x1 intValue]+[x2 intValue]-labb.frame.size.width)/2, ([y1 intValue]+[y3 intValue]-20)/2, labb.frame.size.width, 15);
 [muArr addObject:arr1];
 }
 }
 
 #pragma mark - 地图手势
 - (void)handlePan:(UIPanGestureRecognizer*) recognizer
 {
 //        NSLog(@"移动----%f---%f===",_indoorView.frame.size.width,_indoorView.frame.size.height);
 //        NSLog(@"移动%f---%f===",_indoorView.frame.origin.x,_indoorView.frame.origin.y);
 CGPoint translation = [recognizer translationInView:self.view];
 recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
 [recognizer setTranslation:CGPointZero inView:self.view];
 }
 
 - (void) handlePinch:(UIPinchGestureRecognizer*) recognizer
 {
 //        NSLog(@"缩放%f---%f===",_indoorView.frame.size.width,_indoorView.frame.size.height);
 //        NSLog(@"缩放%f---%f===",_indoorView.frame.origin.x,_indoorView.frame.origin.y);
 mapBaseView.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
 
 recognizer.scale = 1;
 }
 
 - (void) handleRotate:(UIRotationGestureRecognizer*) recognizer
 {
 //    NSLog(@"旋转%f---%f===",_indoorView.frame.size.width,_indoorView.frame.size.height);
 //    NSLog(@"旋转%f---%f===",_indoorView.frame.origin.x,_indoorView.frame.origin.y);
 mapBaseView.transform = CGAffineTransformRotate(mapBaseView.transform, recognizer.rotation);
 //    if (labMutArr.count>0){
 //        for (int i=0; i<labMutArr.count; i++) {
 //            UILabel *labb = [labMutArr objectAtIndex:i];
 //            labb.transform = CGAffineTransformRotate(labb.transform, -recognizer.rotation);
 //        }
 //    }
 
 
 if (recognizer.numberOfTouches==2) {
 CGPoint onoPoint = [recognizer locationOfTouch:0 inView:recognizer.view];
 CGPoint twoPoint = [recognizer locationOfTouch:1 inView:recognizer.view];
 CGPoint anchorPoint;
 anchorPoint.x = (onoPoint.x + twoPoint.x) / 2 / recognizer.view.bounds.size.width;
 anchorPoint.y = (onoPoint.y + twoPoint.y) / 2 / recognizer.view.bounds.size.height;
 [self setAnchorPoint:anchorPoint forView:recognizer.view];
 }
 
 
 
 recognizer.rotation = 0;
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
 //
 //设置多手势支持
 - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer: (UIGestureRecognizer *)otherGestureRecognizer
 {
 return YES;
 }
 //
 //#pragma mark - 点击单元块相应
 //-(void) handleTapGesture:(UITapGestureRecognizer*) recognizer
 //{
 //        int xx = [recognizer locationInView:mapBaseView].x;
 //        int yy = [recognizer locationInView:mapBaseView].y;
 //        CGPoint touchPoint = CGPointMake(xx, yy);
 //        [NSObject cancelPreviousPerformRequestsWithTarget:self];
 //        NSValue *touchValue = [NSValue valueWithCGPoint:touchPoint];
 //        [self performSelector:@selector(performTouchTestArea:)
 //                   withObject:touchValue
 //                   afterDelay:0.01];
 //}
 
 //- (void)performTouchTestArea:(NSValue *)inTouchPoint
 //{
 //    CGPoint aTouchPoint = [inTouchPoint CGPointValue];
 //    YJJLog(@"inTouchPoint==%f--%f",aTouchPoint.x,aTouchPoint.y);
 //
 //}
 
 - (void)didReceiveMemoryWarning {
 [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
 }
 
 /*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
