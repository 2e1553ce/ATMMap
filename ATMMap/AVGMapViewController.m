//
//  AVGMapViewController.m
//  ATMMap
//
//  Created by aiuar on 12.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVGMapViewController.h"
#import "AVGControllerService.h"
#import "AVGATMService.h"
#import "AVGMapAnnotation.h"
#import "AVGATM.h"
@import MapKit;

@interface AVGMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) AVGATMService *atmService;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) NSArray *atms;

@end

@implementation AVGMapViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.atmService = [AVGATMService new];
    
    [self setupMap];
}

#pragma mark - Setting map view

- (void)setupMap {
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    UIBarButtonItem *showATMsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                            target:self
                                                                            action:@selector(showATMs:)];
    self.navigationItem.rightBarButtonItem = showATMsButton;
    
    UIBarButtonItem *scaleATMsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                    target:self
                                                                                    action:@selector(scaleToAllPins:)];
    self.navigationItem.rightBarButtonItems = @[showATMsButton, scaleATMsButton];
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    };
}

#pragma mark - MKMapViewDelegate

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString *pinIdentifier = @"MapAnnotationView";
    MKAnnotationView *pin = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
    if (!pin) {
        pin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinIdentifier];
        pin.image = [UIImage imageNamed:@"sberbankLogo.png"];
        pin.canShowCallout = YES;
        pin.rightCalloutAccessoryView = [self routeButton];
        // pin.animatesDrop = YES;
    } else {
        pin.annotation = annotation;
    }
    return  pin;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)annotationViews {
    
    for (MKAnnotationView *annotationView in annotationViews) {
        
        if ([annotationView isEqual:[self.mapView userLocation]]) {
            continue;
        }
        
        // Check if current annotation is inside visible map rect, else go to next one
        
        MKMapPoint point =  MKMapPointForCoordinate(annotationView.annotation.coordinate);
        if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
            continue;
        }
        
        
        
        CGRect endFrame = annotationView.frame;
        
        annotationView.frame = CGRectOffset(endFrame, 0,-500);
        
        [UIView animateWithDuration:0.5 delay:0.04*[annotationViews indexOfObject:annotationView] options: UIViewAnimationOptionCurveLinear animations:^{
            
            annotationView.frame = endFrame;
            
            // Animate squash
        }completion:^(BOOL finished){
            if (finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    annotationView.transform = CGAffineTransformMakeScale(1.0, 0.8);
                    
                }completion:^(BOOL finished){
                    if (finished) {
                        [UIView animateWithDuration:0.1 animations:^{
                            annotationView.transform = CGAffineTransformIdentity;
                        }];
                    }
                }];
            }
        }];
    }
}

#pragma mark - Custom button

- (UIButton *)routeButton {
    UIImage *image = [UIImage imageNamed:@"route.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, image.size.width, image.size.height); // don't use auto layout
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(routeButtonTapped:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    return button;
}

#pragma mark - Actions

- (void)showATMs:(UIBarButtonItem *)item {
    
    [self.mapView removeAnnotations:[self.mapView annotations]];
    
    CLLocationCoordinate2D currentLocation = [[[self.mapView userLocation] location] coordinate];
    
    __weak typeof(self) weakSelf = self;
    [self.atmService getATMsWithName:@"Сбербанк" nearLocation:currentLocation withCompletionHandler:^(NSArray *atms, NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        if(strongSelf) {
            strongSelf.atms = atms;
            
            for (AVGATM *atm in strongSelf.atms) {
                AVGMapAnnotation *annotation = [[AVGMapAnnotation alloc] initWithCoordinate:atm.location
                                                                                      title:atm.name
                                                                                   subtitle:atm.address];
                [strongSelf.mapView addAnnotation:annotation];
            }
        }
    }];
}

- (void)scaleToAllPins:(UIBarButtonItem *)sender {
    MKMapRect zoomRect = MKMapRectNull;
    
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        CLLocationCoordinate2D coordinate = annotation.coordinate;
        MKMapPoint center =  MKMapPointForCoordinate(coordinate);
        
        static double delta = 20000;
        MKMapRect rect = MKMapRectMake(center.x - delta, center.y - delta, delta * 2, delta * 2);
        zoomRect = MKMapRectUnion(zoomRect, rect);
    }
    
    zoomRect = [self.mapView mapRectThatFits:zoomRect];
    [self.mapView setVisibleMapRect:zoomRect
                        edgePadding:UIEdgeInsetsMake(50.f, 50.f, 50.f, 50.f)
                           animated:YES];
}

- (void)routeButtonTapped:(UIButton *)sender {
    
}

@end
