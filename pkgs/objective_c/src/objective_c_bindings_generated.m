#include <stdint.h>
#import "foundation.h"
#import "input_stream_adapter.h"
#import "proxy.h"

#if !__has_feature(objc_arc)
#error "This file must be compiled with ARC enabled"
#endif

id objc_retain(id);
id objc_retainBlock(id);

Protocol* _ObjectiveCBindings_NSStreamDelegate() { return @protocol(NSStreamDelegate); }

typedef void  (^_ListenerTrampoline)(id arg0, id arg1, id arg2);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline _ObjectiveCBindings_wrapListenerBlock_1j2nt86(_ListenerTrampoline block) NS_RETURNS_RETAINED {
  return ^void(id arg0, id arg1, id arg2) {
    objc_retainBlock(block);
    block(objc_retainBlock(arg0), objc_retain(arg1), objc_retain(arg2));
  };
}

typedef void  (^_BlockingTrampoline)(void * waiter, id arg0, id arg1, id arg2);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline _ObjectiveCBindings_wrapBlockingBlock_1j2nt86(
    _BlockingTrampoline block, double timeoutSeconds, void* (*newWaiter)(double),
    void (*awaitWaiter)(void*)) NS_RETURNS_RETAINED {
  return ^void(id arg0, id arg1, id arg2) {
    void* waiter = newWaiter(timeoutSeconds);
    block(waiter, arg0, arg1, arg2);
    awaitWaiter(waiter);
  };
}

typedef void  (^_ListenerTrampoline1)(void * arg0);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline1 _ObjectiveCBindings_wrapListenerBlock_ovsamd(_ListenerTrampoline1 block) NS_RETURNS_RETAINED {
  return ^void(void * arg0) {
    objc_retainBlock(block);
    block(arg0);
  };
}

typedef void  (^_BlockingTrampoline1)(void * waiter, void * arg0);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline1 _ObjectiveCBindings_wrapBlockingBlock_ovsamd(
    _BlockingTrampoline1 block, double timeoutSeconds, void* (*newWaiter)(double),
    void (*awaitWaiter)(void*)) NS_RETURNS_RETAINED {
  return ^void(void * arg0) {
    void* waiter = newWaiter(timeoutSeconds);
    block(waiter, arg0);
    awaitWaiter(waiter);
  };
}

typedef void  (^_ListenerTrampoline2)(void * arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline2 _ObjectiveCBindings_wrapListenerBlock_wjovn7(_ListenerTrampoline2 block) NS_RETURNS_RETAINED {
  return ^void(void * arg0, id arg1) {
    objc_retainBlock(block);
    block(arg0, objc_retain(arg1));
  };
}

typedef void  (^_BlockingTrampoline2)(void * waiter, void * arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline2 _ObjectiveCBindings_wrapBlockingBlock_wjovn7(
    _BlockingTrampoline2 block, double timeoutSeconds, void* (*newWaiter)(double),
    void (*awaitWaiter)(void*)) NS_RETURNS_RETAINED {
  return ^void(void * arg0, id arg1) {
    void* waiter = newWaiter(timeoutSeconds);
    block(waiter, arg0, arg1);
    awaitWaiter(waiter);
  };
}

typedef void  (^_ListenerTrampoline3)(void * arg0, id arg1, NSStreamEvent arg2);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline3 _ObjectiveCBindings_wrapListenerBlock_18d6mda(_ListenerTrampoline3 block) NS_RETURNS_RETAINED {
  return ^void(void * arg0, id arg1, NSStreamEvent arg2) {
    objc_retainBlock(block);
    block(arg0, objc_retain(arg1), arg2);
  };
}

typedef void  (^_BlockingTrampoline3)(void * waiter, void * arg0, id arg1, NSStreamEvent arg2);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline3 _ObjectiveCBindings_wrapBlockingBlock_18d6mda(
    _BlockingTrampoline3 block, double timeoutSeconds, void* (*newWaiter)(double),
    void (*awaitWaiter)(void*)) NS_RETURNS_RETAINED {
  return ^void(void * arg0, id arg1, NSStreamEvent arg2) {
    void* waiter = newWaiter(timeoutSeconds);
    block(waiter, arg0, arg1, arg2);
    awaitWaiter(waiter);
  };
}

typedef void  (^_ListenerTrampoline4)(id arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline4 _ObjectiveCBindings_wrapListenerBlock_wjvic9(_ListenerTrampoline4 block) NS_RETURNS_RETAINED {
  return ^void(id arg0, id arg1) {
    objc_retainBlock(block);
    block(objc_retain(arg0), objc_retain(arg1));
  };
}

typedef void  (^_BlockingTrampoline4)(void * waiter, id arg0, id arg1);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline4 _ObjectiveCBindings_wrapBlockingBlock_wjvic9(
    _BlockingTrampoline4 block, double timeoutSeconds, void* (*newWaiter)(double),
    void (*awaitWaiter)(void*)) NS_RETURNS_RETAINED {
  return ^void(id arg0, id arg1) {
    void* waiter = newWaiter(timeoutSeconds);
    block(waiter, arg0, arg1);
    awaitWaiter(waiter);
  };
}
