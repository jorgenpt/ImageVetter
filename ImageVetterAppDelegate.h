//
//  ImageVetterAppDelegate.h
//  ImageVetter
//
//  Created by Jørgen P. Tjernø on 2/20/11.
//  Copyright 2011 devSoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ImageVetterAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;

    NSString *path;
    NSArray *files;
    NSMutableArray *discardFiles;
    NSImage *currentImage;    
    int currentFile, totalFiles;
    int kept, discarded;
}

@property (assign) IBOutlet NSWindow *window;

- (void) dealloc;

- (IBAction) discardImage:(id)sender;
- (IBAction) keepImage:(id)sender;

@end
