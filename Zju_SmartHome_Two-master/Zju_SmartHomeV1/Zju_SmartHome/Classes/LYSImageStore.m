//
//  LYSImageStore.m
//  Homepwen
//
//  Created by lysongzi on 15/11/25.
//  Copyright © 2015年 lysongzi. All rights reserved.
//

#import "LYSImageStore.h"

@interface LYSImageStore ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

-(NSString *)imagePathForKey:(NSString *)key;

@end

@implementation LYSImageStore

+(instancetype)sharedStore
{
    static LYSImageStore *instance = nil;
    //确保多线程中只创建一次对象,线程安全的单例
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initPrivate];
    });
    
    return instance;
}

-(instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
        
        //注册为低内存通知的观察者
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(clearCaches:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
    }
    return self;
}

-(void)setImage:(UIImage *)image forKey:(NSString *)key
{
    [self.dictionary setObject:image forKey:key];
    
    //获取保存图片的全路径
    NSString *path = [self imagePathForKey:key];
    
    //从图片提取JPEG格式的数据,第二个参数为图片压缩参数
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    //将图片数据写入文件
    [data writeToFile:path atomically:YES];
}

-(UIImage *)imageForKey:(NSString *)key
{
    UIImage *image = [self.dictionary objectForKey:key];
    if (!image) {
        NSString *path = [self imagePathForKey:key];
        
        image = [UIImage imageWithContentsOfFile:path];
        if (image) {
            [self.dictionary setObject:image forKey:key];
        }
        else
        {
            //NSLog(@"Error: unable to find %@", [self imagePathForKey:key]);
        }
    }
    return image;
}

-(void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
    
    //删除已保存的图片文件
    NSString *path = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

-(NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:key];
}

-(void)clearCaches:(NSNotification *)n
{
    //NSLog(@"Flushing %ld images out of the cache", [self.dictionary count]);
    [self.dictionary removeAllObjects];
}

@end
