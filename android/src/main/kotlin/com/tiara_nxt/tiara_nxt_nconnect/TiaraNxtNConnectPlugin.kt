package com.tiara_nxt.tiara_nxt_nconnect

import androidx.annotation.NonNull
import android.Manifest
import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.content.*
import android.content.pm.PackageManager
import android.os.IBinder
import androidx.core.app.ActivityCompat

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import com.neotechid.nconnect.RfidFactory
import com.neotechid.nconnect.RfidReader
import com.neotechid.nconnect.bluetooth.AndroidBleConnector
import com.neotechid.nconnect.bluetooth.AndroidBluetoothConnector
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** TiaraNxtNConnectPlugin */
class TiaraNxtNConnectPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var context: Context
    private lateinit var activity: Activity

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private val rfidFactory: RfidFactory = RfidFactory.getInstance()

    private lateinit var rfidReader: RfidReader

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "tiara_nxt_nconnect")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "ping" -> {
                result.success(ping())
            }
            "startBluetoothService" -> {
                startBluetoothService()
                startBLEService()
                result.success(null)
            }
            "getRfidReader" -> {
                result.success(getRfidReader(call.arguments as List<String>))
            }
            "getBatteryLevel" -> {
                result.success(
                    getBatteryLevel
                        ()
                )
            }
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        TODO("Not yet implemented")
    }

    override fun onDetachedFromActivity() {
        TODO("Not yet implemented")
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun ping(): String {
        return "pong"
    }

    private fun startBluetoothService() {
        try {
            activity.startService(Intent(context, AndroidBluetoothConnector::class.java))
            doBindService()
        } catch (e: Exception) {
            println(e.toString())
        }
    }

    private fun doBindService() {
        try {
            val adapter: BluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
            if (!adapter.isEnabled) {
                val enableBT = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
                if (ActivityCompat.checkSelfPermission(
                        context,
                        Manifest.permission.BLUETOOTH_CONNECT
                    ) != PackageManager.PERMISSION_GRANTED
                ) {
                    return
                }
                activity.startActivityForResult(enableBT, 1061)
                activity.bindService(
                    Intent(context, AndroidBluetoothConnector::class.java),
                    serviceConnection,
                    Context.BIND_AUTO_CREATE
                )
            }
        } catch (e: Exception) {
            println(e.toString())
        }
    }

    private val serviceConnection = object : ServiceConnection {
        override fun onServiceConnected(p0: ComponentName?, p1: IBinder?) {

        }

        override fun onServiceDisconnected(p0: ComponentName?) {

        }

    }

    private fun startBLEService() {
        try {
            activity.startService(Intent(context, AndroidBleConnector::class.java))
            activity.bindService(
                Intent(context, AndroidBleConnector::class.java),
                serviceConnection,
                Context.BIND_AUTO_CREATE
            )
            activity.registerReceiver(
                mBleServiceConnectReceiver,
                IntentFilter("NCONNECT_BLE_SERVICE_CONNECTED")
            )
            activity.registerReceiver(
                mBleDiscoveredReceiver,
                IntentFilter("NCONNECT_BLE_DEVICE_DISCOVERED")
            )
        } catch (e: Exception) {
            println(e.toString())
        }
    }

    private val mBleServiceConnectReceiver = object : BroadcastReceiver() {
        override fun onReceive(ctx: Context?, intent: Intent?) {
            val action: String? = intent?.action
            if (action.equals("NCONNECT_BLE_SERVICE_CONNECTED")) {
                println("NCONNECT_BLE_SERVICE_CONNECTED")
            }
        }
    }

    private val mBleDiscoveredReceiver = object : BroadcastReceiver() {
        override fun onReceive(ctx: Context?, intent: Intent?) {
            val action: String? = intent?.action
            if (action.equals("NCONNECT_BLE_DEVICE_DISCOVERED")) {
                println("NCONNECT_BLE_DEVICE_DISCOVERED")
            }
        }
    }

    private fun getRfidReader(args: List<String>): Boolean {
        return try {
            rfidReader =
                rfidFactory.getRfidReader(args[0], args[1], "android")
            rfidReader.connect()
            true
        } catch (e: Exception) {
            println(e.toString())
            false
        }
    }

    private fun getBatteryLevel(): Int {
        return try {
            val batteryLevel = rfidReader.batteryLevel
            batteryLevel
        } catch (e: Exception) {
            println(e.toString())
            -1
        }
    }
}
