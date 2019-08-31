//
//  ZJTestLayerViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/7/10.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestLayerViewController.h"

@interface ZJTestLayerViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *cellTitles;

@end

@implementation ZJTestLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self initSettiing];
}

- (void)initAry {
    self.cellTitles = @[
                        @[@"左上圆角", @"右上圆角", @"左下圆角", @"右下圆角", @"上边", @"左边", @"右边", @"下边"],
                        @[@"上边框", @"下边框", @"左边框", @"右边框"]
                        ];
}

- (void)initSettiing {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellTitles[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SystemTableViewCell];
    if (!cell) {
        cell = [[ZJNormalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SystemTableViewCell];
    }
    cell.textLabel.text = self.cellTitles[indexPath.section][indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
/*
 UIBorderSideTypeAll  = 0,
 UIBorderSideTypeTop = 1 << 0,
 UIBorderSideTypeBottom = 1 << 1,
 UIBorderSideTypeLeft = 1 << 2,
 UIBorderSideTypeRight = 1 << 3,
 };
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        UIRectCorner corner;
        if (indexPath.row < 4) {
            corner = (NSUInteger)pow(2, indexPath.row);
        }else {
            if (indexPath.row == 4) {
                corner = UIRectCornerTopLeft | UIRectCornerTopRight;
            }else if (indexPath.row == 5) {
                corner = UIRectCornerTopLeft | UIRectCornerBottomLeft;
            }else if (indexPath.row == 6) {
                corner = UIRectCornerTopRight | UIRectCornerBottomRight;
            }else {
                corner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            }
        }
        [self.bgView addMaskLayerAtRoundingCorners:corner cornerRadii:CGSizeMake(10, 10)];
    }else {
        UIBorderSideType sideType = (NSUInteger)pow(2, indexPath.row);
        [self.bgView addBorderForColor:[UIColor redColor] borderWidth:2 borderType:sideType];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return DefaultSectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return FLT_EPSILON;
}

- (void)addBorders:(UIRectCorner)corners {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(10, 10)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = maskPath.CGPath;
    self.bgView.layer.mask = shapeLayer;
}
/*
- (void)viewDidLoad {
    [super viewDidLoad];

//    UIView *testview = [[UIView alloc] initWithFrame:self.bgView.bounds];
//    [self.bgView addSubview: testview];
//
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:testview.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(16,16)];
//    //创建 layer
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = testview.bounds;
//    //赋值
//    maskLayer.path = maskPath.CGPath;
//    testview.layer.mask = maskLayer;
//    maskLayer.borderWidth = 10;
//    maskLayer.borderColor = [UIColor greenColor].CGColor;

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = maskPath.CGPath;
    self.bgView.layer.mask = shapeLayer;
    
//    CAShapeLayer *borderLayer=[CAShapeLayer layer];
//    borderLayer.path = maskPath.CGPath;
//    borderLayer.fillColor = [UIColor clearColor].CGColor;
//    borderLayer.strokeColor = [UIColor redColor].CGColor;
//    borderLayer.lineWidth = 2;
//    borderLayer.frame = self.bgView.bounds;
//    [borderLayer setName:@"lit"];
//    [self.bgView.layer addSublayer:borderLayer];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
