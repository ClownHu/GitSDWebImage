//
//  HMDownloadOpManager.h
//  08 - 自定义NSOperation子类初体验
//
//  Created by 胡卓 on 2017/3/3.
//  Copyright © 2017年 胡卓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMDownloadOpManager : NSObject

-(void)mangerWithURL:(NSURL *)url andSuccessandsuccessBlock:(void(^)(UIImage *img))bk;
//类方法（单例对象一般都要提供一个类方法）
+(instancetype)sharedManager;


-(void)cancelLastOP:(NSURL *)lastURL;
@end
