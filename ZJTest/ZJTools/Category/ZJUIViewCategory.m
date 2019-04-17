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

+ (UIColor *)sysTableViewDetailTextColor {
    return [UIColor colorWithRed:0.556863 green:0.556863 blue:0.576471 alpha:1];
}

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

+ (UIImage *)imageWithPath:(NSString *)path size:(CGSize)size opaque:(BOOL)opaque {
    return [UIImage imageWithPath:path placehold:@"" size:size opaque:opaque];
}

+ (UIImage *)imageWithPath:(NSString *)path placehold:(NSString *)placehold size:(CGSize)size opaque:(BOOL)opaque {
    UIImage *icon;
    if ([path isOnlinePic]) {
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

+ (UIImageView *)imageWithFrame:(CGRect)frame path:(NSString *)path {
    return [self imageWithFrame:frame path:path placehold:@""];
}

+ (UIImageView *)imageWithFrame:(CGRect)frame path:(NSString *)path placehold:(NSString *)placehold {
    UIImageView *iv = [[self alloc] initWithFrame:frame];
    iv.clipsToBounds = YES;
    iv.contentMode = UIViewContentModeScaleAspectFill;
    [iv setImageWithPath:path placehold:placehold];
    
    return iv;
}

- (void)setImageWithPath:(NSString *)path placehold:(NSString *)placehold {
    if (!placehold.length) {
        placehold = @"";
    }
    if (!path.length) {
        path = placehold;
    }
    
    if ([path hasPrefix:@"http:"] || [path hasPrefix:@"https:"]) {
#ifdef ZJSDWebImage
        [self sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:placehold] options:SDWebImageRefreshCached];
#else
        self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:path]]];
#endif
    }else {
        UIImage *img = [UIImage imageNamed:path];
        if (img == nil) {
            img = [UIImage imageNamed:placehold];
        }
        self.image = img;
    }
}

#pragma mark - 生成二维码

- (void)setupQRCodeWithContent:(NSString *)content {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setDefaults];
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    
    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:1.
                                   orientation:UIImageOrientationUp];
    
    // Resize without interpolating
    UIImage *resized = [self resizeImage:image
                             withQuality:kCGInterpolationNone
                                    rate:5.0];
    
    self.image = resized;
    
    CGImageRelease(cgImage);
}

- (UIImage *)resizeImage:(UIImage *)image withQuality:(CGInterpolationQuality)quality rate:(CGFloat)rate {
    UIImage *resized = nil;
    CGFloat width = image.size.width * rate;
    CGFloat height = image.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resized;
}

@end


#pragma mark - UILabel

@implementation UILabel (ZJSelectLabel)

+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(id)text background:(UIColor *)color {
    return [UILabel createLabelWithFrame:frame text:text background:color needCorner:NO];
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(id)text background:(UIColor *)color needCorner:(BOOL)need {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    if ([text isKindOfClass:[NSAttributedString class]]) {
        label.attributedText = text;
    }else {
        label.text = text;
    }
    label.backgroundColor = color;
    if (need) {
        label.layer.cornerRadius = label.frame.size.width / 2.0;
        label.layer.masksToBounds = YES;
    }
    
    return label;
}

- (CGSize)fitSizeWithWidth:(CGFloat)width {
    self.numberOfLines = 0;
    CGSize size = [self sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    
    return size;
}

+ (CGSize)fitSizeWithWidth:(CGFloat)width text:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = text;
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    
    return size;
}

+ (CGSize)fitSizeWithHeight:(CGFloat)height text:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = text;
    CGSize size = [label sizeThatFits:CGSizeMake(MAXFLOAT, height)];
    
    return size;
}

+ (CGSize)fitSizeWithWidth:(CGFloat)width text:(NSString *)text font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = text;
    if (font) label.font = font;
    label.numberOfLines = 0;
    
    CGSize size = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    
    return size;
}

+ (CGSize)fitSizeWithMargin:(CGFloat)margin text:(NSString *)text font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = text;
    if (font) label.font = font;
    label.numberOfLines = 0;
    
    if (margin < 0) {
        margin = DefaultMargin;
    }
    CGFloat width = kScreenW - 2*margin;
    CGSize size = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    
    return size;
}

- (void)fitFontWithPointSize:(CGFloat)pSize width:(CGFloat)width height:(CGFloat)height descend:(BOOL)descend {
    CGSize size = [self fitSizeWithWidth:width];
    
    if (descend) {
        if (size.height / height > 1.000) {
            self.font = [self.font fontWithSize:--pSize];
            
            [self fitFontWithPointSize:pSize width:width height:height descend:descend];
        }else {
            self.font = [self.font fontWithSize:pSize];
        }
    }else {
        if (size.height < height) {     // size.width < width-2*DefaultMargin && size.height < height
            self.font = [self.font fontWithSize:++pSize];
            [self fitFontWithPointSize:pSize width:width height:height descend:descend];
        }else {
            self.font = [self.font fontWithSize:--pSize];
        }
    }
}

- (void)italicFont {
    CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(-15 * (CGFloat)M_PI / 180), 1, 0, 0);
    self.transform = matrix;
}

@end


#pragma mark - UICollectionView

@implementation UICollectionView (ZJCollectionView)

- (void)registerCellWithSysIDs:(NSArray *)sysIDs {
    for (int i = 0; i < sysIDs.count; i++) {
        NSString *cellID = sysIDs[i];
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    }
}

- (void)registerCellWithNibIDs:(NSArray *)nibIDs {
    for (int i = 0; i < nibIDs.count; i++) {
        NSString *cellID = nibIDs[i];
        [self registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
    }
}

- (void)registerCellWithNibIDs:(NSArray *)nibIDs sysIDs:(NSArray *)sysIDs {
    [self registerCellWithNibIDs:nibIDs];
    [self registerCellWithSysIDs:sysIDs];
}

- (void)registerNibs:(NSArray *)nibIDs forSupplementaryViewOfKind:(NSString *)kind {
    for (int i = 0; i < nibIDs.count; i++) {
        NSString *cellID = nibIDs[i];
        [self registerNib:[UINib nibWithNibName:cellID bundle:nil] forSupplementaryViewOfKind:kind withReuseIdentifier:cellID];
    }
}

@end


#pragma mark - UITableView

@implementation UITableView (ZJTableView)

- (void)registerCellWithSysIDs:(NSArray *)sysIDs {
    for (int i = 0; i < sysIDs.count; i++) {
        NSString *cellID = sysIDs[i];
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    }
}

- (void)registerCellWithNibIDs:(NSArray *)nibIDs {
    for (int i = 0; i < nibIDs.count; i++) {
        NSString *cellID = nibIDs[i];
        [self registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    }
}

- (void)registerCellWithNibIDs:(NSArray *)nibIDs sysIDs:(NSArray *)sysIDs {
    [self registerCellWithNibIDs:nibIDs];
    [self registerCellWithSysIDs:sysIDs];
}

- (void)setNeedSeparatorMargin:(BOOL)needMargin {
    if (needMargin == NO) {
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
    }
}

/**
 - (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
 if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
 [cell setLayoutMargins:UIEdgeInsetsZero];
 }
 }
 */
- (void)setNeedLayoutMargin:(BOOL)needMargin {
    if (needMargin == NO) {
        if ([self respondsToSelector:@selector(setLayoutMargins:)])  {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

- (UISwitch *)accessorySwitchWithTarget:(id)target {
    UISwitch *sw = [[UISwitch alloc] init];
    SEL s = NSSelectorFromString(@"switchAction:");
    if (target) {
        [sw addTarget:target action:s forControlEvents:UIControlEventValueChanged];
    }
#ifdef MainColor
    sw.onTintColor = [UIColor mainColor];
#endif
    
    return sw;
}

- (UIButton *)accessoryButtonWithTarget:(id)target title:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 60, 30);
    btn.layer.cornerRadius = 8;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    SEL s = NSSelectorFromString(@"buttonAction:");
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
    
//    if ([self.nextResponder isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
//        UITableViewCell *cell = [self nextResponderWithTargetClassName:@"UITableViewCell"];
//        UITableView *tableView = [self nextResponderWithTargetClassName:@"UITableView"];
//        UITableViewController *vc = [self nextResponderWithTargetClassName:@"UITableViewController"];
//
//        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
//
//        if ([vc respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
//            [vc tableView:vc.tableView didSelectRowAtIndexPath:indexPath];
//        }
//    }
}

@end

#pragma mark - UISearchBar

#pragma mark - UIView

#define  tapAction @"tapAction:"

@implementation UIView (ZJUIView)

- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color {
    [self setBorderWidth:width color:color cornerRadius:0];
}

- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    self.layer.cornerRadius = cornerRadius;
}

- (void)needCornerRadius:(BOOL)need width:(CGFloat)width {
    if (need) {
        self.layer.cornerRadius = width;
        self.layer.masksToBounds = YES;
    }else {
        self.layer.cornerRadius = 0;
    }
}

- (void)addTapGestureWithDelegate:(id <UIGestureRecognizerDelegate>)delegate target:(id)target {
    SEL s = NSSelectorFromString(tapAction);
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
    
    UIImageView *iv = [UIImageView imageWithFrame:frame path:path placehold:placehold];
    [view addSubview:iv];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iv.frame.origin.x + iv.frame.size.width+4, 2.5, width-iv.frame.size.width-4, height-5)];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    
    return view;
}

#pragma mark - supplementView

+ (UIView *)supplementViewWithText:(NSString *)text {
    return [self createLabelWithText:text supplementViewBgColor:nil];
}

+ (UIView *)supplementViewWithText:(NSString *)text supplementViewBgColor:(UIColor *)color {
    return [self createLabelWithText:text supplementViewBgColor:color];
}

+ (UIView *)supplementViewWithAttributeText:(NSAttributedString *)text {
    return [self createLabelWithText:text supplementViewBgColor:nil];
}

+ (UIView *)supplementViewWithAttributeText:(NSAttributedString *)text supplementViewBgColor:(UIColor *)color {
    return [self createLabelWithText:text supplementViewBgColor:color];
}

+ (UILabel *)createLabelWithText:(id)text supplementViewBgColor:(UIColor *)color {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 21)];
    
    if (color) label.backgroundColor = color;
    
    if ([text isKindOfClass:[NSAttributedString class]]) {
        label.attributedText = text;
    }else {
        label.text = text;
    }
    
    label.numberOfLines = 0;
    
    return label;
}

#pragma mark - iconBadge

- (void)removeIconBadge {
    UILabel *label = (UILabel *)[self subViewWithTag:0];
    if (label) {
        label.hidden = YES;
    }
}

- (void)addIconBadgeWithText:(NSString *)text {
    UILabel *label = [self createLableWithText:text bgColor:nil frame:CGRectZero];
    [self addSubview:label];
}

- (void)addIconBadgeWithText:(NSString *)text bgColor:(UIColor *)color {
    UILabel *label = [self createLableWithText:text bgColor:color frame:CGRectZero];
    [self addSubview:label];
}

- (void)addIconBadgeWithAttributeText:(NSAttributedString *)text {
    UILabel *label = [self createLableWithText:text bgColor:nil frame:CGRectZero];
    [self addSubview:label];
}

- (void)addIconBadgeWithAttributeText:(NSAttributedString *)text bgColor:(UIColor *)color {
    UILabel *label = [self createLableWithText:text bgColor:color frame:CGRectZero];
    [self addSubview:label];
}

- (UILabel *)createLableWithText:(id)text bgColor:(UIColor *)color frame:(CGRect)frame {
    UILabel *label = (UILabel *)[self subViewWithTag:0];
    if (label) {
        label.hidden = NO;
    }else {
        CGFloat width;
        CGRect fm = frame;
        if (CGRectEqualToRect(fm, CGRectZero)) {
            width = 10;
            fm = CGRectMake(self.frame.size.width-10, 0, width, width);
        }else {
            width = frame.size.width;
        }
        label = [[UILabel alloc] initWithFrame:fm];
        if ([text isKindOfClass:[NSAttributedString class]]) {
            label.attributedText = text;
        }else {
            label.text = text;
        }
        if (color) {
            label.backgroundColor = color;
        }
        label.layer.cornerRadius = width / 2;
        label.layer.masksToBounds = YES;
        [self addSubview:label];
    }
    /*
     CGFloat width;
     CGRect fm = frame;
     if (CGRectEqualToRect(fm, CGRectZero)) {
     width = 10;
     fm = CGRectMake(self.frame.size.width-10, 0, width, width);
     }else {
     width = frame.size.width;
     }
     UILabel *label = [[UILabel alloc] initWithFrame:fm];
     if ([text isKindOfClass:[NSAttributedString class]]) {
     label.attributedText = text;
     }else {
     label.text = text;
     }
     if (color) {
     label.backgroundColor = color;
     }
     label.layer.cornerRadius = width / 2;
     label.layer.masksToBounds = YES;
     */
    
    return label;
}

- (UILabel *)accessoryViewWithText:(id)text bgColor:(UIColor *)color frame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    if ([text isKindOfClass:[NSAttributedString class]]) {
        label.attributedText = text;
    }else {
        label.text = text;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
    }
    if (color) {
        label.backgroundColor = color;
    }
    label.layer.cornerRadius = 8;
    label.layer.masksToBounds = YES;
    
    return label;
}

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


@implementation UINavigationBar (ZJNavigationBar)

/**
 view.backgroundColor = backgroundColor;   // 背景色设置无效
 NSLog(@"view.superclass = %@", view.superclass);  // UIView
 NSLog(@"ssView.superclass1 = %@", ssView.superclass);   // _UIVisualEffectSubview --> UIView
 NSLog(@"ssView.superclass2 = %@", ssView.superclass);    // _UIVisualEffectBackdropView --> _UIVisualEffectSubview
 
 ssView.hidden = YES;    // [ssView removeFromSuperview];    移除不了, 只能隐藏
 ssView.backgroundColor = [UIColor clearColor]; //  背景色透明设置无效
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    for (UIView *view in self.subviews) {
        if ([view isMemberOfClass:NSClassFromString(@"_UIBarBackground")]) {
            
            for (UIView *sView in view.subviews) {
                if ([sView isMemberOfClass:NSClassFromString(@"UIVisualEffectView")]) {
                    sView.backgroundColor = backgroundColor;
                    for (UIView *ssView in sView.subviews) {
                        if ([ssView isMemberOfClass:NSClassFromString(@"_UIVisualEffectSubview")]) {
                            ssView.hidden = YES;    // [ssView removeFromSuperview];    移除不了, 只能隐藏
                        }else {
                            ssView.hidden = YES;    //  背景色透明设置无效
                        }
                    }
                }
            }
        }
    }
}

- (void)setHiddenSeparateLine:(BOOL)hidden {
    UIView *view = [self fetchSubViewWithClassName:@"UIImageView"];
    if (view) view.hidden = hidden;
}


/**
 修改不成功,坑爹的苹果
 NSLog(@"superclass = %@", btn.superclass); --> UIButton
 */
- (void)setBackBarButtonItemTitle:(NSString *)title {
    UIButton *btn = (UIButton *)[self fetchSubViewWithClassName:@"_UIModernBarButton"];
    [btn setTitle:title forState:UIControlStateNormal];
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

