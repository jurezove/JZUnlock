//
//  AppDelegate.m
//  JZUnlock
//
//  Created by Jure Žove on 8/30/12.
//  Copyright (c) 2012 Jure Žove. All rights reserved.
//

#import "AppDelegate.h"
#import "NSData+CommonCrypto.h"

@interface AppDelegate()

@property (nonatomic, strong) NSData *lock;

@end

@implementation AppDelegate

#pragma mark - Getters/Setters


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UIViewController alloc] init];
    
    JZUnlockView *unlockView = [[JZUnlockView alloc] initWithFrame:self.window.bounds
                                                        andPattern:JZUnlockPattern3x3
                                                unlockViewDelegate:self];
    [unlockView setImage:[UIImage imageNamed:@"lock_normal"] forState:JZLockStateNormal];
    [unlockView setImage:[UIImage imageNamed:@"lock_invalid"] forState:JZLockStateInvalid];
    [unlockView setImage:[UIImage imageNamed:@"lock_valid"] forState:JZLockStateValid];
    [unlockView setImage:[UIImage imageNamed:@"lock_selected"] forState:JZLockStateSelected];

    [self.window.rootViewController.view addSubview:unlockView];
    [self.window makeKeyAndVisible];
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - JZUnlockViewDelegate

- (id)lockView:(JZUnlockView *)lockView dataForRow:(NSInteger)row column:(NSInteger)column {
    return [NSString stringWithFormat:@"Test: %d %d", row, column];
}

- (BOOL)lockView:(JZUnlockView *)lockView endedUnlocking:(NSArray *)sequence {
    NSString *lockString = [sequence componentsJoinedByString:@","];
    NSData *lockData = [lockString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *encrypted = [lockData DESEncryptedDataUsingKey:@"Test" error:&error];
    
    if (!self.lock) {
        if (error) {
            NSLog(@"Error: %@", error);
            return NO;
        }
        else {
            self.lock = encrypted;
            return YES;
        }
    } else {
        if (error) {
            NSLog(@"Error: %@", error);
            return NO;
        }
        else {
            if ([self.lock isEqual:encrypted])
                return YES;
            else
                return NO;
        }
    }
        
//    NSLog(@"Unlock sequence: %@", [sequence componentsJoinedByString:@","]);
//    if (sequence.count == 2 || sequence.count == 5)
//        return YES;
//    return NO;
}

@end
