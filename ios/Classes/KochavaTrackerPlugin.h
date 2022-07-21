//
//  KochavaTracker (Flutter)
//
//  Copyright (c) 2020 - 2022 Kochava, Inc. All rights reserved.
//

#pragma mark - Import

#import <Flutter/Flutter.h>
#import <KochavaTracker/KochavaTracker.h>

#pragma mark - Interface

@interface KochavaTrackerPlugin : NSObject<FlutterPlugin>

#pragma mark - Methods

// Method channel property for native to dart communication.
@property (strong, nonatomic) FlutterMethodChannel *channel;

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel;

@end
