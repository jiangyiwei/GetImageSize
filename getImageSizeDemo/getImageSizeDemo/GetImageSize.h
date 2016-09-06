//
//  GetImageSize.h
//  getImageSizeDemo
//
//  Created by 江义伟 on 16/9/6.
//  Copyright © 2016年 江义伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GetImageSize : NSObject

/**
 *  获取图片尺寸
 *
 *  @param imageURL 图片地址String
 *  @param block    图片尺寸
 */
+(void)getImageSizeWithURLString:(NSString *)imageURLString imageBlock:(void(^)(CGSize imageSize))getSize;

@end
