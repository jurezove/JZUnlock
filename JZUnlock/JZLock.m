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
@property (nonatomic, strong) NSMutableDictionary *images;
@property (nonatomic) JZLockState currentState;

@end

@implementation JZLock

@synthesize imageView = _imageView;
@synthesize images = _images;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
        self.images = [NSMutableDictionary dictionaryWithCapacity:3];
        self.currentState = JZLockStateNormal;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
           andImage:(UIImage *)image {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.image = image;
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)setImage:(UIImage *)image forState:(JZLockState)state {
    [self.images setObject:image forKey:[NSNumber numberWithInt:state]];
    if (state == self.currentState)
        [self changeState:self.currentState animated:NO];
}

- (void)changeState:(JZLockState)state animated:(BOOL)animated {
    UIImage *image = [self.images objectForKey:[NSNumber numberWithInt:state]];
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
        NSLog(@"Changing image without anim for state: %d", state);
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