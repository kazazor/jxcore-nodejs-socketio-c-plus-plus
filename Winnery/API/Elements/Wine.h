//
//  Wines.h
//  Winery
//
//  Created by Nilit Rokah on 11/10/15.
//  Copyright © 2015 hacx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseItem.h"

@interface Wine : BaseItem

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *grapes;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *wineDescription;

@end
