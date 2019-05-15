//
//  UIScrollView+PlaceholderView.h
//  UIScrollViewPlaceholderView
//
//  Created by 蔡强 on 2017/9/17.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

#import <UIKit/UIKit.h>

/** UIView的占位图类型 */
typedef NS_ENUM(NSInteger, CQPlaceholderViewType) {
    /** 没网 */
    CQPlaceholderViewTypeNoNetwork,
    /** 没商品 */
    CQPlaceholderViewTypeNoGoods,
    /** 没评论 */
    CQPlaceholderViewTypeNoComment
};

@interface UIView (PlaceholderView)

/** 占位图 */
@property (nonatomic, strong, readonly) UIView *cq_placeholderView;

#pragma mark - 展示占位图
/**
 展示UIView及其子类的占位图，大小和view一样（本质是在这个view上添加一个自定义view）

 @param type 占位图类型
 @param reloadBlock 重新加载回调的block
 */
- (void)cq_showPlaceholderViewWithType:(CQPlaceholderViewType)type reloadBlock:(void(^)())reloadBlock;

#pragma mark - 主动移除占位图
/**
 主动移除占位图
 占位图会在你点击“重新加载”按钮的时候自动移除，你也可以调用此方法主动移除
 */
- (void)cq_removePlaceholderView;

@end
