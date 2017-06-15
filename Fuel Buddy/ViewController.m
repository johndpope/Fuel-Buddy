//
//  ViewController.m
//  Fuel Buddy
//
//  Created by sxsasha on 4/24/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import "ViewController.h"
@import GoogleMaps;

#import "ServerManager.h"
#import "FuelStation.h"

#import "NavigationView.h"
#import "FuelListView.h"
#import "MarkerView.h"


@interface ViewController () <CLLocationManagerDelegate, GMSMapViewDelegate, StationsListDelegate>

@property (weak, nonatomic) IBOutlet NavigationView *navView;
@property (weak, nonatomic) IBOutlet FuelListView *fuelListView;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (weak, nonatomic) IBOutlet UIView *dragView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *profileAction;
@property (weak, nonatomic) IBOutlet UIButton *settingsAction;

@property (strong, nonatomic) NSMutableSet* setOfOffice;
@property (nonatomic,strong) CLLocationManager* locManager;
@property (strong, nonatomic) CLLocation* location;

@property (strong, nonatomic) GMSMarker *tappedMarker;
@property (strong, nonatomic) MarkerView *markerInfoWindow;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAll];
}

#pragma mark - Setup methods

- (void)setupAll {
    
    //design & animations
    [self setupDragAnim];
    [self setupDesignTips];
    [self customizeDragView];
    [self initMarkerInfoWindow];
    
    //business logic
    [self setupDelegates];
    [self getFuelStations];
    [self initLocationManager];
}

#pragma mark Business logic

-(void) setupDelegates {
    self.mapView.delegate = self;
    self.fuelListView.delegate = self;
}

-(void) initLocationManager {
    self.locManager = [[CLLocationManager alloc]init];
    self.locManager.delegate = self;
    self.locManager.distanceFilter = 100;
    self.locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self.locManager requestWhenInUseAuthorization];
}

- (void)getFuelStations {
    [[ServerManager sharedManager] getFuelStation:^(NSArray<FuelStation *> *fuelStations, NSError *error) {
        if (fuelStations && !error) {
            for (FuelStation *station in fuelStations) {
                station.marker.map = self.mapView;
            }
            [self.fuelListView setupStations:fuelStations];
        }
    }];
}

#pragma mark Design & Animations

- (void) initMarkerInfoWindow {
    self.markerInfoWindow =  [[[NSBundle mainBundle] loadNibNamed:@"MarkerView" owner:self options:nil] firstObject];
    self.markerInfoWindow.bounds = CGRectMake(0, 0, 200, 45);
    
    //customize shadow
    self.markerInfoWindow.layer.shadowColor = [UIColor blackColor].CGColor;
    self.markerInfoWindow.layer.shadowRadius = 2.0f;
    self.markerInfoWindow.layer.shadowOpacity = 0.9f;
    self.markerInfoWindow.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)setupDesignTips {
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)customizeDragView {
    //shadow
    self.dragView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.dragView.layer.shadowRadius = 3.0f;
    self.dragView.layer.shadowOpacity = 0.7f;
    self.dragView.layer.shadowOffset = CGSizeMake(0, 0);
    
    //corner
    self.dragView.layer.cornerRadius = 4.f;
    self.dragView.layer.masksToBounds = NO;
}

- (void)setupDragAnim {
    UISwipeGestureRecognizer *swipeUpRecogniser = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDragView:)];
    swipeUpRecogniser.direction = UISwipeGestureRecognizerDirectionUp;
    
    UISwipeGestureRecognizer *swipeDownRecogniser = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDragView:)];
    swipeDownRecogniser.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.dragView addGestureRecognizer:swipeUpRecogniser];
    [self.dragView addGestureRecognizer:swipeDownRecogniser];
}

#pragma mark - Animation

- (void)swipeDragView:(UISwipeGestureRecognizer *)sender {

    BOOL constraintChanged = NO;
    CGFloat height = self.heightConstraint.constant;
    
    if (sender.direction == UISwipeGestureRecognizerDirectionDown && height == -282) {
        height = -102;
        constraintChanged = YES;
    }
    else if (sender.direction == UISwipeGestureRecognizerDirectionUp && height == -102) {
        height = -282;
        constraintChanged = YES;
    }
    
    if (constraintChanged) {
        [self.view layoutIfNeeded];
        sender.enabled = NO;
        
        self.heightConstraint.constant = height;
        [UIView animateWithDuration:0.25f animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            sender.enabled = YES;
        }];
    }
}

#pragma mark - StationsListDelegate

- (void)selectFuelStation:(FuelStation *)station {
    [self moveCameraToCoordinate:station.coordinate];
    [self showMarker:station.marker];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if  ((status == kCLAuthorizationStatusAuthorizedWhenInUse) ||
         (status == kCLAuthorizationStatusAuthorizedAlways))
    {
        [self.locManager startUpdatingLocation];
        self.mapView.myLocationEnabled = YES;
        self.mapView.settings.myLocationButton = YES;
    }
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *location = [locations lastObject];
    self.location = location;
    
    NSTimeInterval locationAge = -[location.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    
    if (location.horizontalAccuracy < 0) return;
    
    [self changeLocation:location];
}

#pragma mark - GMSMapViewDelegate


- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    return [UIView new];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    [self showMarker:marker];
    return false;
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self.navView.searchField resignFirstResponder];
    [self.markerInfoWindow removeFromSuperview];
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    if (self.tappedMarker){
        self.markerInfoWindow.center = [self centerForMarkerInfo:self.tappedMarker.position];
    }
}


#pragma mark - Main Logic

- (void)showMarker:(GMSMarker *)marker {
    self.tappedMarker = marker;
    [self.markerInfoWindow removeFromSuperview];
    
    //config markerInfoWindow
    self.markerInfoWindow.addressLabel.text = marker.title;
    self.markerInfoWindow.priceLabel.text = marker.snippet;
    
    //change InfoWindow position
    self.markerInfoWindow.center = [self centerForMarkerInfo:marker.position];
    
    [self.mapView addSubview:self.markerInfoWindow];
}

- (void)changeLocation:(CLLocation *)location {
    self.location = location;
    [self moveCameraToCoordinate:location.coordinate];
}

- (void)moveCameraToCoordinate:(CLLocationCoordinate2D)coordinate {
    int radius = 500;
    
    CGFloat widthPoint = [UIApplication sharedApplication].keyWindow.bounds.size.width;
    CGFloat zoom = [GMSCameraPosition zoomAtCoordinate:coordinate forMeters:radius*2 perPoints:widthPoint];
    self.mapView.camera = [[GMSCameraPosition alloc]initWithTarget:coordinate zoom:zoom bearing:0 viewingAngle:0];
}

#pragma mark - Help methods

- (CGPoint)centerForMarkerInfo:(CLLocationCoordinate2D)coordinate {
    CGPoint point = [self.mapView.projection pointForCoordinate:coordinate];
    CGFloat height = self.markerInfoWindow.bounds.size.height;
    CGFloat width = self.markerInfoWindow.bounds.size.width;
    point.y -= height/2.f;
    point.x += width/5.f;
    return point;
}
@end
