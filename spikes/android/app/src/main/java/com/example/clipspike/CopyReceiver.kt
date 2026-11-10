package com.example.clipspike

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/** Variant A: runs with no UI, even if the app was swiped away. */
class CopyReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        Spike.copy(context, intent, foreground = false)
    }
}
