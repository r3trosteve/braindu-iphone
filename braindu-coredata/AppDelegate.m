//
//  AppDelegate.m
//  braindu-coredata
//
//  Created by Steven Schofield on 26/08/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <Parse/Parse.h>
#import "BUPUser.h"
#import "AppDelegate.h"

@interface AppDelegate ()
            

@end

@implementation AppDelegate
            


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self setupAppearance];
    
    [Parse setApplicationId:@"74PALysa7pgIR0zupo0fIgtl6NjaVfPg3DgmsJMk"
                  clientKey:@"tnhNR5Feb7vXuOh1h2k4J5BVqtf2ZKIe9fLMDehg"];
    
    //[BUPUser enableAutomaticUser];
    
    // TODO don't do this
    // [[BUPUser currentUser] save];
    
    PFACL *defaultACL = [PFACL ACL];
    
    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    //[defaultACL setPublicWriteAccess:YES];
    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
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
