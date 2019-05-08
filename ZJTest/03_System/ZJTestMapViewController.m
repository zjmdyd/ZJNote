//
//  ZJTestMapViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/5/6.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestMapViewController.h"
#import <MapKit/MapKit.h>

@interface ZJTestMapViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ZJTestMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.showsUserLocation = YES;
    
    if (@available(iOS 9.0, *)) {
        self.mapView.showsCompass = YES;
        self.mapView.showsScale = YES;
    } else {
        // Fallback on earlier versions
    }

    MKPointAnnotation *annotation = [MKPointAnnotation new];
    CLLocationDegrees latitude = 35.4332 + arc4random_uniform(10);
    CLLocationDegrees longitude = 119.3342 + arc4random_uniform(10);
    [annotation setCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
    annotation.title = @"China";
    annotation.subtitle = @"City";
    [self.mapView addAnnotation:annotation];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    NSLog(@"%s",__func__);
    static NSString *identifier = @"annotation";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if(!annotation) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.canShowCallout = YES;
        if (@available(iOS 9.0, *)) {
            annotationView.pinTintColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.4 alpha:1.0];
        } else {
            // Fallback on earlier versions
            annotationView.pinColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.4 alpha:1.0];
        }
        annotationView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeCustom];
    }else {
        annotationView.annotation = annotation;
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(10_9, 4_0) {
    NSLog(@"%s", __func__);
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(10_9, 4_0) {
    NSLog(@"%s", __func__);
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control  {
    NSLog(@"%s", __func__);
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation NS_AVAILABLE(10_9, 4_0) {
    NSLog(@"%s", __func__);
    static BOOL first = NO;
    if(!first) {
        first = YES;
        MKCoordinateSpan span = MKCoordinateSpanMake(0.12, 0.12);
        MKCoordinateRegion regoin = MKCoordinateRegionMake(userLocation.location.coordinate, span);
        [self.mapView setRegion:regoin animated:YES];
    }
}

/**
 使用CLLocationManager定位
 */
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"%s", __func__);
    
    [self.locationManager stopUpdatingHeading];
    //地址
    CLLocation *userLocation = [locations lastObject];
    //显示范围
//    double latitudeSpan = fabs(self.latitude - self.userLocation.coordinate.latitude) * 3;
//    double longitudeSpan = fabs(self.longitude - self.userLocation.coordinate.longitude) *3;
//    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeSpan, longitudeSpan);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.12, 0.12);
    MKCoordinateRegion regoin = MKCoordinateRegionMake(userLocation.coordinate, span);
    [self.mapView setRegion:regoin animated:YES];
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        //判断定位功能是否打开
        if ([CLLocationManager locationServicesEnabled]) {
            _locationManager = [[CLLocationManager alloc]init];
            _locationManager.delegate = self;
            [_locationManager requestWhenInUseAuthorization];
            
            //设置寻址精度
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            _locationManager.distanceFilter = 5.0;
            [_locationManager startUpdatingLocation];
        }
    }
    return _locationManager;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
