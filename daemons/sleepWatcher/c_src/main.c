//
//  main.c
//  sleepWatcher
//
//  Created by Oskari Palojärvi on 12/09/2017.
//

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>

#include <mach/mach_port.h>
#include <mach/mach_interface.h>
#include <mach/mach_init.h>

#include <IOKit/pwr_mgt/IOPMLib.h>
#include <IOKit/IOMessage.h>

//reference to root power domain service IO
io_connect_t rootPort;

//Callback function when system power status is changing
void powerCallback (void *refCon, io_service_t y, natural_t msgType, void *msgArgument)
{
    switch (msgType) {
        case kIOMessageCanSystemSleep:
            //idle sleep callback, denying idle sleep
            IOCancelPowerChange(rootPort, (long) msgArgument);
            break;
            
        case kIOMessageSystemWillSleep:
            //force sleep callback, cannot be canceled
            
            //running program which logs out all managed users and thus triggers home directory clearace
            system("/usr/local/manage/lib/logoutmanagedusers.rb");
            IOAllowPowerChange(rootPort, (long) msgArgument);
            break;
            
        case kIOMessageSystemHasPoweredOn:
            //callback when system is finished startup process
            break;
            
        default:
            //all other Power callback messages
            break;
    }
}

//Initializing power notifications
static void constructPowerNotifications()
{
    
    
    io_object_t notifierObject;
    IONotificationPortRef notifyPort;
    
    
    rootPort = IORegisterForSystemPower(&rootPort, &notifyPort, powerCallback, &notifierObject);
    if (rootPort == 0) {
        exit(1);
    }
    //adding source for main run loop
    CFRunLoopAddSource(CFRunLoopGetCurrent(), IONotificationPortGetRunLoopSource(notifyPort), kCFRunLoopCommonModes);
}


//Singal callback, responsible for terminating daemon when system is shutting down
static void signalCallback(int sig)
{
    switch (sig) {
        case SIGINT:
        case SIGTERM:
            exit(0);
            break;
            
        default:
            break;
    }
}

//main function
int main(int argc, const char * argv[]) {
    //connecting singals
    signal(SIGINT, signalCallback);
    signal(SIGTERM, signalCallback);
    
    //initializing power notifications
    constructPowerNotifications();
    
    //starting system run loop
    CFRunLoopRun();
    
    return 0;
}
