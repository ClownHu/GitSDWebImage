//
//  UIImageView+HMWebImage.m
//  08 - 自定义NSOperation子类初体验
//
//  Created by 胡卓 on 2017/3/4.
//  Copyright © 2017年 胡卓. All rights reserved.
//

#import "UIImageView+HMWebImage.h"
#import "HMDownloadOpManager.h"
#import <objc/runtime.h>


@implementation UIImageView (HMWebImage)


//给它类似写一个属性，OC在运行时候可以通过一些代码来做事情
-(void)setLastURL:(NSURL *)lastURL {
    
    
    objc_setAssociatedObject(self, @"last", lastURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}


-(NSURL *)lastURL {
    
    return objc_getAssociatedObject(self, @"last");
}



-(void)hm_setImageWithURL:(NSURL *)url {
    
    [self setImgWith:url andPlaceHolderImg:nil];
    
}


-(void)hm_setImageWithURL:(NSURL *)url andPlaceHolderImg:(UIImage *)img {
    
    [self setImgWith:url andPlaceHolderImg:img];
}



-(void)setImgWith:(NSURL*)url andPlaceHolderImg:(UIImage*)holdImg {
    
    if (holdImg) {
        
        self.image = holdImg;
    }
    
    HMDownloadOpManager *manager = [HMDownloadOpManager sharedManager];
    
    //在这里判断是否取消上一次的操作对象，不一样，就取消
    if (![url.description isEqualToString:self.lastURL.description] &&self.lastURL) {
        
        //取消上一条操作对象
        [manager cancelLastOP:self.lastURL];
        
    };
    
    
    [manager mangerWithURL:url andSuccessandsuccessBlock:^(UIImage *img) {
        
        //更新UI
        self.image = img;
    }];
    
    
    //记录上次访问的URL
    self.lastURL = url;
}






@end
