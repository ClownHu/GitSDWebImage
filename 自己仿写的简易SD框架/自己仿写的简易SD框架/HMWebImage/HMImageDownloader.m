//
//  HMImageDownloader.m
//  08 - 自定义NSOperation子类初体验
//
//  Created by 胡卓 on 2017/3/2.
//  Copyright © 2017年 胡卓. All rights reserved.
//

#import "HMImageDownloader.h"

@interface HMImageDownloader ()

//接收外界传入的图片地址
@property(nonatomic,strong)NSURL *url;

//接收外界传入的图片下载完成的代码块
@property(nonatomic,strong)void(^bk)(UIImage*img);
@end


@implementation HMImageDownloader

+(instancetype)imageDownloaderWithURL:(NSURL *)url andsuccessBlock:(void (^)(UIImage *))bk {
    
    HMImageDownloader *op = [[HMImageDownloader alloc]init];
    
    op.url = url;
    
    op.bk = bk;
    
    return op;
}



//因为main方法一旦被调用就可以证明，这个操作是可以进行的
-(void)main {
    
    NSLog(@"开始读取图片。  %@",self.url);
    //模拟网络延时
    [NSThread sleepForTimeInterval:1.0];
    
    
    NSData *data = [NSData dataWithContentsOfURL:self.url];
    
    if (self.isCancelled) {
        
        NSLog(@"操作被取消了。 %@",self.url);
        return;
    }
    
    //读取图片
    UIImage *img = [UIImage imageWithData:data];
    
    
    NSLog(@"%@  %@",img,[NSThread currentThread]);
    
    //现在想要更新UI,但是又不方便去做，所以用代理或是block
    //放在主线程里去做
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        
        self.bk(img);
    }];
}



@end
