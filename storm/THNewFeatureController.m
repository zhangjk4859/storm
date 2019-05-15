//
//  THNewFeatureController.m
//  TopHoldFirmBargain
//
//  Created by 塔利班 on 15/7/28.
//  Copyright (c) 2015年 Agan. All rights reserved.
//

#import "THNewFeatureController.h"
#import <Masonry/Masonry.h>

#define ThreeImageViewTag 1000

@interface THNewFeatureController () <UIScrollViewDelegate>
@property(nonatomic,strong)NSArray *infoArray;
@end

static NSString *kTitle = @"title";
static NSString *kContent = @"content";

@implementation THNewFeatureController


#pragma mark getters && setters ++++++++++++++++++++++++++++++++++++

+(void)load{
    [super load];
    
}

-(NSArray *)infoArray{
    if (!_infoArray) {
        _infoArray = @[
                       @{
                         kTitle:@"step1",
                         kContent:@""
                         },
                       @{
                           kTitle:@"step2",
                           kContent:@""
                        }
                       ];
    }
    return _infoArray;
}


#pragma mark view lifes ++++++++++++++++++++++++++++++++++++

- (void)viewDidLoad {
    [super viewDidLoad];

    /** 添加引导视图 */
    [self addNewFeatureImageView];
    
//    if (@available(iOS 11.0,*)) {
//        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }

}

/**
 控制器出现在屏幕时 控制是否显示状态栏
 @return yes 隐藏  默认NO显示
 */
- (BOOL)prefersStatusBarHidden{
    return YES;
}


#pragma mark views++++++++++++++++++++++++++++++++++++
/** 添加引导视图 */
- (void)addNewFeatureImageView
{
    CGFloat screen_width = UIScreen.mainScreen.bounds.size.width;
    CGFloat screen_height = UIScreen.mainScreen.bounds.size.height;
    UIScrollView *baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
//    baseScrollView.frame = [UIScreen mainScreen].applicationFrame;
    baseScrollView.pagingEnabled = YES;
    baseScrollView.delegate = self;
    baseScrollView.bounces = NO;
    baseScrollView.backgroundColor = [UIColor redColor];
    baseScrollView.showsHorizontalScrollIndicator = NO;
    baseScrollView.backgroundColor = [UIColor whiteColor];
    baseScrollView.contentSize = CGSizeMake(screen_width * self.infoArray.count, baseScrollView.contentSize.height);
    if (@available(iOS 11.0, *)) {
        baseScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:baseScrollView];
    
    for(int i = 0 ; i < self.infoArray.count; i ++) {
        NSDictionary *dic = self.infoArray[i];
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(screen_width*i, 0, screen_width, screen_height)];
        [baseScrollView addSubview:containerView];
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"step%d",i+1]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.userInteractionEnabled = YES;
        imageView.frame = containerView.bounds;
        [containerView addSubview:imageView];
        /*
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(screen_width, image.size.height * screen_width / image.size.width));
            make.center.equalTo(containerView);
        }];
         */
        
        
        if (i == self.infoArray.count - 1) {
            // 122 84 223
            UIButton *clickBtn = [UIButton new];
            clickBtn.clipsToBounds = YES;
            clickBtn.layer.cornerRadius = 4.f;
            [clickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [clickBtn setBackgroundColor:[UIColor colorWithRed:122 / 255.0 green:84 / 255.0 blue:223 / 255.0 alpha:1.0]];
            [clickBtn  setTitle:@"立即体验" forState:UIControlStateNormal];
            [clickBtn addTarget:self action:@selector(getIntoMainView:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [containerView addSubview:clickBtn];
            [clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(190.f, 44.f));
                make.centerY.equalTo(containerView).multipliedBy(1.8);
                make.centerX.equalTo(containerView);
            }];
            clickBtn.layer.cornerRadius = 22;
        }
        

    }
    
    
}


#pragma mark actions++++++++++++++++++++++++++++++++++++
- (void)getIntoMainView:(UIButton *)btn {
    if (self.operation) {
        self.operation();
    }
}

//-(void)ww{
//
//
//    NSString *path_document = NSHomeDirectory();
//     NSString *imagePath=[path_document stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@%@%@.png",_shopObj.shopPicture,_shopObj.shopColor,self.shopObj.shopName]];
//     UIImage *img=[UIImage imageWithContentsOfFile:imagePath];
//     cell.imgV.image=img;
//
//
//
//
//
//
//
//
//    for (Book *book in postilBooksArr) {  //待操作的文件
//        NSString *path = [NSString stringWithFormat:@"%@%ld/",kBookFilePath,book.sid];  //文件所在路径
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//
//        NSString *path = [];
//
//        NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:path];  // 划重点
//        for (NSString *fileName in enumerator) { //  fileName 就是遍历到的每一个文件文件名
//            if ([fileName hasPrefix:@"zztemp_"]) {
//                NSString *moveFileName = [fileName stringByReplacingOccurrencesOfString:@"temp_" withString:@""];
//                NSString *moveToPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",moveFileName]];  // 替换的文件的终极路径
//                [fileManager removeItemAtPath:moveToPath error:nil]; // 将终极路径的文件删除
//                NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]]; //用于替换的文件的路径
//                [fileManager moveItemAtPath:filePath toPath:moveToPath error:nil]; // 替换
//            }
//        }
//
//}



#pragma mark delegates ############################################




@end
