import Flutter

public class FiaPlugin: NSObject, FlutterPlugin {
    
    private let methodCallHandler = FiaMethodCallHandler()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "fia", binaryMessenger: registrar.messenger())
        let instance = FiaPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        methodCallHandler.handle(call, result: result)
    }
}
