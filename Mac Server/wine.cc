#include <node.h>
#include <v8.h>

using namespace v8;

void GetMessage(const v8::FunctionCallbackInfo<Value>& args) {
    Isolate* isolate = Isolate::GetCurrent();
    HandleScope scope(isolate);
    args.GetReturnValue().Set(String::NewFromUtf8(isolate, "Wine"));
}

void Init(Handle<Object> exports) {
    Isolate* isolate = Isolate::GetCurrent();
    exports->Set(String::NewFromUtf8(isolate, "getMessage"),
                 FunctionTemplate::New(isolate, GetMessage)->GetFunction());
}

NODE_MODULE(wineAddon, Init)