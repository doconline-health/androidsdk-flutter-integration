package com.sdkdoconline.sdkdoconline

import com.doconline.doconline.SplashScreenActivity
import com.doconline.doconline.app.Constants
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(){
    private val docOnlineSDkChannel = "DocOnlineSDK/launcher"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, docOnlineSDkChannel)
            .setMethodCallHandler { call, result ->

                if (call.method == "openDocOnlineSDK") {

                    val requestObject = call.argument<String>("requestObject")
                    val responseObject = call.argument<String>("responseObject")

                    SplashScreenActivity.start(
                        this,
                        requestObject,
                        responseObject,
                        Constants.STAGING_BUILD_TYPE,
                        Constants.DOCONLINE_THEME,
                        ""
                    )

                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }
}
