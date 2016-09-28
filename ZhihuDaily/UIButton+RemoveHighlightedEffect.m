//
//  UIButton+RemoveHighlightedEffect.m
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/12/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "UIButton+RemoveHighlightedEffect.h"
#import <objc/runtime.h>

#define kRemoveHighlightedEffect @"removeHighlightedEffect"

@implementation UIButton (RemoveHighlightedEffect)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class clazz = [self class];
        SEL originalSEL = @selector(setHighlighted:);
        SEL swizzledSEL = @selector(_setRemoveHighlightedEffect:);
        Method originalMethod = class_getInstanceMethod(clazz, originalSEL);
        Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSEL);
        
        BOOL result = class_addMethod(clazz, swizzledSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (result) {
            class_replaceMethod(clazz, originalSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        }else{
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
    });
}

- (void)_setRemoveHighlightedEffect:(BOOL)removeHighlightedEffect {
    if (!self.removeHighlightedEffect) {
        [self _setRemoveHighlightedEffect:removeHighlightedEffect];
    }
}

- (void)setRemoveHighlightedEffect:(BOOL)removeHighlightedEffect {
    objc_setAssociatedObject(self, kRemoveHighlightedEffect, @(removeHighlightedEffect), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)removeHighlightedEffect {
    return objc_getAssociatedObject(self, kRemoveHighlightedEffect);
}

@end
