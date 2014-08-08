# Raizlabs Objective-C Style Guide

This guide outlines the coding conventions and best practices for the Objective-C developers at Raizlabs.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [Dot Syntax](#dot-syntax)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Dot Syntax
- Use dot notation for all property access and manipulation
- **Never** access `_ivars` directly when a property has been declared, except where required:

    Preferred:

```objc
self.foo = 4;
int bar = self.foo;
```

    Not:

```objc
[self setFoo:4];
int bar = [self foo];
_bar = 4;
```

- For clarity, you may use bracket notation for overridden setters/getters:

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

- **Never** use dot notation on a non-[idempotent](http://en.wikipedia.org/wiki/Idempotent) property or method

    - For example, `count` isn't actually a property on `NSArray`; The compiler just infers because there's a method called count. However, it *is* an idempotent method, so it is safe to use dot-notation:

            NSUInteger foo = myArray.count;

- Avoid non-idempotent setters

    Bad:

```objc
- (void)setFoo:(id)foo
{
    _foo = foo;
    _lastTimeFooWasSet = [NSDate date];
   [self.tableView reloadData];
}

    Better:

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

    - this is not to say that you shouln't override setters; you just need to be careful that the side effects are obvious, and with low potential danger
