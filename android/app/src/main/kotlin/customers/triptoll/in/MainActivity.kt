package customers.triptoll.`in`

import android.content.Intent
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "map_share"
    private lateinit var methodChannel: MethodChannel

    // 🔥 ADD: cache for shared text
    private var cachedSharedText: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        Log.d("MAP_SHARE", "🔥 FlutterEngine configured")

        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        )

        // 🔥 ADD: Flutter can PULL cached data
        methodChannel.setMethodCallHandler { call, result ->
            if (call.method == "getInitialSharedText") {
                Log.d("MAP_SHARE", "📤 Sending cached text: $cachedSharedText")
                result.success(cachedSharedText)
                cachedSharedText = null // consume once
            } else {
                result.notImplemented()
            }
        }

        // Handle app launch via share
        handleSendIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        Log.d("MAP_SHARE", "♻ onNewIntent received")
        handleSendIntent(intent)
    }

    private fun handleSendIntent(intent: Intent?) {
        if (intent?.action == Intent.ACTION_SEND && intent.type == "text/plain") {
            val sharedText = intent.getStringExtra(Intent.EXTRA_TEXT)

            if (!sharedText.isNullOrEmpty()) {
                Log.d("MAP_SHARE", "📍 Received shared text: $sharedText")

                // 🔥 ADD: cache it
                cachedSharedText = sharedText

                // 🔥 PUSH to Flutter (works when ready)
                if (::methodChannel.isInitialized) {
                    methodChannel.invokeMethod("newSharedLink", sharedText)
                }
            }
        }
    }
}
