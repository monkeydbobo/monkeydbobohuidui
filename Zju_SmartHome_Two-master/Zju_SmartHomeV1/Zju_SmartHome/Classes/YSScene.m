//
//  YSScene.m
//  Zju_SmartHome
//
//  Created by lysongzi on 16/1/4.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import "YSScene.h"

@implementation YSScene


+(instancetype)statusWithDict:(NSDictionary *)dict
{
    return  [[self alloc]initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        self.logic_id = dict[@"equipment_logic_id"];
        self.type=dict[@"type"];
        self.name = dict[@"scene_name"];
        self.area = dict[@"room_name"];
        
        if([self.name isEqualToString:@"柔和"])
        {
            self.logoName = @"rouhe_icon";
        }
        else if([self.name isEqualToString:@"舒适"])
        {
            self.logoName = @"shushi_icon";
        }
        else if([self.name isEqualToString:@"明亮"])
        {
            self.logoName = @"mingliang_icon";
        }
        else if([self.name isEqualToString:@"跳跃"])
        {
            self.logoName = @"tiaoyue_icon";
        }
        else if([self.name isEqualToString:@"R"])
        {
            self.logoName = @"R";
        }
        else if([self.name isEqualToString:@"G"])
        {
            self.logoName = @"G";
        }
        else if([self.name isEqualToString:@"B"])
        {
            self.logoName = @"B";
        }
        
        self.bkgName = dict[@"image"];
        self.param1 = dict[@"param1"];
        self.param2 = dict[@"param2"];
        self.param3 = dict[@"param3"];
    }
    
    return  self;
}


@end
