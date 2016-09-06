//
//  ViewController.m
//  getImageSizeDemo
//
//  Created by 江义伟 on 16/9/6.
//  Copyright © 2016年 江义伟. All rights reserved.
//

#import "ViewController.h"
#import "GetImageSize.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    @""
    // Do any additional setup after loading the view, typically from a nib.
    NSString *imageString = @"http://scimg.jb51.net/allimg/160815/103-160Q509544OC.jpg";
    [GetImageSize getImageSizeWithURL:imageString imageBlock:^(CGSize imageSize) {
       NSLog(@"%@",NSStringFromCGSize(imageSize));
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
