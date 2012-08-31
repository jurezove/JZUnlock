//
//  JZLock.m
//  JZUnlock
//
//  Created by Jure Žove on 8/30/12.
//  Copyright (c) 2012 Jure Žove. All rights reserved.
//

#import "JZLock.h"

@interface JZLock()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) JZLockState currentState;

@end

@implementation JZLock

@synthesize imageView = _imageView;
@synthesize lockData = _lockData;
@synthesize lockDelegate = _lockDelegate;

- (id)initWithFrame:(CGRect)frame
       lockDelegate:(id<JZLockDelegate>)lockDelegate
           lockData:(id)lockData {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
        self.currentState = JZLockStateNormal;
        self.lockDelegate = lockDelegate;
        self.lockData = lockData;
    }
    return self;
}

- (void)changeState:(JZLockState)state animated:(BOOL)animated {
    UIImage *image = [self.lockDelegate imageForState:state];
    if (state != self.currentState && animated) {
        // Animate
        [UIView animateWithDuration:0.1
                              delay:0
                            options:UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
                             self.imageView.transform = CGAffineTransformMakeScale(1.3, 1.3);
                             self.imageView.image = image;
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.1
                                              animations:^{
                                                  self.imageView.transform = CGAffineTransformIdentity;
                                              }];
                         }];
    } else {
        self.imageView.image = image;
    }
    self.currentState = state;
    
    switch (state) {
        case JZLockStateNormal:
            break;
            
        case JZLockStateValid:
            
            break;
            
        case JZLockStateInvalid:
            
            break;
        default:
            break;
    }
    
}

@end
