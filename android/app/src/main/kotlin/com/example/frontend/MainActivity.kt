package com.petrichor4.yoyo

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.android.gms.oss.licenses.OssLicensesMenuActivity

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.petrichor4.yoyo/licenses"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "showNativeLicenses" -> {
                    showNativeLicenses()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun showNativeLicenses() {
        startActivity(Intent(this, OssLicensesMenuActivity::class.java))
    }
}
