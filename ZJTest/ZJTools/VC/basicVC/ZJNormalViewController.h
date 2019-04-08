//
//  ZJNormalViewController.h
//  ZJTest
//
//  Created by ZJ on 2019/3/21.
//  Copyright © 2019 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJNormalViewController : UIViewController

@property (nonatomic, assign) BOOL needRefresh;
@property (nonatomic, strong) NSArray *placeholds, *icons, *values, *titles, *vcNames, *cellTitles, *sectionTitles, *nibs, *units, *keys, *selectRows;
@property (nonatomic, strong) NSMutableArray *mutablePlaceholds, *mutableIcons, *mutableValues, *mutableTitles, *mutableVCNames, *mutableCellTitles, *mutableSectionTitles, *mutableNibs, *mutableUnits, *mutableKeys, *mutableSelectRows;

@end

NS_ASSUME_NONNULL_END
