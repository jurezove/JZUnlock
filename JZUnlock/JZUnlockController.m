//
//  JZUnlockController.m
//  JZUnlock
//
//  Created by Jure Žove on 8/30/12.
//  Copyright (c) 2012 Jure Žove. All rights reserved.
//

#import "JZUnlockController.h"
#import "JZUnlockView.h"

@interface JZUnlockController () {
    JZUnlockView *unlockView;
}

@property (nonatomic) JZUnlockPattern pattern;
//@property (nonatomic, strong) NSMutableArray *activeLocks;

@end

@implementation JZUnlockController

//@synthesize pan = _pan;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    unlockView = [[JZUnlockView alloc] initWithFrame:self.view.bounds
                                                        andPattern:JZUnlockPattern2x2
                                  unlockViewDelegate:self];
    [self.view addSubview:unlockView];
//    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    self.pan.delegate = self;
//    [self.view addGestureRecognizer:self.pan];
//    self.activeLocks = [[NSMutableArray alloc] initWithCapacity:16];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//#pragma mark - Gestures
//
//
//- (void)handlePan:(UIGestureRecognizer*)pan {
//    CGPoint locationInView = [pan locationInView:self.view];
//    UIView *lock = [unlockView lockThatContains:locationInView];
//    if (pan.state == UIGestureRecognizerStateBegan && self.activeLocks.count == 0) {
//        if (lock && ![self.activeLocks containsObject:lock]) {
//            [self.activeLocks addObject:lock];
//            [unlockView lockActivated:lock];
//        }
//    } else if (self.activeLocks.count > 0) {
//        
//        // Add other views
//        if (lock && ![self.activeLocks containsObject:lock])
//            [self.activeLocks addObject:lock];
//        
//        
//        NSMutableArray *points = [NSMutableArray arrayWithCapacity:self.activeLocks.count+1];
//        for (UIView *lock in self.activeLocks) {
//            [points addObject:[NSValue valueWithCGPoint:lock.center]];
//        }
//        
//        if (pan.state != UIGestureRecognizerStateEnded)
//            [points addObject:[NSValue valueWithCGPoint:locationInView]];
//        
//        [unlockView drawLine:points];
//        if (pan.state == UIGestureRecognizerStateEnded) {
//            [self.activeLocks removeAllObjects];
//            [unlockView clean];
//        }
//    }
//}
//
//- (void)handleTap:(UIGestureRecognizer*)tap {
//    if (self.activeLocks.count == 0 && tap.state == UIGestureRecognizerStateBegan) {
//        [unlockView clean];
//        UIView *view = [tap view];
//        [self.activeLocks addObject:view];
//        [unlockView lockActivated:view];
//    }
////    else if (self.activeLocks.count > 0 && tap.state == UIGestureRecognizerStateEnded) {
////        [self handlePan:tap];
////    }
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}

#pragma mark - JZUnlockViewDelegate

//- (BOOL)lockViewCanBeginUnlocking:(JZUnlockView *)unlockView andLock:(UIView *)lock {
////    if (self.activeLocks.count == 0) {
////        [self.activeLocks addObject:lock];
////        return YES;
////    }
////    return NO;
//}
//
//- (void)lockViewDidBeginUnlocking:(JZUnlockView *)unlockView andLock:(UIView *)lock {
//    
//}
@end
