//
//  Task.m
//  To-Do
//
//  Created by Hadir on 02/04/2024.
//

#import "Task.h"

@implementation Task

+ (BOOL)supportsSecureCoding {
    return YES;
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.desc forKey:@"desc"];
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeInteger:self.priority forKey:@"priority"];
    [encoder encodeInteger:self.state forKey:@"state"];
    [encoder encodeObject:self.uId forKey:@"uId"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.desc = [decoder decodeObjectForKey:@"desc"];
        self.date = [decoder decodeObjectForKey:@"date"];
        self.priority = [decoder decodeIntegerForKey:@"priority"];
        self.state = [decoder decodeIntegerForKey:@"state"];
        self.uId = [decoder decodeObjectForKey:@"uId"];
    }
    return self;
}
@end
