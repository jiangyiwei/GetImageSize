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

+(void)getImageSizeWithURL:(id)imageURL imageBlock:(void(^)(CGSize imageSize))block;

@end
