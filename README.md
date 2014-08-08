# Raizlabs Objective-C Style Guide

This guide outlines the coding conventions and best practices for the Objective-C developers at Raizlabs.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [Dot Syntax](#dot-syntax)

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

## Whitespace

### Newlines

- Never more than one consecutive newline of whitespace
- Use one newline of whitespace to separate out conceptually separate bits of methods.

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

Variables always use camel case

```objc
likeThis;
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
