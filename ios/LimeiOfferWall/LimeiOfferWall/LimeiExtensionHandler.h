//
//  DomodExtensionHandler.h
//  DomodOfferWall
//
//  Created by CZQ on 14-5-29.
//
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"
#import "LimeiTypeConversion.h"
#import <immobSDK/immobView.h>

#define DISPATCH_STATUS_EVENT(extensionContext, code, status) FREDispatchStatusEventAsync((extensionContext), (uint8_t*)code, (uint8_t*)status)


@interface LimeiExtensionHandler : NSObject<immobViewDelegate> {

}

//声明immobView
@property (nonatomic, retain)immobView *adView_Banner;
@property (nonatomic, retain)immobView *adView_AdWall;
@property (nonatomic, retain)immobView *adView_FullScreen;

@property (nonatomic, retain) immobView *adView_Interstitials;
@property (nonatomic, assign)NSInteger adType;

@property (nonatomic, assign) FREContext context;
@property (nonatomic, retain) LimeiTypeConversion *converter;


- (id)initWithContext:(FREContext)extensionContext;

//广告条初始化
- (FREObject)LimeiBannerInit:(FREObject)freAdUnitId;

//积分墙初始化
- (FREObject)LimeiAdWallInit:(FREObject)freAdUnitId;

//插屏广告初始化
- (FREObject)LimeiInterstitialsInit:(FREObject)freAdUnitId;

//全屏广告初始化
- (FREObject)LimeiFullScreenInit:(FREObject)freAdUnitId;

//扣除积分墙积分，需要传入积分墙id！！！！
- (FREObject)LimeiReduceScore:(FREObject)freAdUnitId withScore:(FREObject)freScore;

//查询积分墙积分，需要传入积分墙id！！！！
- (FREObject)LimeiQueryScore:(FREObject)freAdUnitId;

- (FREObject)LimeiShowBanner;
- (FREObject)LimeiHideBanner;
- (FREObject)LimeiShowAdWall;
- (FREObject)LimeiShowFullScreen;
- (FREObject)LimeiShowInterstitials;

@end
