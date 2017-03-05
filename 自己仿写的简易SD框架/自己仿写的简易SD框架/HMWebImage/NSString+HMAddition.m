//
//  NSString+HMAddition.m
//  06-使用第三方框架异步加载图片
//
//  Created by HM09 on 17/3/1.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "NSString+HMAddition.h"
#import "NSString+Hash.h"


@implementation NSString (HMAddition)

-(instancetype)hm_getImgPath{
    
    //获取沙盒中缓存目录
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    
    //获取这个路径字符串的最后那一部分的文件名+文件后缀
    NSString *fileName = [self lastPathComponent];
    
    //沙盒保存时名称md5格式
    fileName = [fileName md5String];
    
    //拼接文件名
    return [cachesPath stringByAppendingPathComponent:fileName];
}

@end
