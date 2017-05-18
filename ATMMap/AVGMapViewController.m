//
//  AVGMapViewController.m
//  ATMMap
//
//  Created by aiuar on 12.05.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVGMapViewController.h"
#import "AVGATMService.h"
#import "AVGMapAnnotation.h"
#import "AVGATM.h"
#import <Masonry.h>
#import "UIView+MKAnnotationView.h"
@import MapKit;

@interface AVGMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UISegmentedControl *mapSegmentControl;
@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) MKPolyline *routeLine; //your line
@property (nonatomic, strong) MKPolylineRenderer *routeLineRenderer; //overlay view
@property (nonatomic, strong) MKDirections *directions;

@end

@implementation AVGMapViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self setUpInterface];
}

#pragma mark - Setting interface

- (void)setUpInterface {
    // Map view
    self.mapView = [MKMapView new];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(self.view.mas_height);
    }];
    
    // UIBarButtons at navigation bar
    // On the right
    UIBarButtonItem *showATMsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                            target:self
                                                                            action:@selector(showATMs:)];
    self.navigationItem.rightBarButtonItem = showATMsButton;
    
    UIBarButtonItem *scaleATMsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                    target:self
                                                                                    action:@selector(scaleToAllPins:)];
    self.navigationItem.rightBarButtonItems = @[showATMsButton, scaleATMsButton];
    // On the left
    NSArray *items = @[@"обычная", @"спутник", @"гибрид"];
    self.mapSegmentControl = [[UISegmentedControl alloc] initWithItems:items];
    self.mapSegmentControl.frame = CGRectMake(0, 0, 180.f, 30.f);
    self.mapSegmentControl.selectedSegmentIndex = 0;
    [self.mapSegmentControl addTarget:self action:@selector(mapSegmentControlAction:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *segmentBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.mapSegmentControl];
    self.navigationItem.leftBarButtonItem = segmentBarButton;
    
    // Location manager
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
    MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinIdentifier];
        annotationView.image = [UIImage imageNamed:@"sberbankLogo.png"];
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [self routeButton];
        //annotationView pin.animatesDrop = YES;
    } else {
        annotationView.annotation = annotation;
    }
    return  annotationView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)annotationViews {
    // For animated drop
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
        
        annotationView.frame = CGRectOffset(endFrame, 0, -500);
        
        [UIView animateWithDuration:0.5
                              delay:0.04 * [annotationViews indexOfObject:annotationView]
                            options: UIViewAnimationOptionCurveLinear animations:^{
            
            annotationView.frame = endFrame;
            
            // Animate squash
        } completion:^(BOOL finished){
            if (finished) {
                [UIView animateWithDuration:0.05
                                 animations:^{
                    annotationView.transform = CGAffineTransformMakeScale(1.0, 0.8);
                    
                } completion:^(BOOL finished){
                    if (finished) {
                        [UIView animateWithDuration:0.1
                                         animations:^{
                            annotationView.transform = CGAffineTransformIdentity;
                        }];
                    }
                }];
            }
        }];
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]){
        MKPolylineRenderer* renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        renderer.lineWidth = 3.0f;
        renderer.strokeColor = [UIColor colorWithRed:0.5f green:0.5f blue:1.0f alpha:0.5f];
        return renderer;
    }
    
    return nil;
}

#pragma mark - Route button

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
        if (atms.count > 0) {
            __strong typeof(self) strongSelf = weakSelf;
            if(strongSelf) {
                for (AVGATM *atm in strongSelf.atmService.atms) {
                    AVGMapAnnotation *annotation = [[AVGMapAnnotation alloc] initWithCoordinate:atm.location
                                                                                          title:atm.name
                                                                                       subtitle:atm.address];
                    [strongSelf.mapView addAnnotation:annotation];
                }
            }
        }
    }];
}

- (void)scaleToAllPins:(UIBarButtonItem *)sender {
    MKMapRect zoomRect = MKMapRectNull;
    
    double delta = 20000.0;
    if ([self.mapView.annotations count] > 1) {
        delta = 1000.0;
    }
    
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        CLLocationCoordinate2D coordinate = annotation.coordinate;
        MKMapPoint center =  MKMapPointForCoordinate(coordinate);
        MKMapRect rect = MKMapRectMake(center.x - delta, center.y - delta, delta * 2, delta * 2);
        zoomRect = MKMapRectUnion(zoomRect, rect);
    }
    
    zoomRect = [self.mapView mapRectThatFits:zoomRect];
    [self.mapView setVisibleMapRect:zoomRect
                        edgePadding:UIEdgeInsetsMake(50.f, 50.f, 50.f, 50.f)
                           animated:YES];
}

- (void)routeButtonTapped:(UIButton *)sender {
    
    if ([self.directions isCalculating]) {
        [self.directions cancel];
    }
    
    MKAnnotationView* annotationView = [sender superAnnotationView];
    if (!annotationView) {
        return;
    }

    CLLocationCoordinate2D coordinate = annotationView.annotation.coordinate;
    
    MKPlacemark* placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                   addressDictionary:nil];
    MKMapItem* destination = [[MKMapItem alloc] initWithPlacemark:placemark];
    
    MKDirectionsRequest* request = [[MKDirectionsRequest alloc] init];
    request.source = [MKMapItem mapItemForCurrentLocation];
    request.destination = destination;
    request.transportType = MKDirectionsTransportTypeAny;
    request.requestsAlternateRoutes = YES;
    
    self.directions = [[MKDirections alloc] initWithRequest:request];
    [self.directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error");
        } else if ([response.routes count] == 0) {
            NSLog(@"error");
        } else {
            [self.mapView removeOverlays:self.mapView.overlays];
            
            NSMutableArray* array = [NSMutableArray array];
            for (MKRoute* route in response.routes){
                [array addObject:route.polyline];
            }
            
            [self.mapView addOverlays:array level:MKOverlayLevelAboveRoads];
        }
    }];

}

- (void)mapSegmentControlAction:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
            
        default:
            break;
    }
}

#pragma mark - Scale to annotation

- (void)scaleToAnnotationAtIndex:(NSInteger)index {
    
    MKMapRect zoomRect = MKMapRectNull;
    double delta = 5000;
    
    AVGATM *atm = self.atmService.atms[index];
    CLLocationCoordinate2D coordinate = atm.location;
    
    MKMapPoint center =  MKMapPointForCoordinate(coordinate);
    MKMapRect rect = MKMapRectMake(center.x - delta, center.y - delta, delta * 2, delta * 2);
    
    zoomRect = MKMapRectUnion(zoomRect, rect);
    zoomRect = [self.mapView mapRectThatFits:zoomRect];
    
    [self.mapView setVisibleMapRect:zoomRect
                        edgePadding:UIEdgeInsetsMake(50.f, 50.f, 50.f, 50.f)
                           animated:YES];
}

@end
