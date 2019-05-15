//
//  THNewFeatureController.h
//  TopHoldFirmBargain
//
//  Created by 塔利班 on 15/7/28.
//  Copyright (c) 2015年 Agan. All rights reserved.
//

typedef void (^operation)();

#import <UIKit/UIKit.h>

@interface THNewFeatureController : UIViewController
@property (nonatomic, copy) operation operation;
@end
