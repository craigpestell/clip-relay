package com.example.clipspike

import android.Manifest
import android.app.Activity
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.widget.Button
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView

class MainActivity : Activity() {
    private lateinit var logView: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val pad = (16 * resources.displayMetrics.density).toInt()
        val column = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(pad, pad * 2, pad, pad)
        }
        fun button(label: String, onClick: () -> Unit) =
            column.addView(Button(this).apply { text = label; setOnClickListener { onClick() } })

        column.addView(TextView(this).apply {
            text = "1. Allow notifications. 2. Send a test, then go to the home screen. " +
                "3. Use Copy (A), Copy (B) or tap the notification. 4. Paste somewhere to check. " +
                "Also try A after swiping the app away from Recents."
        })
        button("Allow notifications") {
            if (Build.VERSION.SDK_INT >= 33) requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), 1)
        }
        button("Send test notification in 5 s") {
            Spike.log(this, "scheduling test notification")
            Handler(Looper.getMainLooper()).postDelayed({ Spike.postTestNotification(applicationContext) }, 5_000)
        }
        button("Refresh log") { refresh() }
        button("Clear log") { Spike.clearLog(this); refresh() }
        logView = TextView(this).apply { setTextIsSelectable(true); typeface = android.graphics.Typeface.MONOSPACE }
        column.addView(logView)
        setContentView(ScrollView(this).apply { addView(column) })
    }

    override fun onResume() {
        super.onResume()
        refresh()
    }

    private fun refresh() {
        logView.text = "Device: ${Build.MANUFACTURER} ${Build.MODEL}, Android ${Build.VERSION.RELEASE} (API ${Build.VERSION.SDK_INT})\n\n" +
            Spike.readLog(this)
    }
}
