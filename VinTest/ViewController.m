//
//  ViewController.m
//  VinTest
//
//  Created by kingpoint on 14-7-21.
//  Copyright (c) 2014年 kingpoint. All rights reserved.
//

#import "ViewController.h"
#import "TestObj.h"

static NSString *str;
@interface ViewController () {
    
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (assign, nonatomic) NSInteger memberVariable;
@property (retain) NSRecursiveLock *testLock;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    str = @"aaaaaa";
    _testLock = [[NSRecursiveLock alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (IBAction)testButtonAction:(id)sender {
//    [self testAccessVariable];
//    [self testBlock];
    for (int i=0; i<10; i++) {
        [self testAccessLock];
    }
}

#pragma mark - Private

- (void)testAccessVariable {
    __block NSInteger outsideVariable = 10;
//    __block NSInteger outsideVariable = 10;
    NSMutableArray * outsideArray = [[NSMutableArray alloc] init];
    
    void (^blockObject)(void) = ^(void){
        NSInteger insideVariable = 20;
        NSLog(@"  > member variable = %d", self.memberVariable);
        NSLog(@"  > outside variable = %d", outsideVariable);
        NSLog(@"  > inside variable = %d", insideVariable);
        
        [outsideArray addObject:@"AddedInsideBlock"];
        str = @"bbbbbb";
        NSLog(@"str ==== %@", str);
    };
    
    outsideVariable = 40;
    self.memberVariable = 30;
    
    blockObject();
    
    NSLog(@"  > %d items in outsideArray", [outsideArray count]);
}

- (void)testBlock {
    int (^multiply)(int, int) = ^(int i, int j) {
        return i * j;
    };
    
    [TestObj logToLimit:3 WithBlock:^(int i, int j) {
        return i + j;
    }];
}

- (void)testAccessLock {
//    [_testLock lock];
    NSLog(@"before sleep");
    __weak ViewController *weakSelf = self;
    [TestObj logAsyncWithBloc:^(BOOL result) {
//        usleep(2000*1000);
//        [_testLock unlock];
//        [weakSelf performSelector:@selector(spentTime) withObject:nil afterDelay:3];
        NSLog(@"done async");
    }];
    NSLog(@"after sleep");
}

- (void)spentTime {
    for (int i=0; i<110000000; i++) {
        i ++;
    }
}

#pragma mark -

- (UIColor *) getPixelColorAtLocation:(CGPoint)point {
    UIColor* color = nil;
    CGImageRef inImage = self.imageView.image.CGImage;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) {
        return nil; /* error */
    }
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        //NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
        
    }
    
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data) { free(data); }
    return color;
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.imageView];
    [self.colorView setBackgroundColor:[self getPixelColorAtLocation:point]];
}

@end
