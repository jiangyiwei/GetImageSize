//
//  GetImageSize.m
//  getImageSizeDemo
//
//  Created by 江义伟 on 16/9/6.
//  Copyright © 2016年 江义伟. All rights reserved.
//

#import "GetImageSize.h"

@implementation GetImageSize

// 根据图片url获取图片尺寸格式
+(void)getImageSizeWithURLString:(NSString *)imageURLString imageBlock:(void(^)(CGSize imageSize))getSize{
    // 图片地址不正确返回CGSizeZero
    if(imageURLString == nil || [imageURLString isEqualToString:@""]){
        getSize(CGSizeZero);
        return;
    }
    
    NSURL *URL = [NSURL URLWithString:imageURLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString *pathExtendsion = [URL.pathExtension lowercaseString];
    
    if([pathExtendsion isEqualToString:@"png"]){
        [self getPNGImageSizeWithRequest:request PNGImageBlock:^(CGSize PNGImageSize) {
            getSize(PNGImageSize);
        }];
    }
    else if([pathExtendsion isEqual:@"gif"]){
        [self getGIFImageSizeWithRequest:request GIFImageBlock:^(CGSize GIFImageSize) {
            getSize(GIFImageSize);
        }];
    }else{
        [self getJPGImageSizeWithRequest:request JPGImageBlock:^(CGSize JPGImageSize) {
            getSize(JPGImageSize);
        }];
    }
    
    // 如果获取文件头信息失败,发送异步请求请求原图
    if(CGSizeEqualToSize(CGSizeZero, CGSizeZero)){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    getSize(image.size);
                }
            }];
            [dataTask resume];
        });
    }
}

/**
 *  通过网络请求，获取PNG格式图片data
 *
 *  @param request    网络请求
 *  @param getPNGSize PNG图片尺寸
 */
+(void)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request PNGImageBlock:(void(^)(CGSize PNGImageSize))getPNGSize{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        CGSize size = [self getPNGImageSize:data];
        getPNGSize(size);
    }];
    [dataTask resume];
}

/**
 *  获取PNG格式图片尺寸
 *
 *  @param data 图片data
 *
 *  @return PNG格式图片尺寸
 */
+(CGSize)getPNGImageSize:(NSData *)data{
    if(data.length == 8){
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

/**
 *  通过网络请求，获取GIF格式图片data
 *
 *  @param request    网络请求
 *  @param getGIFSize GIF图片尺寸
 */
+(void)getGIFImageSizeWithRequest:(NSMutableURLRequest *)request GIFImageBlock:(void(^)(CGSize GIFImageSize))getGIFSize{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        CGSize size = [self getGIFImageSize:data];
        getGIFSize(size);
    }];
    [dataTask resume];
}

/**
 *  获取GIF格式图片尺寸
 *
 *  @param data 图片data
 *
 *  @return GIF格式图片尺寸
 */
+(CGSize)getGIFImageSize:(NSData *)data{
    if(data.length == 4){
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

/**
 *  通过网络请求，获取JPG格式图片data
 *
 *  @param request    网络请求
 *  @param getJPGSize JPG格式图片尺寸
 */
+(void)getJPGImageSizeWithRequest:(NSMutableURLRequest *)request JPGImageBlock:(void(^)(CGSize JPGImageSize))getJPGSize{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        CGSize size = [self getJPGImageSize:data];
        getJPGSize(size);
    }];
    [dataTask resume];
}

/**
 *  获取JPG格式图片尺寸
 *
 *  @param data 图片data
 *
 *  @return JPG格式图片尺寸
 */
+(CGSize)getJPGImageSize:(NSData *)data{
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}

@end
