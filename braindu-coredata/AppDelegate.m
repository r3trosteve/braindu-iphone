//
//  AppDelegate.m
//  braindu-coredata
//
//  Created by Steven Schofield on 26/08/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <BrainduDataModel/BrainduDataModel.h>
#import "AppDelegate.h"

static NSString * const kParseAppId = @"74PALysa7pgIR0zupo0fIgtl6NjaVfPg3DgmsJMk";
static NSString * const kParseClientKey = @"tnhNR5Feb7vXuOh1h2k4J5BVqtf2ZKIe9fLMDehg";
@interface AppDelegate ()
            

@end

@implementation AppDelegate
            


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self setupAppearance];
    
    [BUPDataModel configureWithParseAppID:kParseAppId clientKey:kParseClientKey launchOptions:launchOptions];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) setupAppearance {
        // customise appearance globally here
    
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    navigationBarAppearance.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    [[UINavigationBar appearance] setTintColor:[UIColor darkGrayColor]];
}


@end
