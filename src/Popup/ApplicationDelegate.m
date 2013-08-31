#import "ApplicationDelegate.h"
#import "JFHotkeyManager.h"

void *kContextActivePanel = &kContextActivePanel;

@implementation ApplicationDelegate

@synthesize menubarController = _menubarController;

#pragma mark -

- (void)dealloc
{
    [_menubarController release];
    [_panelController removeObserver:self forKeyPath:@"hasActivePanel"];
    [_panelController release];
    
    [super dealloc];
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kContextActivePanel)
    {
        self.menubarController.hasActiveIcon = self.panelController.hasActivePanel;
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - NSApplicationDelegate

- (void)resetImage {
    self.menubarController.hasActiveIcon = NO;
}
- (void)sentText {
    NSArray *arguments = [[NSProcessInfo processInfo] arguments];
    NSString *script = [NSString stringWithFormat:
    @"tell application \"Messages\"\n"
    @"   set message to the clipboard as text\n"
    @"   set myid to get id of last service\n"
    @"   set theBuddy to buddy \"%@\" of service id myid\n"
    @"   send message to theBuddy\n"
    @"end tell", arguments[1]];
    NSAppleScript *start = [[NSAppleScript alloc] initWithSource:script];
    self.menubarController.hasActiveIcon = YES;
    [start executeAndReturnError:nil];
    [self performSelector:@selector(resetImage) withObject:nil afterDelay:2];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    // Install icon into the menu bar
    [self.menubarController = [[MenubarController alloc] init] release];
    
    JFHotkeyManager *hkm = [[JFHotkeyManager alloc] init];
    [hkm bind:@"command shift up" target:self action:@selector(sentText)];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Explicitly remove the icon from the menu bar
    self.menubarController = nil;
    
    return NSTerminateNow;
}

#pragma mark - Actions

- (IBAction)togglePanel:(id)sender
{
    self.menubarController.hasActiveIcon = !self.menubarController.hasActiveIcon;
    self.panelController.hasActivePanel = self.menubarController.hasActiveIcon;
}

#pragma mark - Public accessors

- (PanelController *)panelController
{
    if (_panelController == nil)
    {
        _panelController = [[PanelController alloc] initWithDelegate:self];
        [_panelController addObserver:self forKeyPath:@"hasActivePanel" options:0 context:kContextActivePanel];
    }
    return _panelController;
}

#pragma mark - PanelControllerDelegate


- (StatusItemView *)statusItemViewForPanelController:(PanelController *)controller
{
    return self.menubarController.statusItemView;
}

@end
