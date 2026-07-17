import Flutter
import UIKit

public class FiaPlugin: NSObject, FlutterPlugin {

    private let methodCallHandler = FiaMethodCallHandler()

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "fia", binaryMessenger: registrar.messenger())
        let instance = FiaPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        // Delivers the magic link back to FIA without the host app having to
        // touch its own AppDelegate.
        registrar.addApplicationDelegate(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        methodCallHandler.handle(call, result: result)
    }

    // Both handlers below return false on purpose: FIA gives us no way to know
    // whether the link was one of its magic links, and returning true would
    // mark it handled and stop it reaching the host app's other plugins.
    public func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([Any]) -> Void
    ) -> Bool {
        methodCallHandler.onMagicLink(userActivity: userActivity)
        return false
    }

    public func application(
        _ application: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any]
    ) -> Bool {
        methodCallHandler.onMagicLink(url: url.absoluteString)
        return false
    }
}
