//
//  DomodExtensionHandler.m
//  DomodOfferWall
//
//  Created by CZQ on 14-5-29.
//
//

#import "LimeiExtensionHandler.h"

@implementation LimeiExtensionHandler

@synthesize context;
@synthesize converter;
@synthesize adView_Banner;
@synthesize adView_AdWall;
@synthesize adView_FullScreen;
@synthesize adView_Interstitials;
@synthesize adType;

#pragma mark -

- (id)initWithContext:(FREContext)extensionContext
{
    self = [super init];
    if (self) {
        self.context = extensionContext;
        self.converter = [[[LimeiTypeConversion alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
    self.context = nil;
    self.converter = nil;
    adView_AdWall.delegate=nil;
    adView_Banner.delegate=nil;
    adView_FullScreen.delegate=nil;
    adView_Interstitials.delegate=nil;
    
    [adView_AdWall release];
    [adView_Banner release];
    [adView_FullScreen release];
    [adView_Interstitials release];
    [super dealloc];
}


#pragma mark - Manager Delegate

/**
 *查询积分接口回调
 */
- (void) immobViewQueryScore:(NSUInteger)score WithMessage:(NSString *)message{
//    UIAlertView *uA=[[UIAlertView alloc] initWithTitle:@"积分查询" message: ![message isEqualToString:@""]?[NSString stringWithFormat:@"%@",message]:[NSString stringWithFormat:@"当前积分为:%i",score]  delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil, nil];
//    [uA show];
//    [uA release];
    NSString* strScore = [NSString stringWithFormat:@"%i",score];
    DISPATCH_STATUS_EVENT(self.context, [@"immobViewQueryScore" UTF8String], [strScore UTF8String]);
}

/**
 *减少积分接口回调
 */
- (void) immobViewReduceScore:(BOOL)status WithMessage:(NSString *)message{
//    UIAlertView *uA=[[UIAlertView alloc] initWithTitle:status?@"积分减少成功":@"积分减少失败" message: status?@"":[NSString stringWithFormat:@"%@",message] delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil, nil];
//    [uA show];
//    [uA release];
    NSString* strStatus;
    if (status){
        strStatus = @"true";
    }else{
        strStatus = @"false";
    }
    NSLog(@"reduce note: %@", message);
    DISPATCH_STATUS_EVENT(self.context, [@"immobViewReduceScore" UTF8String], [strStatus UTF8String]);
    NSLog(@"immobViewReduceScore complete");
}

- (void) immobView: (immobView*) immobView didFailReceiveimmobViewWithError: (NSInteger) errorCode{
    
    //    UIAlertView *uA=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前广告不可用" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //    [uA show];
    //    [uA release];
    DISPATCH_STATUS_EVENT(self.context, [@"didFailReceiveimmobViewWithError" UTF8String], [@"当前广告不可用" UTF8String]);
    NSLog(@"errorCode:%i",errorCode);
}

- (void) onDismissScreen:(immobView *)immobView{
    NSLog(@"onDismissScreen");
    if (immobView==adView_Interstitials) {
        [immobView removeFromSuperview];
    }
}

#pragma main function

//广告条初始化
- (FREObject)LimeiBannerInit:(FREObject)freAdUnitId
{
    NSString *AdUnitId;
    if ([self.converter FREGetObject:freAdUnitId asString:&AdUnitId] != FRE_OK)
    {
        return NULL;
    }
    //直接拿keywindow,哼嗬哈嘿
    adView_Banner=[[immobView alloc] initWithAdUnitId:AdUnitId adUnitType:banner rootViewController:[[UIApplication sharedApplication] keyWindow].rootViewController userInfo:nil];
    adView_Banner.delegate=self;
    NSLog(@"init banner with AdUnitId: %@", AdUnitId);
    return NULL;
}

//积分墙初始化
- (FREObject)LimeiAdWallInit:(FREObject)freAdUnitId
{
    NSString *AdUnitId;
    if ([self.converter FREGetObject:freAdUnitId asString:&AdUnitId] != FRE_OK)
    {
        return NULL;
    }
    //直接拿keywindow,哼嗬哈嘿
    adView_AdWall=[[immobView alloc] initWithAdUnitId:AdUnitId adUnitType:offerWall rootViewController:[[UIApplication sharedApplication] keyWindow].rootViewController userInfo:nil];
    adView_AdWall.delegate=self;
    //此属性针对多账户用户，主要用于区分不同账户下的积分(如果你的应用或游戏需要用户登陆，请使用此属性)
    //      [adView_AdWall.UserAttribute setObject:@"your user account" forKey:accountname];
    //      [adView_AdWall.UserAttribute setObject:@"YES" forKey:disableStoreKit];
    //懒得写，谁要谁自己加
    NSLog(@"init adwall with AdUnitId: %@", AdUnitId);
    return NULL;
}

//插屏广告初始化
- (FREObject)LimeiInterstitialsInit:(FREObject)freAdUnitId
{
    NSString *AdUnitId;
    if ([self.converter FREGetObject:freAdUnitId asString:&AdUnitId] != FRE_OK)
    {
        return NULL;
    }
    //直接拿keywindow,哼嗬哈嘿
    adView_Interstitials=[[immobView alloc] initWithAdUnitId:AdUnitId adUnitType:interstitial rootViewController:[[UIApplication sharedApplication] keyWindow].rootViewController userInfo:nil];
    adView_Interstitials.delegate=self;
    [adView_Interstitials immobViewRequest];
    
    NSLog(@"init Interstitials with AdUnitId: %@", AdUnitId);
    return NULL;
}

//全屏广告初始化
- (FREObject)LimeiFullScreenInit:(FREObject)freAdUnitId
{
    NSString *AdUnitId;
    if ([self.converter FREGetObject:freAdUnitId asString:&AdUnitId] != FRE_OK)
    {
        return NULL;
    }
    //直接拿keywindow,哼嗬哈嘿
    adView_FullScreen=[[immobView alloc] initWithAdUnitId:AdUnitId adUnitType:fullScreen rootViewController:[[UIApplication sharedApplication] keyWindow].rootViewController userInfo:nil];
    adView_FullScreen.delegate=self;
    NSLog(@"init FullScreen with AdUnitId: %@", AdUnitId);
    return NULL;
}

//扣除积分墙积分，需要传入积分墙id！！！！
- (FREObject)LimeiReduceScore:(FREObject)freAdUnitId withScore:(FREObject)freScore
{
    NSInteger score =  [self.converter FREGetObjectAsInteger:freScore] ;
    NSLog(@"== reduce %d", (int)score);
    NSString *AdUnitId;
    if ([self.converter FREGetObject:freAdUnitId asString:&AdUnitId] != FRE_OK)
    {
        return NULL;
    }
    [adView_AdWall immobViewReduceScore:score WithAdUnitID:AdUnitId];
    return NULL;
}

//查询积分墙积分，需要传入积分墙id！！！！
- (FREObject)LimeiQueryScore:(FREObject)freAdUnitId
{
    NSString *AdUnitId;
    if ([self.converter FREGetObject:freAdUnitId asString:&AdUnitId] != FRE_OK)
    {
        return NULL;
    }
    [adView_AdWall immobViewQueryScoreWithAdUnitID:AdUnitId];
    NSLog(@"LimeiQueryScore");
    return NULL;
}

- (FREObject)LimeiShowBanner
{
    //额，怎么去除
    [adView_Banner immobViewRequest];
    [[[UIApplication sharedApplication] keyWindow].rootViewController.view addSubview:adView_Banner];
    NSLog(@"LimeiShowBanner");
    return NULL;
}
- (FREObject)LimeiHideBanner
{
    [adView_Banner removeFromSuperview];
    NSLog(@"LimeiHideBanner");
    return NULL;
}
- (FREObject)LimeiShowAdWall
{
    NSLog(@"LimeiShowAdWall");
    //AdUnitID 可以到力美广告平台去获取:http://www.limei.com
    [adView_AdWall immobViewRequest];
    [[[UIApplication sharedApplication] keyWindow].rootViewController.view addSubview:adView_AdWall];
    return NULL;
}
- (FREObject)LimeiShowFullScreen
{
    //AdUnitID 可以到力美广告平台去获取:http://www.limei.com
    [adView_FullScreen immobViewRequest];
    [[[UIApplication sharedApplication] keyWindow].rootViewController.view addSubview:adView_FullScreen];
    return NULL;
}
- (FREObject)LimeiShowInterstitials
{
    NSLog(@"LimeiShowInterstitials:%hhd", adView_Interstitials.isAdReady);
    if (adView_Interstitials.isAdReady) {
        [adView_Interstitials immobViewDisplay];
        [[[UIApplication sharedApplication] keyWindow].rootViewController.view addSubview:adView_Interstitials];
    }
    return NULL;
}

@end
