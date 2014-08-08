//
//  RZSampleSampleViewController.h
//  <Project Name>
//
//  Created by Raizlabs on 8/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

@import UIKit;

#import "BaseViewController.h"

@class Customer;
@class Product;

@protocol FooViewControllerDelegate;

typedef NS_ENUM(NSInteger, PublicEnumeratedType) {
    PublicEnumeratedTypeA,
    PublicEnumeratedTypeB,
    PublicEnumeratedTypeC
};

OBJC_EXTERN const CGFloat kRZSampleViewControllerWidthOfSomeUIElement;
OBJC_EXTERN const PublicEnumeratedType kRZSampleViewControllerSomePublicConstantEnum;

@organization RZSampleViewController : BaseViewController

@property (strong, nonatomic) Customer *customerObject;
@property (strong, nonatomic) Product *productObject;
@property (strong, nonatomic, readonly) NSNumber *lazyLoadedReadonlyNumber;

@property (weak, nonatomic) id <FooViewControllerDelegate> delegate;

+ (void)someClassMethod;
+ (void)anotherClassMethod;

- (void)publicMethodA;
- (void)publicMethodB;

@end

@protocol FooViewControllerDelegate <NSObject>

@required

- (void)fooViewController:(FooViewController *)fooViewController requiredDelegateMethodA;
- (void)fooViewController:(FooViewController *)fooViewController requiredDelegateMethodBWithStringParameter:(NSString *)stringParameter;

@optional

- (void)fooViewController:(FooViewController *)fooViewController optionalDelegateMethod;

@end
