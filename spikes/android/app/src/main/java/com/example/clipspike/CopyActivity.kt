package com.example.clipspike

import android.app.Activity
import android.os.Bundle

/** Variants B and C: an invisible activity takes focus, copies, and closes. */
class CopyActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Spike.copy(this, intent, foreground = true)
        finish()
    }
}
