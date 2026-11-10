package com.example.clipspike

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.ClipData
import android.content.ClipDescription
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.graphics.drawable.Icon
import android.os.PersistableBundle
import android.util.Log
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * Variants under test, each puts the notification's text on the clipboard:
 *  A  "Copy (A)" action -> BroadcastReceiver, app stays in the background
 *  B  "Copy (B)" action -> invisible activity copies and closes
 *  C  tap the notification -> same invisible activity
 */
object Spike {
    const val CHANNEL = "clips"
    const val EXTRA_TEXT = "text"
    const val EXTRA_VARIANT = "variant"
    const val EXTRA_ID = "id"
    private const val PREFS = "spike"
    private const val LOG_KEY = "log"
    private const val RESULT_CHANNEL = "results"

    private fun now(): String = SimpleDateFormat("HH:mm:ss", Locale.US).format(Date())

    fun ensureChannels(ctx: Context) {
        val nm = ctx.getSystemService(NotificationManager::class.java)
        nm.createNotificationChannel(NotificationChannel(CHANNEL, "Text from your computer", NotificationManager.IMPORTANCE_HIGH))
        nm.createNotificationChannel(NotificationChannel(RESULT_CHANNEL, "Spike results", NotificationManager.IMPORTANCE_LOW))
    }

    fun postTestNotification(ctx: Context) {
        ensureChannels(ctx)
        val id = (System.currentTimeMillis() % 100_000).toInt()
        val text = "clip-relay test ${now()}"
        val flags = PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT

        fun extras(i: Intent, variant: String) = i
            .putExtra(EXTRA_TEXT, text).putExtra(EXTRA_VARIANT, variant).putExtra(EXTRA_ID, id)

        val a = PendingIntent.getBroadcast(ctx, id * 10 + 1,
            extras(Intent(ctx, CopyReceiver::class.java), "A background receiver"), flags)
        val b = PendingIntent.getActivity(ctx, id * 10 + 2,
            extras(Intent(ctx, CopyActivity::class.java), "B action opens activity")
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK), flags)
        val c = PendingIntent.getActivity(ctx, id * 10 + 3,
            extras(Intent(ctx, CopyActivity::class.java), "C tap opens activity")
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK), flags)
        val icon = Icon.createWithResource(ctx, android.R.drawable.ic_menu_edit)

        val n = Notification.Builder(ctx, CHANNEL)
            .setSmallIcon(android.R.drawable.ic_menu_edit)
            .setContentTitle("Text from your computer")
            .setContentText(text)
            .setContentIntent(c)
            .setAutoCancel(true)
            .addAction(Notification.Action.Builder(icon, "Copy (A)", a).build())
            .addAction(Notification.Action.Builder(icon, "Copy (B)", b).build())
            .build()
        ctx.getSystemService(NotificationManager::class.java).notify(id, n)
        log(ctx, "posted notification $id: $text")
    }

    /** Writes the clip. Background apps can't read the clipboard back, so the real check is pasting. */
    fun copy(ctx: Context, intent: Intent, foreground: Boolean): String {
        val text = intent.getStringExtra(EXTRA_TEXT) ?: ""
        val variant = intent.getStringExtra(EXTRA_VARIANT) ?: "?"
        val id = intent.getIntExtra(EXTRA_ID, 0)
        val result = try {
            val clip = ClipData.newPlainText("clip-relay", text)
            clip.description.extras = PersistableBundle().apply {
                putBoolean(ClipDescription.EXTRA_IS_SENSITIVE, false)
            }
            ctx.getSystemService(ClipboardManager::class.java).setPrimaryClip(clip)
            "setPrimaryClip OK"
        } catch (e: Exception) {
            "setPrimaryClip THREW ${e.javaClass.simpleName}: ${e.message}"
        }
        ctx.getSystemService(NotificationManager::class.java).cancel(id)
        val line = "$variant (foreground=$foreground): $result -- now paste somewhere to confirm"
        log(ctx, line)
        postResult(ctx, variant, result)
        return line
    }

    private fun postResult(ctx: Context, variant: String, result: String) {
        ensureChannels(ctx)
        val n = Notification.Builder(ctx, RESULT_CHANNEL)
            .setSmallIcon(android.R.drawable.ic_menu_info_details)
            .setContentTitle("ClipSpike $variant")
            .setContentText("$result. Paste to confirm.")
            .setAutoCancel(true)
            .build()
        ctx.getSystemService(NotificationManager::class.java).notify(1, n)
    }

    fun log(ctx: Context, line: String) {
        Log.i("ClipSpike", line)
        val prefs = ctx.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        val old = prefs.getString(LOG_KEY, "") ?: ""
        prefs.edit().putString(LOG_KEY, "[${now()}] $line\n$old".take(20_000)).apply()
    }

    fun readLog(ctx: Context): String =
        ctx.getSharedPreferences(PREFS, Context.MODE_PRIVATE).getString(LOG_KEY, "") ?: ""

    fun clearLog(ctx: Context) =
        ctx.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit().remove(LOG_KEY).apply()
}
