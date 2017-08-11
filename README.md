# Raizlabs Objective-C Style Guide

This guide outlines the coding conventions and best practices for the Objective-C developers at Raizlabs.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [Dot Syntax](#dot-syntax)
  - [Custom getters/setters](#custom-getterssetters)
  - [Idempotent](#idempotent)
  - [Mixed Usage](#mixed-usage)
- [Whitespace](#whitespace)
  - [Newlines](#newlines)
  - [Indentation](#indentation)
- [Naming](#naming)
  - [Variables](#variables)
  - [Properties](#properties)
  - [Instance Variables](#instance-variables)
  - [Constants](#constants)
- [Variables](#variables-1)
- [Properties](#properties-1)
- [Conditionals](#conditionals)
- [Mathematical operators](#mathematical-operators)
- [`CGFloat`](#cgfloat)
- [Switch statements](#switch-statements)
- [Comments](#comments)
- [Method Signatures](#method-signatures)
- [Return statements](#return-statements)
- [Protocols](#protocols)
- [Blocks](#blocks)
  - [Naming](#naming-1)
  - [Spacing](#spacing)
  - [Block Parameters](#block-parameters)
- [Constants](#constants-1)
  - [User-Facing Strings](#user-facing-strings)
  - [Other string constants (non-user-facing)](#other-string-constants-non-user-facing)
  - [Magic Strings](#magic-strings)
  - [Numbers](#numbers)
  - [Structs](#structs)
- [Enumerations](#enumerations)
- [Initializers](#initializers)
- [Singletons](#singletons)
- [Error handling](#error-handling)
  - [Out Errors (`NSError **`)](#out-errors-nserror-)
- [Literals](#literals)
- [Rule of three](#rule-of-three)
  - [Protocol Conformation](#protocol-conformation)
  - [Method calls/signatures](#method-callssignatures)
- [Unnecessary code](#unnecessary-code)
- [File Organization](#file-organization)
  - [Header Files (`.h`)](#header-files-h)
    - [When to use a `_Private.h` file](#when-to-use-a-_privateh-file)
  - [Implementation Files (`.m`)](#implementation-files-m)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Dot Syntax

Use dot notation for all property access and manipulation. **Never** access `_ivars` directly when a property has been declared, except where required:

**Preferred:**

```objc
self.foo = 4;
int bar = self.foo;
```

**Not:**

```objc
[self setFoo:4];
int bar = [self foo];
_bar = 4;
```
### Custom getters/setters

For clarity, you may use bracket notation for overridden setters/getters:

```objc
- (void)setFoo:(int)foo
{
    // some extra code goes here

    _foo = foo;
}

- (int)foo
{
    // some extra code goes here

    return _foo;
}

- (void)aMethod
{
    [self setFoo:4];
    int test = [self foo];
}
```
### Idempotent

**Never** use dot notation on a non-[idempotent](http://en.wikipedia.org/wiki/Idempotent) property or method. For example, `count` isn't actually a property on `NSArray`; the compiler just infers because there's a method called count. However, it *is* an idempotent method, so it is safe to use dot-notation:

```objc
NSUInteger foo = myArray.count;
```

Avoid non-idempotent setters

**Bad:**

```objc
- (void)setFoo:(id)foo
{
    _foo = foo;
    _lastTimeFooWasSet = [NSDate date];
   [self.tableView reloadData];
}
```

**Better:**

```objc
- (void)updateFoo:(id)foo refresh:(BOOL)refresh
{
    self.foo = foo;
    if ( refresh ) {
        _lastTimeFooWasSet = [NSDate date];
        [self.tableView reloadData];
    }
}
```

This is not to say that you shouln't override setters; you just need to be careful that the side effects are obvious, and with low potential danger.

### Mixed Usage

Do not mix bracket notation and dot notation on the same line.

**Bad:**
```objc
[UIApplication sharedApplication].statusBarOrientation
```

**Preferred:**
```objc
[[UIApplication sharedApplication] statusBarOrientation]
```

## Whitespace

### Newlines

- Never more than one consecutive newline of whitespace
- Use one newline of whitespace to group conceptually distinct parts of methods.

```objc
- (void)viewDidLoad
{
    // set up foo object
    UIFoo *foo = [[UIFoo alloc] init];
    foo.property = value;

    // set up bar object
    UIBar *bar = [[UIBar alloc] initWithThing:foo];
}
```

### Indentation

- Always use 4 spaces, never tabs. (In Xcode, go to **Preferences** → **Text Editing** → **Indentation** to set this.)

## Naming

### Variables

Variables always use camel case:

```objc
likeThis;
```

Variables of type `Class` start with a capital letter. Note that a variable of type `Class` should use `Nil`, not `nil`, to express emptiness:

```objc
Class SomeClassVariable = Nil;
SomeClassVariable = [MyClass class];
```

### Properties

Never give properties generic names. Instead, prefix the variable name with a descriptor such as, but not limited to, the class name.

**Preferred:**

```objc
@property (strong, nonatomic) UICollectionView *myClassCollectionView;
```

**Not:**
```objc
@property (strong, nonatomic) UICollectionView *collectionView;
```

### Instance Variables

Instance variables begin with an underscore and rename the variable to `_propertyName`.

```objc
@synthesize ivarName = _ivarName;
```

However, the use of explicitly declared or synthesized instance variables is discouraged except where required.

### Constants

Constants are camel-case, and should use the following format:

- lowercase `k` prefix
- followed by the project's class prefix in all caps
- followed by class name
- followed by descriptor

```objc
// [k][class prefix][class name][constant name]
static const NSInteger kRZMyClassSomeErrorCode = -1;
```

See also: [Cocoa naming conventions for variables and types](https://developer.apple.com/library/mac/documentation/cocoa/conceptual/codingguidelines/articles/namingivarsandtypes.html).

## Variables

Asterisks indicating pointers belong with the variable, except in the case of [constants](#constants):

**Preferred:**

```objc
NSString *text;
```

**Not:**

```objc
NSString* text;
NSString * text
```

Always use `@property`-declared variables instead of instance variables (except for where you have to).

**Preferred:**

```objc
@interface RWTTutorial : NSObject

@property (copy, nonatomic) NSString *tutorialName;

@end
```

**Not:**

```objc
@interface RWTTutorial : NSObject
{
    NSString *tutorialName;
}
```

Instance variables are required in the following case:

> Subclasses don't have visibility into auto-synthesized properties defined on ancestor classes. Redefining the property requires duplicating the property semantics, which might change. Declaring the instance variable is actually correct in this case. If you want to hide it, mark it `@private` or use a private header.

## Properties

- Spaces between `@property`, specifiers, and property type
- Asterisk sticks to property name
- Specifier order:

 1. Retain strength: `strong`, `weak`, `assign`, `copy`
 2. Atomicity `nonatomic`, `atomic`
 3. Readability `readwrite`, `readonly`
 4. Custom getter
 5. Custom setter

**Preferred:**

```objc
@property (strong, nonatomic) NSObject *someObject;
```

**Not:**

```objc
@property (nonatomic, strong) NSObject *someObject;
@property (strong, nonatomic) NSObject* someObject;
@property (strong, nonatomic) NSObject * someObject;
@property(strong, nonatomic) NSObject *someObject;
@property(strong, nonatomic)NSObject *someObject;
```

## Conditionals

- **NEVER** forgo the braces for one-line if statements ([#gotofail](https://www.imperialviolet.org/2014/02/22/applebug.html) anyone?)
- One space between the control keyword and opening parentheses
- Opening brace same line as predicate, separated by one space
- Continuing keywords (`else if`/`else`) on new line below closing brace
- All keywords and closing braces are flush left and code within braces are indented 4 spaces

**Preferred:**

```objc
if (expression) {
    // if code
}
else if (other expression) {
    // else if code
}
else {
    // else code
}
```

**Not:**

```objc
if ( expression )
{ // shouldn't be on next line
    // if code
} else if ( expression ) // else should start on new line
{
    // else if code
}
else
    // else code // NEVER forgo braces
```

## Mathematical operators

Unary operators stick to the number they modify:

```objc
int x = -10;
NSNumber *y = @(x * -3);
```

Use spaces between all binary and ternary mathematical operators. Fully parenthesize mathematical expressions and any logical expression with 1+ operator:

```objc
int x = ((1 + 1) / 1);
```

Ternary conditional tests must be enclosed in parens:

```objc
CGFloat result = (x > 2) ? someValue : otherValue;
```

Non-conditionals do not need parens:

```objc
CGFloat result = self.isLoading ? someValue : otherValue;
```

No nesting of ternary expressions.

- Don't even think about it.

```objc
BOOL dontDoThis = self.otherBOOL ? ((self.dont) ? self.do : self.this) : self.please;
```

## `CGFloat`

- `CGFloat` is defined as `double` in 64-bit architecture and `float` in 32-bit
- Always trail with an `f` when sending a float literal to a `CGFloat` parameter
- Do not use `x.f` when there is no decimal value. Instead, use `x.0f`
    - Although `x.f` compiles perfectly fine, it is unclear (especially for our clients who may not be used to this abstract notation)

**Preferred:**
```objc
CGSizeMake(2.0f, 2.0f);
```

## Switch statements

-  Braces should be on same line as `case`
-  If a case has more than one line of code (other than the break), surround that case's body with braces
-  Spaces inside parentheses, just like conditional statements

```objc
switch ( expression ) {
    case 1:
        // code
        break;
    case 2: {
        // code
        // code
        break;
    }

    default:
        // default code
        break;
}
```

We strongly encourage you to put fallthroughs at the **end** of the statement:

```objc
switch ( expression ) {
    case 1: {
        // case 1 code
        break;
    }
    case 2: // fall-through
    case 3:
        // code executed for values 2 and 3
        break;
    default:
        // default code
        break;
}
```

Do not use a default if there isn't any handling for the default case:

**Preferred:**

```objc
switch ( expression ) {
    case 1: {
        // case 1 code
        break;
    }
    default: {
        // default code
        // more default code
        break;
    }
}
```

**Not:**

```objc
switch ( expression ) {
    case 1: {
        // case 1 code
        break;
    }
    default: // nothing here, no need for default!
        break;
}
```
## Comments

- Comment whenever you are mitigating an OS bug (including the OS revision and when it might be able to be removed, if you know)
- Comment whenever you write code that might appear weird or intimidating to a new developer
- In general, comment any nontrivial code
- Don’t comment trivial code where the meaning should be inferred from good variable and method naming

- Never use your name in comments or code
    - It isn't a good idea to send that info to clients
    - It isn't necessary, beacuse of `git blame`

- Never reference bug numbers from another bug tracker (Jira, Github) in code

- Use double slash comments (`//`)

    - One space always immediately after slashes

    - In general, put comments on the line before the code being explained. One newline should come before the comment and after the code fragment being explained to avoid confusion with following code unrelated to comment:

```objc
...preceding code...
...preceding code...

// Explanatory comment
...code being explained...

...other code unrelated to comment...
...other code unrelated to comment...
```

- You _may_ comment "trivial" code if it aids readability in some way (eg. visually distinguishing multiple tasks in a long method)
- You _may_ comment in-line where appropriate. Eg. to identify the closing brace of a nested code block.

    - Special comment identifiers

        - `// !!!:`

            - Use to comment code that mitigates OS bugs, code that could in the future be eliminated or changed when something out of our control is fixed

        - `// ???:`

            - Do not use (?)

        - `// TODO:`

            - Use when code is committed but is intentionally left incomplete, i.e. empty method bodies whose implementation is part of another sprint-planned issue

- `/* */`

    - Very long comments (3 lines or more; see [Rule of Threes](#rule-of-three))

- `/** */` Documentation Comments

    - Documentation comments give semantic and contextual meaning to our APIs

    - These are required for open-source frameworks, but can also be useful to document internal code, especially core components of an app, like common API and data classes

    - Can be parsed by [AppleDoc](http://gentlebytes.com/appledoc/) to create documentation file from code

    - Use `///` *only* for 1-line documentation comments

    - Install [VVDocumenter](https://github.com/onevcat/VVDocumenter-Xcode) via [Alcatraz](https://github.com/onevcat/VVDocumenter-Xcode) to automatically fill in AppleDoc-style comments when you type `///`

    - For more info on documentation in Xcode, see [this stackoverflow answer](http://stackoverflow.com/a/6605536)

## Method Signatures

- One space between scope symbol (`-`, `+`) and return type
- One space between types and asterisks
- Descriptive names for parameter names
- A pre-colon identifier must be present for each parameter
- A type must be present for each identifier
- Don't use `and` or `or` for parameter names.
- Block parameters should always be last

**Preferred:**

```objc
- (NSObject *)methodNameWithParam:(NSObject *)param otherParam:(NSObject *)otherParam;
```

**Not:**

```objc
- (NSObject *)methodNameWithParam:(NSObject *)param andOtherParam:(NSObject *)otherParam;
-(void)setT:(NSString *)text i:(UIImage *)image;
- (void)sendAction:(SEL)aSelector :(id)anObject :(BOOL)flag; // Never do this
- (id)taggedView:(NSInteger)tag;
- (instancetype)initWithWidth:(CGFloat)width andHeight:(CGFloat)height;
- (instancetype)initWith:(int)width and:(int)height; // Never do this.
```

Colon-align long method signatures ([3 lines or more](#rule-of-three)) (unless there is a block parameter!):

```objc
- (id)initWithTableView:(UITableView *)tableView
         collectionList:(id<RZCollectionList>)collectionList
               delegate:(id<RZCollectionListTableViewDataSourceDelegate>)delegate
```

When the first parameter is not as long as the latter ones, left-align all lines. (This is what Xcode’s default auto-format behavior, so it runs the least risk of being changed by mistake later.)

```objc
- (void)align:(BOOL)this
veryVeryVeryVeryLong:(BOOL)method
signatureThatIsStillNotAsLongAsManyTotallyLegitimateCocoa:(BOOL)methods
```

See also: [Cocoa naming conventions for methods](https://developer.apple.com/library/mac/documentation/cocoa/conceptual/codingguidelines/Articles/NamingMethods.html).

## Return statements

Using only one return at the end of a method end is **extremely preferred**. Instead of bailing early, modify a return variable within the method:

**Preferred:**

```objc
- (int)foo
{
    int ret = 0;

    // code to modify "ret"
    switch ( self.bar ) {
        case 0: {
            ret = 12;
            break;
        }
        case 1: {
            ret = 42;
            break;
        }
        default:
            // handle default case
            ret = 11;
            break;
        }
    }

    return ret;
}
```

**Not:**

```objc
- (int)foo
{
    switch ( self.bar ) {
        case 0:
            return 12;
        case 1:
            return 42;
        default:
            return 0;
    }
}
```

Early returns are permitted only at the beginning of a method, when you need to bail quickly:

```objc
- (id)doSomething
{
    if ( doingSomething ) {
        return nil;
    }

    // do awesome things
    return awesomeThing;
}
```

## Protocols

- Protocol name should be of the format [`class prefix`][`class name`][`protocol function`]
- Forward protocol declaration appears before `@interface` definition; protocol definition comes after.
- The delegate property in the interface should be `weak`.
- `@required` and `@optional` only need be present if both types of methods exist. If they are both omitted, every method is required by default.

**Preferred:**

```objc
@protocol RZSomeClassDelegate;

@interface RZSomeClass : NSObject

@property (weak, nonatomic) id <RZSomeClassDelegate> delegate;

@end

@protocol RZSomeClassDelegate <NSObject>

@required

// required methods

@optional

// optional methods

@end
```

**Not:**

```objc
@protocol RZSomeClassDelegate <NSObject>

@required

// required methods

@optional

// optional methods

@end

@interface RZSomeClass : NSObject

@property (weak, nonatomic) id <RZSomeClassDelegate> delegate;

@end
```

## Blocks

If you can do it with with a completion block, don't use a protocol.

### Naming

- `typedef` blocks that are specific to a class or function
- `typedef`ed names should follow the [constant naming protocol](#naming)

```objc
// some .h file
typedef void (^RZCompletionBlock)(BOOL succeeded, NSError *error);
```

Do not use a newline before the opening curly brace.

**Preferred:**

```objc
[UIView animateWithDuration:0.2 animations:^{
    // animation code
} completion:nil];
```

**Not:**

```objc
[UIView animateWithDuration:0.2
                animations:^
                {
                    // animation code
                } completion:nil];
```

### Spacing

When the block takes parameters, put a space between the closing parenthesis and the the opening curly brace:

```objc
[self.thing enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    // code
}];
```

When the block takes **no** parameters, do not put a space between  the `^` and the `{`:

```objc
[UIView animateWithDuration:9.41 animations:^{
    // code
}];
```

### Block Parameters
When you don’t want to pass a block to a parameter, use `nil`, not `NULL`. This is because blocks are Objective-C objects, and because you may want to send messages such as `-copy` to them even if they are `nil`.

```objc
[self presentViewController:aViewController
                   animated:YES
                 completion:nil];
```

## Constants

### User-Facing Strings

**Always** use NSLocalizedString for User-facing strings.

- These need not be in a separate header. They can be defined at the top of the file that uses them.
- **Always** `#define` NSLocalizedString constants.

**Preferred:**

```objc
#define kRZClassNameStringConstant NSLocalizedString(@"Hello World", @"A hello world string")
````

### Other string constants (non-user-facing)

- Do not use `#define`
    - FYI: **When you #define a constant, it's defined in every other file the compiler looks at until (if) it's `#undef`ed. It could also be redefined at any time.**

- **Always** use static or extern string constants
- use `OBJC_EXTERN` instead of `extern`
- use reverse-domain syntax with the domain of the project for internal (non-user-facing and non-api-facing) string constants

**Preferred:**

```objc
static NSString* const kRZLoginUsername = @"com.raizlabs.login.username";
```

If you want to make it **public**, put this in the `.h` file:

```objc
OBJC_EXTERN NSString* const kRZLoginUsername;
```

And in the `.m`:

```objc
NSString* const kRZLoginUsername = @"com.raizlabs.login.username";
```

### Magic Strings

- **NEVER use them!**

    - i.e. never do this:

```objc
- (void)someMethod
{
    NSString *message = @"Error, you broke the app!";
}
```

### Numbers

- Do not use `#define`
- Use static or extern number constants
    - This hides the actual value from public interfaces, so programmers are more likely to use the constant instead of copying the value

**Preferred:**

```objc
// .m file
const int intName = 4;

// .h file
OBJC_EXTERN const int intName;
```

**Always** make internal, private constants `static`.

**Preferred:**

```objc
// .h file
// This space intentionally left blank

// .m file
static const CGFloat buttonHeight = 44.0f;

```

Magic numbers are allowed for numbers that can't change (like dividing by 2 to get the center of something)

### Structs

If you need a constant struct, use the [designated intializer syntax](https://gcc.gnu.org/onlinedocs/gcc/Designated-Inits.html):

```objc
static const CGSize kRZTestViewControllerShadowOffset = { .width = 0.0f, .height = 3.0f };
```

## Enumerations

- **Always** use `NS_ENUM` (see [this NSHipster post](http://nshipster.com/ns_enum-ns_options/))
- Always define the numeric value of the first item

**Preferred:**

```objc
typedef NS_ENUM(NSInteger, RZFoo) {
    RZFooBlue = 0,
    RZFooRed,
    RZFooGreen
};
```

**Not:**

```objc
typedef enum
{
    RZFooBlue,
    RZFooRed
    RZGreen
}RZFoo;

enum
{
    RZFooBlue,
    RZFooRed
    RZGreen
};

```

- The name of the type should act as a prefix for the subtypes

- Typedefs should have class prefixes

- It is common to use an "Unknown" type. If present, it should always be the first item in the enum.

**Example:**

```objc
typedef NS_ENUM(NSInteger, RZFoo) {
    RZFooUnknown = -1,
    RZFooBlue,
    RZFooRed
};
```

If you want to accept mutilple sub-values, use a bitmask
    - Always use an **unsigned integer** for bitmasks

Add an "All"-suffixed subtype when applicable

**Example:**

```objc
typedef NS_OPTIONS(NSUInteger, RZFoo) {
    RZFooUnknown,
    RZFooBlue,
    RZFooRed,
    RZFooGreen,
    RZFooAll
};
```

## Initializers

- Return `instacetype`, not `id`.
- Use `[[[self class] alloc] init]` when instantiating an object of same type as `self`, so that subclasses that call these methods will get back an object of the correct class.

**Preferred:**

```objc
- (instancetype)init;
```

**Not:**

```objc
- (id)init;
```

## Singletons

Singleton objects should use a thread-safe GCD pattern for creating their shared instance:

```objc
+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });

   return sharedInstance;
}
```

## Error handling

**Always** handle errors and return values

- check `BOOL` or object return value before checking the error inout parameter

- The parameters of completion blocks should include a success `BOOL` when applicable (e.g. web service calls). Test against this `BOOL`, not the `error` object, to determine whether the operation was successful
- It is **never** safe to assume that a method will return a valid error object without first checking the return value, especially when using Apple APIs

**Preferred:**

```objc
- (void)doSomething
{
    [someObject doSomethingWithCompletion:^(BOOL success, NSError *error) {
        if ( success ) {
            // Handle success
        }
        else if ( error ) {
            // Handle error with an error object returned
        }
        else {
            // Handle error without an error object
        }
    }];
}
```

**Not:**

```objc
- (void)doSomething
{
    [someObject doSomethingWithCompletion:^(BOOL success, NSError *error) {
        if ( error ) {
            // Handle error
        }
        else {
            // Assume success
        }
    }];
}
```

Name error pointers something more specific than `error` when there are nested/multiple calls that return errors in the scope of a method

**For example:**

```objc
// Ignoring above advice about checking return value
// for the sake of a concise example.
- (void)doColor
{
    [self blueWithError:^(NSError *blueError) {
            if ( blueError ) {
                // handle blueError
            }

            [self redWithError:^(NSError *redError) {
                if ( redError ) {
                    // handle redError
                }
            }];
        }];

    [self yellowWithError:^(NSError *yellowError) {
        if ( yellowError ) {
            // handle yellowError
        }
    }];
}
```

### Out Errors (`NSError **`)

- Methods that return errors should return an object or a `BOOL` indicating success
- Always name `NSError` double pointers `outError`:

```objc
- (BOOL)doActionReturningError:(NSError **)outError;
- (BOOL)doActionWithThing:(NSObject *)thing error:(NSError **)outError;
```

## Literals

Use [Objective-C literals](http://clang.llvm.org/docs/ObjectiveCLiterals.html) wherever possible.

**Preferred:**

```objc
NSArray *foo = @[object, object, object];
```

**Not:**

```objc
NSArray *array = [[NSArray alloc] initWithObjects:@"foo", @"bar", nil];

NSArray *anotherArray = [NSArray arrayWithObjects:@"foo", @"bar", nil];
```

## Rule of three

### Protocol Conformation

If a class conforms to three or more protocols, separate each declaration with line breaks:

**Preferred:** (who doesn't love alphabetizing?)

```objc
@interface RZViewController : UIViewController
<RZBeerDelegate,
RZInfiniteChipotleDelegate,
RZKitchenDelegate,
RZLunchFinderDelegate>
```


**Not:**

```objc
@interface RZViewController : UIViewController <RZKitchenDelegate, RZInfiniteChipotleDelegate, RZLunchFinderDelegate, RZBeerDelegate>
```

### Method calls/signatures

If a method has 3 or more parameters, separate the paramters with line breaks:

**Preferred:**

```objc
- (void)doSomethingWithArray:(NSArray *)array
                      string:(NSString *)string
                        bool:(BOOL)bool
{
    [super doSomethingWithArray:array
                         string:string
                           bool:bool];
}
```

**Not:**

```objc
- (void)doSomethingWithArray:(NSArray *)array string:(NSString *)string bool:(BOOL)bool
{
    [super doSomethingWithArray:array string:string number:number bool:bool];
}
```

Don't align method calls that take non-`nil` block parameters

```objc
[super doSomethingWithArray:array string:string bool:bool completion:^{
    // block code
}];
```

## Unnecessary code

Advances in Clang and Objective-C have made certain conventions obsolete. 99% of the time, we should **no longer use the following**:

- `@synthesize`d properties (except for readonly properties as of Xcode 6)
- explicitly declared ivars
- forward declaration of private methods
    - for readability's sake, private methods should always be grouped under `#pragma mark - Private Methods`
    - please see the [file organization](#file-organization) page for more on this

## File Organization

Objective-C files should generally be organized in the following order. See the included `RZSampleViewController.h` and `RZSampleViewController.m` to see these rules in practice.

### Header Files (`.h`)

- Framework `@import`s
- Application header `#import`s (`"..."`)

    - These should be used judiciously. Consider forward class declarations and only import in `.m` or `_Private.h` if you can. This can improve build times by reducing the redundancy of header imports.
- forward `@class` declarations
- forward `@protocol` declarations
- `typedef`ed enumerations and block signatures
- `OBJC_EXTERN`ed constant declarations
- `@interface` - protocol conformations should be used here judiciously — consider using in `.m` or `_Private.h`; see also [Rule of Three](#rule-of-three))

- **Nothing should be public unless it explicitly needs to be used by other classes**

- `@property` declarations
    - cluster similar properties into groups separated by a newline
        - `UIView` subclasses
        - Other `NSObject` subclasses
        - `NSLayoutConstraint`s
        - delegate references
- class method declarations
- public interface method declarations
- `IBOutlet`/`IBAction` should never appear in `.h` files!
- `@protocol` definitions
    - `@required` and `@optional` only necessary if both types of methods are present

#### When to use a `_Private.h` file

When you have a base class of which you have multiple subclasses. For example:

- Separate iPad and iPhone versions of a class
- If the subclasses need to inherit private properties and methods
- You don't want to expose items in the public interface of the base class

What to do:

1. Create a new class extension file
2. Name it YourClass_Private.h
3. Put all your shared interface elements in that private interface
4. Import that interface file in your subclasses' implementation files

An example structure:

- Base Class
    - `RZMainViewController.m`
    - `RZMainViewController.h`
- Private Interface
    - `RZMainViewController_Private.h`
- iPhone subclass - .m `#import`s `RZMainViewController_Private.h`
    - `RZMainViewController~iphone.m`
    - `RZMainViewController~iphone.h`
    - `RZMainViewController~iphone.xib`
- iPad subclass - .m `#import`s `RZMainViewController_Private.h`
    - `RZMainViewController~ipad.m`
    - `RZMainViewController~ipad.h`
    - `RZMainViewController~ipad.xib`

### Implementation Files (`.m`)

- framework `@import`s

- application header imports
    - cluster different kinds of imports together, with comments if many types are present
        - view controllers
        - custom views/cells
        - data model/managers
        - categories (always in their own files, never in-line)
        - constant files
        - third party software
- `typedef`ed `enum`s, block signatures
- macros
- constant definitions
- `@interface` extension
    - Protocol conformations not needed by subclasses. See also: [Rule of Three](#rule-of-three)
        - See [Header file](#header-files-h) section
    - `IBAction` method declarations
        - These are optional, and should be included only for clarity
    - Not necessary to declare delegate/private methods or property overrides
- `@implementation`
    - organize sections with `#pragma mark -`
    - `@synthesize` statements
        - only use when necessary, such as with read-only properties
    - class methods
    - `init` & `dealloc`
    - view lifecycle
    - notification handlers
    - delegate callbacks
    - `IBAction` handlers
    - overridden property getters/setters
        - getter and setter for same property should appear consecutively
    - public interface methods
    - private interface methods
