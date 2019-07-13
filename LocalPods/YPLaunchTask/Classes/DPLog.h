//
//  DCLog.h
//
//  Created by huangzhimou on 25/2/19.
//
//

#ifndef DPLog_h
#define DPLog_h

#ifdef DEBUG

#else
    #define NSLog(FORMAT, ...) nil
#endif

#endif /* DCLog_h */
