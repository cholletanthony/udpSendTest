//
//  ViewController.m
//  udpSendTest
//
//  Created by anthony chollet on 16/02/2016.
//  Copyright © 2016 Stargazers. All rights reserved.
//

#import "ViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

#define Port 80
#define IpAddress 155.0.0.1

@interface ViewController ()
@property (nonatomic) CFSocketRef udpSocket;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _udpSocket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_DGRAM, IPPROTO_UDP, 0, NULL, NULL);
    if(_udpSocket){
        NSLog(@"socket create");
        
        struct sockaddr_in addr;
        memset(&addr, 0, sizeof(addr));
        addr.sin_len = sizeof(addr);
        addr.sin_family = AF_INET;
        addr.sin_port = htons(8080); // PORT
        inet_aton("127.0.0.1", &addr.sin_addr); // IP ADDRESS
        
        NSData *address = [NSData dataWithBytes:&addr length:sizeof(addr)];
        if(CFSocketSetAddress(_udpSocket, (CFDataRef)address) != kCFSocketSuccess){
            NSLog(@"erreur set address");
        }
        else{
            NSLog(@"set address OK");
            CFSocketConnectToAddress(_udpSocket, (CFDataRef)address, 10);
        }
    }
    else{
        NSLog(@"error socket creation");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickSendBtn:(id)sender {
    NSString *message = _tbText.text;
    NSData *message_data = [message dataUsingEncoding:NSUTF8StringEncoding];

    CFSocketError socket_error = CFSocketSendData(_udpSocket, NULL, (CFDataRef)message_data, 10);
    
    if(socket_error < 0){
        NSLog(@"Error send");
    }
    else{
        NSLog(@"send ok");
    }
}

@end
