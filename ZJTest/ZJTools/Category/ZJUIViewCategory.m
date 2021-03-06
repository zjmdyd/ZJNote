//
//  ZJUIViewCategory.m
//  ZJCustomTools
//
//  Created by ZJ on 6/13/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJUIViewCategory.h"
#import "ZJDefine.h"

@implementation ZJUIViewCategory

@end

#pragma mark - UIBarButtonItem

@implementation UIBarButtonItem (ZJBarButtonItem)

+ (UIBarButtonItem *)barbuttonWithCustomView:(UIView *)view {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    return item;
}

@end


#pragma mark - UIColor

@implementation UIColor (ZJColor)

+ (UIColor *)maskViewColor {
    return [UIColor colorWithRed:(40/255.0f) green:(40/255.0f) blue:(40/255.0f) alpha:1.0];
}

+ (UIColor *)maskViewAlphaColor {
    return [UIColor colorWithRed:(40/255.0f) green:(40/255.0f) blue:(40/255.0f) alpha:0.4];
}

+ (UIColor *)pinkColor {
    return [UIColor colorWithRed:0.9 green:0 blue:0 alpha:0.2];
}

@end


@implementation CIImage (ZJCIImage)

- (UIImage *)image {
    CGSize size = CGSizeMake(300, 300);
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:self fromRect:self.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1, -1);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    
    return codeImage;
}

@end


#pragma mark - UIImage

@implementation UIImage (ZJImage)

+ (UIImage *)imageWithPath:(NSString *)path placehold:(NSString *)placehold {
    UIImage *icon;

    if ([path hasPrefix:@"http:"] || [path hasPrefix:@"https:"]) {
        icon = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:path]]];
    }else {
        icon = [UIImage imageNamed:path];
    }
    if (icon == nil) {
        if (placehold.length == 0) {
            return nil;
        }
        icon = [UIImage imageNamed:placehold];
    }
    
    return icon;
}

+ (UIImage *)imageWithPath:(NSString *)path size:(CGSize)size opaque:(BOOL)opaque {
    return [UIImage imageWithPath:path placehold:@"" size:size opaque:opaque];
}

+ (UIImage *)imageWithPath:(NSString *)path placehold:(NSString *)placehold size:(CGSize)size opaque:(BOOL)opaque {
    UIImage *icon = [UIImage imageWithPath:path placehold:placehold];
    
    // 获得用来处理图片的图形上下文。利用该上下文，你就可以在其上进行绘图，并生成图片 ,三个参数含义是设置大小、透明度 （NO为不透明）、缩放（0代表不缩放）
    UIGraphicsBeginImageContextWithOptions(size, opaque, 0.0);
    CGRect frame = CGRectMake(0.0, 0.0, size.width, size.height);
    [icon drawInRect:frame];
    
    return UIGraphicsGetImageFromCurrentImageContext();
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self createImageWithColor:color frame:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
}

+ (UIImage *)imageWithColor:(UIColor *)color frame:(CGRect)frame {
    return [self createImageWithColor:color frame:frame];
}

+ (UIImage *)createImageWithColor:(UIColor *)color frame:(CGRect)frame {
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, frame);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 二维码

+ (CIImage *)imageWithContent:(NSString *)content {
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:data forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrImage = qrFilter.outputImage;
    return qrImage;
}

+ (UIImage *)qrImageWithContent:(NSString *)content {
    CIImage *qrImage = [UIImage imageWithContent:content];
    
    return [qrImage image];
}

void ProviderReleaseData (void *info, const void *data, size_t size) {
    free((void*)data);
}

+ (UIImage *)qrImageWithContent:(NSString *)content size:(CGFloat)size red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue {
    UIImage *image = [UIImage qrImageWithContent:content];
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,  kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }
        else
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

+ (UIImage *)qrImageWithContent:(NSString *)content logo:(UIImage *)logo size:(CGFloat)size red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue {
    UIImage* resultUIImage = [self qrImageWithContent:content size:size red:red green:green blue:blue];
    
    // 添加logo
    CGFloat logoW = resultUIImage.size.width / 5.;
    CGRect logoFrame = CGRectMake(logoW * 2, logoW * 2, logoW, logoW);
    UIGraphicsBeginImageContext(resultUIImage.size);
    [resultUIImage drawInRect:CGRectMake(0, 0, resultUIImage.size.width, resultUIImage.size.height)];
    [logo drawInRect:logoFrame];
    UIImage *kk = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return kk;
}

@end

#pragma mark - UIImageView

@implementation UIImageView (ZJImageView)

+ (UIImageView *)imageViewWithFrame:(CGRect)frame path:(NSString *)path {
    return [self imageViewWithFrame:frame path:path placehold:@""];
}

+ (UIImageView *)imageViewWithFrame:(CGRect)frame path:(NSString *)path placehold:(NSString *)placehold {
    UIImageView *iv = [[self alloc] initWithFrame:frame];
    iv.clipsToBounds = YES;
    iv.contentMode = UIViewContentModeScaleAspectFill;
    if ([path hasPrefix:@"http:"] || [path hasPrefix:@"https:"]) {
#ifdef ZJSDWebImage
        [iv sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:placehold] options:SDWebImageRefreshCached];
#else
        iv.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:path]]];
#endif
    }else {
        iv.image = [UIImage imageWithPath:path placehold:placehold];
    }
    
    return iv;
}

#pragma mark - 生成二维码

@end


#pragma mark - UILabel

@implementation UILabel (ZJSelectLabel)

- (UILabel *)accessoryViewWithText:(id)text bgColor:(UIColor *)color frame:(CGRect)frame {
    return [self accessoryViewWithText:text bgColor:color frame:frame needCornerRadius:NO];
}

- (UILabel *)accessoryViewWithText:(id)text bgColor:(UIColor *)color frame:(CGRect)frame needCornerRadius:(BOOL)need {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.numberOfLines = 0;
    if ([text isKindOfClass:[NSAttributedString class]]) {
        label.attributedText = text;
    }else {
        label.text = text;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    label.backgroundColor = color;
    
    if (need) {
        label.layer.cornerRadius = 8;
        label.layer.masksToBounds = YES;
    }
    
    return label;
}

- (CGSize)fitSizeWithWidth:(CGFloat)width {
    self.numberOfLines = 0;
    CGSize size = [self sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    
    return size;
}

- (CGSize)fitSizeWithHeight:(CGFloat)height {
    self.numberOfLines = 0;
    CGSize size = [self sizeThatFits:CGSizeMake(MAXFLOAT, height)];
    
    return size;
}

+ (CGSize)fitSizeWithWidth:(CGFloat)width text:(id)text {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    if ([text isKindOfClass:[NSAttributedString class]]) {
        label.attributedText = text;
    }else {
        label.text = text;
    }
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    
    return size;
}

+ (CGSize)fitSizeWithHeight:(CGFloat)height text:(id)text {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    if ([text isKindOfClass:[NSAttributedString class]]) {
        label.attributedText = text;
    }else {
        label.text = text;
    }
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(MAXFLOAT, height)];

    return size;
}

- (void)italicFont {
    CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(-15 * (CGFloat)M_PI / 180), 1, 0, 0);
    self.transform = matrix;
}

@end



#pragma mark - UIScrollView

@implementation UIScrollView (ZJScrollView)

- (void)registerCellWithSysIDs:(NSArray *)sysIDs {
    for (int i = 0; i < sysIDs.count; i++) {
        NSString *cellID = sysIDs[i];
        if ([self isKindOfClass:[UITableView class]]) {
            [((UITableView *)self) registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
        }else if([self isKindOfClass:[UICollectionView class]]){
            [((UICollectionView *)self) registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
        }
    }
}

- (void)registerCellWithNibIDs:(NSArray *)nibIDs {
    for (int i = 0; i < nibIDs.count; i++) {
        NSString *cellID = nibIDs[i];
        if ([self isKindOfClass:[UITableView class]]) {
            [((UITableView *)self) registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
        }else if([self isKindOfClass:[UICollectionView class]]){
            [((UICollectionView *)self) registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
        }
    }
}

- (void)registerCellWithNibIDs:(NSArray *)nibIDs sysIDs:(NSArray *)sysIDs {
    [self registerCellWithNibIDs:nibIDs];
    [self registerCellWithSysIDs:sysIDs];
}

@end


#pragma mark - UICollectionView

@implementation UICollectionView (ZJCollectionView)

- (void)registerNibs:(NSArray *)nibIDs forSupplementaryViewOfKind:(NSString *)kind {
    for (int i = 0; i < nibIDs.count; i++) {
        NSString *cellID = nibIDs[i];
        [self registerNib:[UINib nibWithNibName:cellID bundle:nil] forSupplementaryViewOfKind:kind withReuseIdentifier:cellID];
    }
}

@end


#pragma mark - UITableView

@implementation UITableView (ZJTableView)

+ (UISwitch *)accessorySwitchWithTarget:(id)target {
    UISwitch *sw = [[UISwitch alloc] init];
    SEL s = NSSelectorFromString(@"switchEvent:");
    if (target) {
        [sw addTarget:target action:s forControlEvents:UIControlEventValueChanged];
    }
#ifdef MainColor
    sw.onTintColor = [UIColor mainColor];
#endif
    return sw;
}

+ (UIButton *)accessoryButtonWithTarget:(id)target title:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 60, 30);
    btn.layer.cornerRadius = 8;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    SEL s = NSSelectorFromString(@"buttonEvent:");
    if (target) {
        [btn addTarget:target action:s forControlEvents:UIControlEventValueChanged];
    }
    
    return btn;
}

@end

@implementation UIScrollView (UITouch)

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 选其一即可
//    NSLog(@"self= %@", self);
//    NSLog(@"super= %@", [super class]);
//    NSLog(@"nextResponder= %@", [self nextResponder]);
    UITouch *th = touches.allObjects.firstObject;
//    NSLog(@"%@, super = %@", th.view, [super class]);
    if (![th.view isMemberOfClass:[UIView class]]) {
        [super touchesBegan:touches withEvent:event];
    }
    //  [[self nextResponder] touchesBegan:touches withEvent:event];
}

@end

#pragma mark - UISearchBar

#pragma mark - UIView

#define tapEvent @"tapEvent:"

@implementation UIView (ZJUIView)

- (void)setCornerRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color {
    [self setBorderWidth:width color:color cornerRadius:0];
}

- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    [self setCornerRadius:cornerRadius];
}

- (void)addTapGestureWithDelegate:(id <UIGestureRecognizerDelegate>)delegate target:(id)target {
    SEL s = NSSelectorFromString(tapEvent);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:s];
    tap.delegate = delegate;
    [self addGestureRecognizer:tap];
}

+ (UIView *)maskViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor maskViewColor];
    view.alpha = 0.4;
    
    return view;
}

- (UIView *)subViewWithTag:(NSInteger)tag {
    for (UIView *view in self.subviews) {
        if (view.tag == tag) {
            return view;
        }
    }
    
    return nil;
}

- (UIView *)fetchSubViewWithClassName:(NSString *)className {
    UIView *mView;
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(className)]) {
            return view;
        }else {
            return [view fetchSubViewWithClassName:className];
        }
    }
    
    return mView;
}

- (UIView *)fetchSuperViewWithClassName:(NSString *)className {
    if (self.superview) {
        if ([self.superview isKindOfClass:NSClassFromString(className)]) {
            return self.superview;
        }else {
            return [self.superview fetchSuperViewWithClassName:className];
        }
    }
    
    return nil;
}

+ (UIView *)createTitleIVWithFrame:(CGRect)frame path:(NSString *)path placehold:(NSString *)placehold title:(NSString *)title {
    UIView *view = [[UIView alloc] initWithFrame:frame];

    CGFloat height = view.frame.size.height, width = view.frame.size.width;
    
    UIImageView *iv = [UIImageView imageViewWithFrame:frame path:path placehold:placehold];
    [view addSubview:iv];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x + iv.frame.size.width+4, 2.5, width-iv.frame.size.width-4, height-5)];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    
    return view;
}

- (void)addMaskLayerAtRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)addBorderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType {    
    if (borderType == UIBorderSideTypeAll) {
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = color.CGColor;
    }
    
    /// 左侧
    if (borderType & UIBorderSideTypeLeft) {
        /// 左侧线路径
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(0.f, 0.f) toPoint:CGPointMake(0.0f, self.frame.size.height) color:color borderWidth:borderWidth]];
    }
    
    /// 右侧
    if (borderType & UIBorderSideTypeRight) {
        /// 右侧线路径
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(self.frame.size.width, 0.0f) toPoint:CGPointMake( self.frame.size.width, self.frame.size.height) color:color borderWidth:borderWidth]];
    }
    
    /// top
    if (borderType & UIBorderSideTypeTop) {
        /// top线路径
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(0.0f, 0.0f) toPoint:CGPointMake(self.frame.size.width, 0.0f) color:color borderWidth:borderWidth]];
    }
    
    /// bottom
    if (borderType & UIBorderSideTypeBottom) {
        /// bottom线路径
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(0.0f, self.frame.size.height) toPoint:CGPointMake( self.frame.size.width, self.frame.size.height) color:color borderWidth:borderWidth]];
    }
}

- (CAShapeLayer *)addLineOriginPoint:(CGPoint)p0 toPoint:(CGPoint)p1 color:(UIColor *)color borderWidth:(CGFloat)borderWidth {
    /// 线的路径
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:p0];
    [bezierPath addLineToPoint:p1];
    
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor  = [UIColor clearColor].CGColor;
    /// 添加路径
    shapeLayer.path = bezierPath.CGPath;
    /// 线宽度
    shapeLayer.lineWidth = borderWidth;
    return shapeLayer;
}

#pragma mark - supplementView

- (void)addIconBadgeWithImage:(UIImage *)image {
    [self createImageViewWithImage:image bgColor:nil];
}

- (void)addIconBadgeWithImage:(UIImage *)image bgColor:(UIColor *)color {
    [self createImageViewWithImage:image bgColor:color];
}

- (void)createImageViewWithImage:(UIImage *)image bgColor:(UIColor *)color {
    CGFloat width = 15;
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-10, 0, width, width)];
    iv.image = image;
    if (color) {
        iv.backgroundColor = color;
    }
    iv.layer.cornerRadius = width / 2;
    iv.layer.masksToBounds = YES;
    
    [self addSubview:iv];
}

- (QuadrantTouchType)quadrantOfTouchPoint:(CGPoint)point separateType:(AnnularSeparateType)type {
    CGFloat x = point.x, y = point.y;
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    if (type == AnnularSeparateTypeOfQuarter) {
        if (x <= width/2 && y <= height/2) {
            return QuadrantTouchTypeOfSecond;
        }else if (x > width/2 && y <= height/2) {
            return QuadrantTouchTypeOfFirst;
        }else if (x <= width/2 && y > height/2) {
            return QuadrantTouchTypeOfThird;
        }else {
            return QuadrantTouchTypeOfFourth;
        }
    }else {
        if (y <= width/2) {
            return QuadrantTouchTypeOfFirst ;
        }else {
            return QuadrantTouchTypeOfSecond;
        }
    }
}

- (BOOL)touchPointInTheAnnular:(CGPoint)point annularWidth:(CGFloat)annularWidth {
    CGFloat x = point.x, y = point.y;
    CGFloat width = self.bounds.size.width;
    CGFloat dx = fabs(x-width/2);
    CGFloat dy = fabs(y-width/2);
    CGFloat dis = sqrt(dx*dx + dy*dy);
    if (dis<width/2 && dis>(width/2-annularWidth)) {
        return YES;
    }
    return NO;
}

@end


#pragma mark - UIGestureRecognizer

@implementation UIGestureRecognizer (ZJGestureRecognizer)

#pragma mark - 方向判断

/**
 *  atan2(y, x):用来计算y/x的反正切值, 返回值范围 : (-pi/2,pi/2)
 */
+ (CGFloat)getAngle:(CGFloat)dx dy:(CGFloat)dy {
    return atan2(dy, dx)*180 / M_PI;
}

+ (Direction)direction:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CGFloat dy = startPoint.y - endPoint.y;    // 因为y值是向下增长的
    CGFloat dx = endPoint.x - startPoint.x;
    
    Direction result = DirectionOfNoMove;
    if (fabs(dy) < 2 || fabs(dy) < 2) {
        return DirectionOfNoMove;
    }
    CGFloat angle = [self getAngle:dx dy:dy];
    if (angle >= -45 && angle < 45) {
        result = DirectionOfRight;
    } else if (angle >= 45 && angle < 135) {
        result = DirectionOfUp;
    } else if (angle >= -135 && angle < -45) {
        result = DirectionOfDown;
    }
    else if ((angle >= 135 && angle <= 180) || (angle >= -180 && angle < -135)) {
        result = DirectionOfLeft;
    }
    
    return result;
}

@end

@implementation UISearchBar (ZJSearchBar)

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    for (UIView *view in self.subviews) {
        for (UIView *sView in view.subviews) {
            if ([NSStringFromClass([sView class]) isEqualToString:@"UISearchBarBackground"]) {
                ((UIImageView *)sView).image = [UIImage imageWithColor:[UIColor groupTableViewBackgroundColor]];
                break;
            }
        }
    }
}

- (void)setCancelBtnTitleColor:(UIColor *)color {
    for(UIView *view in  [[[self subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton *btn =(UIButton *)view;
            btn.tintColor = color;
        }
    }
}

@end

