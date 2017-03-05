//
//  UIImageView+HMWebImage.h
//  08 - 自定义NSOperation子类初体验
//
//  Created by 胡卓 on 2017/3/4.
//  Copyright © 2017年 胡卓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (HMWebImage)

@property(nonatomic,copy)NSURL *lastURL;

//只会生成setter和getter方法的声明，其他什么都不会生成
-(void)hm_setImageWithURL:(NSURL *)url;


-(void)hm_setImageWithURL:(NSURL *)url andPlaceHolderImg:(UIImage *)img;


@end
