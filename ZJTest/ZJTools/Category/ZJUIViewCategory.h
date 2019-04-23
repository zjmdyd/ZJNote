//
//  ZJUIViewCategory.h
//  ZJCustomTools
//
//  Created by ZJ on 6/13/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJUIViewCategory : NSObject

@end


#pragma mark - UIBarButtonItem

@interface UIBarButtonItem (ZJBarButtonItem)

/**
 *  根据自定义view创建一个UIBarButtonItem
 *
 */
+ (UIBarButtonItem *)barbuttonWithCustomView:(UIView *)view;

@end


#pragma mark - UIColor

@interface UIColor (ZJColor)

/**
 *  半透明遮罩层
 */
+ (UIColor *)maskViewColor;
+ (UIColor *)maskViewAlphaColor;

/**
 *  粉红色
 */
+ (UIColor *)pinkColor;

@end


#pragma mark - UIImage

@interface UIImage (ZJImage)

+ (UIImage *)imageWithPath:(NSString *)path placehold:(NSString *)placehold;
+ (UIImage *)imageWithPath:(NSString *)path size:(CGSize)size opaque:(BOOL)opaque;
+ (UIImage *)imageWithPath:(NSString *)path placehold:(NSString *)placehold size:(CGSize)size opaque:(BOOL)opaque;

/**
 *  根据颜色获取UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  根据颜色获取UIImage
 *  @param frame  特定区域着色
 */
+ (UIImage *)imageWithColor:(UIColor *)color frame:(CGRect)frame;

#pragma mark - 生成二维码

+ (UIImage *)qrImageWithContent:(NSString *)content;

/**
 *   色值 0~255
 */
+ (UIImage *)qrImageWithContent:(NSString *)content size:(CGFloat)size red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

+ (UIImage *)qrImageWithContent:(NSString *)content logo:(UIImage *)logo size:(CGFloat)size red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

@end


#pragma mark - UIImageView

/**
 *  二维码
 */
@interface UIImageView (ZJImageView)

+ (UIImageView *)imageViewWithFrame:(CGRect)frame path:(NSString *)path;
+ (UIImageView *)imageViewWithFrame:(CGRect)frame path:(NSString *)path placehold:(NSString *)placehold;

@end

#pragma mark - UILabel

@interface UILabel (ZJSelectLabel)

+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(id)text background:(UIColor *)color;
+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(id)text background:(UIColor *)color needCorner:(BOOL)need;

/**
 *  根据文本内容适配Label高度
 */
- (CGSize)fitSizeWithWidth:(CGFloat)width;

+ (CGSize)fitSizeWithWidth:(CGFloat)width text:(NSString *)text;
+ (CGSize)fitSizeWithHeight:(CGFloat)height text:(NSString *)text;
+ (CGSize)fitSizeWithWidth:(CGFloat)width text:(NSString *)text font:(UIFont *)font;
+ (CGSize)fitSizeWithMargin:(CGFloat)margin text:(NSString *)text font:(UIFont *)font;

/**
 *  获取适合的font
 *
 *  @param pSize  初始fontSize
 *  @param width  label的宽度
 *  @param height label的高度, label的最大可容纳高度
 *  @param descend font是否是递减
 */
- (void)fitFontWithPointSize:(CGFloat)pSize width:(CGFloat)width height:(CGFloat)height descend:(BOOL)descend;

/**
 斜体
 */
- (void)italicFont;

@end


#pragma mark - UICollectionView

@interface UICollectionView (ZJCollectionView)

- (void)registerCellWithSysIDs:(NSArray *)sysIDs;
- (void)registerCellWithNibIDs:(NSArray *)nibIDs;
- (void)registerCellWithNibIDs:(NSArray *)nibIDs sysIDs:(NSArray *)sysIDs;
- (void)registerNibs:(NSArray *)nibIDs forSupplementaryViewOfKind:(NSString *)kind;

@end

#pragma mark - UITableView

static NSString *const SystemTableViewCell = @"UITableViewCell";
static NSString *const SystemNormalTableViewCell = @"ZJNormalTableViewCell";

@interface UITableView (ZJTableView)

- (void)registerCellWithSysIDs:(NSArray *)sysIDs;
- (void)registerCellWithNibIDs:(NSArray *)nibIDs;
- (void)registerCellWithNibIDs:(NSArray *)nibIDs sysIDs:(NSArray *)sysIDs;

+ (UISwitch *)accessorySwitchWithTarget:(id)target;
+ (UIButton *)accessoryButtonWithTarget:(id)target title:(NSString *)title;

@end


#pragma mark - UIView

@interface UIView (ZJUIView)

- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color;
- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

- (void)setCornerRadius:(CGFloat)radius;

/**
 *  添加tap手势
 *
 *  @param delegate 当不需要delegate时可设为nil
 */

- (void)addTapGestureWithDelegate:(id <UIGestureRecognizerDelegate>)delegate target:(id)target;

+ (UIView *)maskViewWithFrame:(CGRect)frame;
- (UIView *)subViewWithTag:(NSInteger)tag;
- (UIView *)fetchSubViewWithClassName:(NSString *)className;
- (UIView *)fetchSuperViewWithClassName:(NSString *)className;

// 左文字右图片
+ (UIView *)createTitleIVWithFrame:(CGRect)frame path:(NSString *)path placehold:(NSString *)placehold title:(NSString *)title;

#pragma mark - supplementView

/**
 普通文本
 @return 文本背景色
 */
+ (UIView *)supplementViewWithText:(NSString *)text;
+ (UIView *)supplementViewWithText:(NSString *)text supplementViewBgColor:(UIColor *)color;
/**
 
 带属性文本
 @return 文本背景色
 */
+ (UIView *)supplementViewWithAttributeText:(NSAttributedString *)text;
+ (UIView *)supplementViewWithAttributeText:(NSAttributedString *)text supplementViewBgColor:(UIColor *)color;

#pragma mark - iconBadge

- (void)removeIconBadge;
- (void)addIconBadgeWithText:(NSString *)text;
- (void)addIconBadgeWithText:(NSString *)text bgColor:(UIColor *)color;

- (void)addIconBadgeWithAttributeText:(NSAttributedString *)text;
- (void)addIconBadgeWithAttributeText:(NSAttributedString *)text bgColor:(UIColor *)color;
- (UILabel *)createLableWithText:(id)text bgColor:(UIColor *)color frame:(CGRect)frame;
- (UILabel *)accessoryViewWithText:(id)text bgColor:(UIColor *)color frame:(CGRect)frame;

- (void)addIconBadgeWithImage:(UIImage *)image;
- (void)addIconBadgeWithImage:(UIImage *)image bgColor:(UIColor *)color;

// 第几象限
typedef NS_ENUM(NSInteger, QuadrantTouchType) {
    QuadrantTouchTypeOfFirst,   
    QuadrantTouchTypeOfSecond,
    QuadrantTouchTypeOfThird,
    QuadrantTouchTypeOfFourth,
};

/*
 环形区域分隔的份数:2等分/4等分
 */
typedef NS_ENUM(NSInteger, AnnularSeparateType) {
    AnnularSeparateTypeOfHalf,
    AnnularSeparateTypeOfQuarter,
};

- (QuadrantTouchType)quadrantOfTouchPoint:(CGPoint)point separateType:(AnnularSeparateType)type;
- (BOOL)touchPointInTheAnnular:(CGPoint)point annularWidth:(CGFloat)annularWidth;

@end


#pragma mark - UINavigationBar

@interface UINavigationBar (ZJNavigationBar)

- (void)setBackgroundColor:(UIColor *)backgroundColor;
- (void)setHiddenSeparateLine:(BOOL)hidden;

@end


#pragma mark - UIGestureRecognizer

typedef NS_ENUM(NSInteger, Direction) {
    DirectionOfNoMove,
    DirectionOfUp,
    DirectionOfDown,
    DirectionOfLeft,
    DirectionOfRight,
};

@interface UIGestureRecognizer (ZJGestureRecognizer)

+ (Direction)direction:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end


#pragma mark - UISearchBar

@interface UISearchBar (ZJSearchBar)

- (void)setCancelBtnTitleColor:(UIColor *)color;

@end
