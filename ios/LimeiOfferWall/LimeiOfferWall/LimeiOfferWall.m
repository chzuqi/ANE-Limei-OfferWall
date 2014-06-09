/*
 * LimeiOfferWall.m
 * LimeiOfferWall
 *
 * Created by CZQ on 14-6-7.
 * Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
 */

#import "LimeiOfferWall.h"
#import "LimeiExtensionHandler.h"

LimeiExtensionHandler* limei_handler;

/* LimeiOfferWallExtInitializer()
 * The extension initializer is called the first time the ActionScript side of the extension
 * calls ExtensionContext.createExtensionContext() for any context.
 *
 * Please note: this should be same as the <initializer> specified in the extension.xml 
 */
void LimeiOfferWallExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) 
{
    NSLog(@"Entering LimeiOfferWallExtInitializer()");

    *extDataToSet = NULL;
    *ctxInitializerToSet = &LimeiOfferWallContextInitializer;
    *ctxFinalizerToSet = &LimeiOfferWallContextFinalizer;

    NSLog(@"Exiting LimeiOfferWallExtInitializer()");
}

/* LimeiOfferWallExtFinalizer()
 * The extension finalizer is called when the runtime unloads the extension. However, it may not always called.
 *
 * Please note: this should be same as the <finalizer> specified in the extension.xml 
 */
void LimeiOfferWallExtFinalizer(void* extData) 
{
    NSLog(@"Entering LimeiOfferWallExtFinalizer()");

    // Nothing to clean up.
    NSLog(@"Exiting LimeiOfferWallExtFinalizer()");
    return;
}

/* LimeiOfferWallContextInitializer()
 * The context initializer is called when the runtime creates the extension context instance.
 */
void LimeiOfferWallContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    NSLog(@"Entering ContextInitializer()");
    
    /* The following code describes the functions that are exposed by this native extension to the ActionScript code.
     */
    static FRENamedFunction func[] = 
    {
        MAP_FUNCTION(LimeiBannerInit, NULL),
        MAP_FUNCTION(LimeiAdWallInit, NULL),
        MAP_FUNCTION(LimeiInterstitialsInit, NULL),
        MAP_FUNCTION(LimeiFullScreenInit, NULL),
        MAP_FUNCTION(LimeiReduceScore, NULL),
        MAP_FUNCTION(LimeiQueryScore, NULL),
        MAP_FUNCTION(LimeiShowBanner, NULL),
        MAP_FUNCTION(LimeiHideBanner, NULL),
        MAP_FUNCTION(LimeiShowAdWall, NULL),
        MAP_FUNCTION(LimeiShowFullScreen, NULL),
        MAP_FUNCTION(LimeiShowInterstitials, NULL),
    };
    
    *numFunctionsToTest = sizeof(func) / sizeof(FRENamedFunction);
    *functionsToSet = func;
    
    limei_handler = [[LimeiExtensionHandler alloc]initWithContext:ctx];
    
    NSLog(@"Exiting ContextInitializer()");
}

/* LimeiOfferWallContextFinalizer()
 * The context finalizer is called when the extension's ActionScript code
 * calls the ExtensionContext instance's dispose() method.
 * If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls ContextFinalizer().
 */
void LimeiOfferWallContextFinalizer(FREContext ctx)
{
    NSLog(@"Entering ContextFinalizer()");

    // Nothing to clean up.
    NSLog(@"Exiting ContextFinalizer()");
    return;
}


ANE_FUNCTION(LimeiBannerInit)
{
    return [limei_handler LimeiBannerInit:argv[0]];
}
ANE_FUNCTION(LimeiAdWallInit)
{
    return [limei_handler LimeiAdWallInit:argv[0]];
}
ANE_FUNCTION(LimeiInterstitialsInit)
{
    return [limei_handler LimeiInterstitialsInit:argv[0]];
}
ANE_FUNCTION(LimeiFullScreenInit)
{
    return [limei_handler LimeiFullScreenInit:argv[0]];
}
ANE_FUNCTION(LimeiReduceScore)
{
    return [limei_handler LimeiReduceScore:argv[0] withScore:argv[1]];
}
ANE_FUNCTION(LimeiQueryScore)
{
    return [limei_handler LimeiQueryScore:argv[0]];
}
ANE_FUNCTION(LimeiShowBanner)
{
    return [limei_handler LimeiShowBanner];
}
ANE_FUNCTION(LimeiHideBanner)
{
    return [limei_handler LimeiHideBanner];
}
ANE_FUNCTION(LimeiShowAdWall)
{
    return [limei_handler LimeiShowAdWall];
}
ANE_FUNCTION(LimeiShowFullScreen)
{
    return [limei_handler LimeiShowFullScreen];
}
ANE_FUNCTION(LimeiShowInterstitials)
{
    return [limei_handler LimeiShowInterstitials];
}
