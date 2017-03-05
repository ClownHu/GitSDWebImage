//
//  HMDownloadOpManager.m
//  08 - 自定义NSOperation子类初体验
//
//  Created by 胡卓 on 2017/3/3.
//  Copyright © 2017年 胡卓. All rights reserved.
//

#import "HMDownloadOpManager.h"
#import "HMImageDownloader.h"
#import "NSString+HMAddition.h"
#import "HMModel.h"


@interface HMDownloadOpManager ()

//图片的内存缓存
@property(nonatomic,strong)NSCache *cacheImgs;


@property(nonatomic,strong)NSOperationQueue *queue;

//记录操作对象
@property(nonatomic,strong)NSMutableDictionary *cacheOp;

////记录上一次的URL
//@property(nonatomic,strong)NSURL *lastURL;

@end
@implementation HMDownloadOpManager

//单例
+(instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static HMDownloadOpManager *obj = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        obj = [super allocWithZone:zone];
        //一定要实例化
        obj.queue = [NSOperationQueue new];
        obj.cacheImgs = [NSCache new];
        obj.cacheOp = [NSMutableDictionary dictionary];
        
        
        //订阅内存警告的通知
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        
        //如果接收到内存警告的通知，就订阅
        [center addObserver:obj selector:@selector(clearCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
    });
    return obj;
    
}


//接收内存警告会来调用的方法
-(void)clearCache {
    
    NSLog(@"触发内存警告了。  ");
    
    //清除所有缓存的图片
    [_cacheImgs removeAllObjects];
    
    //清除操作对象
    [_cacheOp removeAllObjects];
    
 
}

+(instancetype)sharedManager {
    
    return [[self alloc]init];
}


#pragma mark --管理者的对象方法
-(void)mangerWithURL:(NSURL *)url andSuccessandsuccessBlock:(void(^)(UIImage *img))bk {
    
    
#pragma mark - 从内存缓存中去找
    //当控制器一旦调用这个方法，是为了下载
    //所以，一开始看内存中有没有，有就直接从缓存中取
    if ([self.cacheImgs objectForKey:url]) {
        
        NSLog(@"从内存缓存中读取来的");
        
        //直接回调
        bk([self.cacheImgs objectForKey:url]);
        return;
    };
  
    
#pragma mark - 从沙盒缓存中去找
    //再去沙盒找
    NSString *cachePath = [url.description hm_getImgPath];
    
    //获取图片
    UIImage *image = [UIImage imageWithContentsOfFile:cachePath];
    
    if (image) {
        
        NSLog(@"从沙盒读取。 ");
        bk(image);
        
        return;
    }
    
    //判断这一次的URL和上一次的是否一样 ，不一样则取消上一条任务，开启下一条
    //注意：url不能直接用==来判断。先转成字符串，再用字符串判断内容是否相同
//    if (![url.description isEqualToString:self.lastURL.description] &&self.lastURL) {
//        
//        //取消上一条任务
//        [self.cacheOp objectForKey:self.lastURL];//实际上是把这个操作对象的取消状态改为YES
//        
//    };
    
    
    //创建操作对象
    HMImageDownloader *op = [HMImageDownloader imageDownloaderWithURL:url andsuccessBlock:^(UIImage *img) {
        
        if (img) {
            //存到内存缓存中
            [self.cacheImgs setObject:img forKey:url.description];
            
            
            //再写入到沙盒
            //得到要写入的沙盒路径
            NSString *path = [url.description hm_getImgPath];
            
            //此方法可以直接将UIImage转成NSData
            NSData *data = UIImagePNGRepresentation(img);
            
            //写入到沙盒
            [data writeToFile:path atomically:YES];
            
        }
        
        bk(img);
        //操作完了，应该移除缓存池
        [self.cacheOp removeObjectForKey:url];
        
    }];
    
    
    //记录刚刚产生的操作对象
    [_cacheOp setObject:op forKey:url];
    
    //把操作对象加入到队列对象里去
    [self.queue addOperation:op];
    
}


-(void)cancelLastOP:(NSURL *)lastURL {
    
    HMImageDownloader *op = [self.cacheOp objectForKey:lastURL];
    
    [op cancel];
    
    //取消以后，移除这个操作
     [self.cacheOp removeObjectForKey:lastURL];
    
}

@end
