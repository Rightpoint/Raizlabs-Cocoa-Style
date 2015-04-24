//
//  RZSampleSampleViewController
//  <Project Name>
//
//  Created by Raizlabs on 8/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

@import Accelerate;
@import AddressBook;
@import QuartzCore;

// View controllers
#import "FooViewController.h"
#import "ViewControllerA.h"
#import "ViewControllerB.h"
#import "ViewControllerC.h"

// Custom views/cells
#import "ViewA.h"
#import "ViewB.h"
#import "TableViewCell.h"
#import "CollectionViewCell.h"
#import "TableViewHeaderView.h"

// Data model/managers
#import "UserManager.h"
#import "SettingsManager.h"
#import "Customer.h"
#import "Product.h"

// Categories
#import "UIView+FrameUtils.h"
#import "NSString+StringUtils.h"

// Constants
#import "WebServiceConstants.h"
#import "StringConstants.h"

// Third party
#import "GAI.h"
#import "Crittercism.h"

typedef NS_ENUM(NSInteger, PrivateEnumeratedType) {
    PrivateEnumeratedTypeA,
    PrivateEnumeratedTypeB,
    PrivateEnumeratedTypeC
};

#define RGBColor(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define kRZSampleViewControllerTitle NSLocalizedString(@"A Title", @"The title of the view controller")

const CGFloat kRZSampleViewControllerWidthOfSomeUIElement = 200.0f;
const PublicEnumeratedType kRZSampleViewControllerSomePublicConstantEnum = PublicEnumeratedTypeB;

static NSString* const kRZSampleViewControllerIdentifier = @"com.raizlabs.";
static const NSInteger kRZSampleViewControllerMinimumDollarValue = 15;
static const PrivateEnumeratedType kRZSampleViewControllerSomePrivateConstantEnum = PrivateEnumeratedTypeA;

@interface RZSampleSampleViewController ()
<SomeOtherProtocolDelegate,
UITableViewDataSource,
UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *someSubview;
@property (weak, nonatomic) IBOutlet UITableView *aTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *someSegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *someButton;

@property (strong, nonatomic) NSLayoutConstraint *subviewHeightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *tableViewBottomVerticalConstraint;
@property (strong, nonatomic) NSLayoutConstraint *segmentedControlLeadingHorizontalConstraint;

@property (copy, nonatomic) NSArray *someArray;
@property (assign, nonatomic) BOOL isEditing;

- (IBAction)segmentedControlValueChanged:(id)sender;
- (IBAction)buttonClicked:(id)sender;

@end

@implementation RZSampleSampleViewController

@synthesize lazyLoadedReadonlyNumber = _lazyLoadedReadonlyNumber;

#pragma mark - Class methods

+ (void)someClassMethod
{
    // ...
}

+ (void)anotherClassMethod
{
    // ...
}

#pragma mark - Init/dealloc

- (instancetype)init
{
    // ...
}

- (instancetype)initWithInteger:(NSInteger)integerParameter
{
    self = [super init];
    if (self) {
        // do setup stuff with integerParameter
    }

    return self;
}

- (void)dealloc
{
    // ...
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    // ...

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark - Notifications

- (void)keyboardWillHide:(NSNotification *)notification
{
    // ...
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    // ...
}

#pragma mark - UITableViewDataSource

// table view data source callbacks

#pragma mark - UITableViewDelegate

// table view delegate callbacks

#pragma mark - SomeOtherProtocolDelegate

// SomeOtherProtocolDelegate callbacks

#pragma mark - IBActions

- (IBAction)segmentedControlValueChanged:(id)sender
{
    // ...
}

- (IBAction)buttonClicked:(id)sender
{
    // ...
}

#pragma mark - Property getters/setters

- (void)setCustomerObject:(Customer *)customerObject
{
    // ...
}

- (Product *)productObject
{
    // ...
    return _productObject;
}

- (void)setProductObject:(Product *)productObject
{
    // ...
    _productObject = productObject;
}

- (NSNumber *)lazyLoadedReadonlyNumber
{
    if (!_lazyLoadedReadonlyNumber) {
        // ...
    }
    return _lazyLoadedReadonlyNumber;
}

#pragma mark - Public interface

- (void)publicMethodA
{
    // ...
}

- (void)publicMethodB
{
    // ...
}

#pragma mark - Private interface

- (void)someHelperMethod
{
    // ...
}

- (void)someOtherPrivateMethod
{
    // ...
}

@end
