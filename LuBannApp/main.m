//
//  main.m
//  LuBannApp
//
//  Created by Fr@nk on 12/08/12.
//  Copyright (c) 2012 Fr@nk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LuBannAppAppDelegate.h"



int main(int argc, char *argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    //int retVal = UIApplicationMain(argc, argv, nil, nil);
    int retVal = UIApplicationMain(argc, argv, nil, @"LuBannAppAppDelegate");
    [pool release];
    return retVal;
}
