//
//  ImageVetterAppDelegate.m
//  ImageVetter
//
//  Created by Jørgen P. Tjernø on 2/20/11.
//  Copyright 2011 devSoft. All rights reserved.
//

#import "ImageVetterAppDelegate.h"

#define DEFAULT_BROWSE_DIRECTORY @"/Users/jorgenpt/Pictures/Events"

@interface ImageVetterAppDelegate ()

@property (retain) NSString *path;
@property (retain) NSArray *files;
@property (retain) NSMutableArray *discardFiles;
@property (retain) NSImage *currentImage;
@property (assign) int currentFile, totalFiles;
@property (assign) int kept, discarded;

- (void) loadImage;
- (void) chooseDirectory;
- (void) startVetting;

@end

@implementation ImageVetterAppDelegate

@synthesize window;

@synthesize path;
@synthesize files;
@synthesize discardFiles;
@synthesize currentImage;
@synthesize currentFile, totalFiles;
@synthesize kept, discarded;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self chooseDirectory];
}

- (void) dealloc
{
    [self setPath:nil];
    [self setFiles:nil];
    [self setDiscardFiles:nil];

    [super dealloc];
}

- (IBAction) discardImage:(id)sender
{
    [self setDiscarded:discarded + 1];
    [discardFiles addObject:[files objectAtIndex:currentFile]];

    [self setCurrentFile:currentFile + 1];
    [self loadImage];
}

- (IBAction) keepImage:(id)sender
{
    [self setKept:kept + 1];
    
    [self setCurrentFile:currentFile + 1];

    [self loadImage];
}

- (void) loadImage
{
    if (currentFile < 0 || currentFile >= [files count])
    {
        NSString *output;
        if ([discardFiles count] > 0)
        {
            output = [NSString stringWithFormat:@"- %@\n", [discardFiles componentsJoinedByString:@"\n- "]];
        }
        else
        {
            output = @"";
        }
        
        [output writeToFile:[path stringByAppendingPathComponent:@".galleruby.skiplist"]
                 atomically:YES
                   encoding:NSUTF8StringEncoding
                      error:NULL];

        [self chooseDirectory];
    }
    else
    {
        NSImage *image = [[[NSImage alloc] initByReferencingFile:[path stringByAppendingPathComponent:[files objectAtIndex:currentFile]]] autorelease];
        [self setCurrentImage:image];
    }
}

- (void) startVetting 
{
    NSArray *foundFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    foundFiles = [foundFiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF endswith[c] 'JPG' OR SELF endswith[c] 'JPEG' OR SELF endswith[c] 'PNG'"]];
    [self setFiles:foundFiles];
    [self setDiscardFiles:[NSMutableArray array]];

    [self setCurrentFile:0];
    [self setTotalFiles:[files count]];
    [self setKept:0];
    [self setDiscarded:0];

    [self loadImage];
}

- (void) chooseDirectory
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:YES];
    [panel setDirectoryURL:[NSURL fileURLWithPath:DEFAULT_BROWSE_DIRECTORY]];
    [panel beginSheetModalForWindow:window
                  completionHandler:^ (NSInteger result) {
                      if (result == NSFileHandlingPanelCancelButton)
                          [NSApp terminate:self];
                      else
                      {
                          [self setPath:[[panel URL] path]];
                          [self startVetting];
                      }
                  }];
}

@end
