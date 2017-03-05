//
//  HMImageDownloader.h
//  08 - 自定义NSOperation子类初体验
//
//  Created by 胡卓 on 2017/3/2.
//  Copyright © 2017年 胡卓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMImageDownloader : NSOperation



+(instancetype)imageDownloaderWithURL:(NSURL*)url andsuccessBlock:(void(^)(UIImage *img))bk;
@end
