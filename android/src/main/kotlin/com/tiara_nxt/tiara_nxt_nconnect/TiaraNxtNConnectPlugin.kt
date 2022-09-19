package com.tiara_nxt.tiara_nxt_nconnect

import androidx.annotation.NonNull
import android.Manifest
import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.content.*
import android.content.pm.PackageManager
import android.os.IBinder
import androidx.core.app.ActivityCompat
import com.neotechid.nconnect.ReaderEvent
import com.neotechid.nconnect.RfidEventListener

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
import io.flutter.plugin.common.EventChannel
import org.json.JSONObject

/** TiaraNxtNConnectPlugin */
class TiaraNxtNConnectPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var context: Context
    private lateinit var activity: Activity

    private lateinit var channel: MethodChannel

    private lateinit var eventChannel : EventChannel
    private var eventSink: EventChannel.EventSink? = null

    private val rfidFactory: RfidFactory = RfidFactory.getInstance()
    private lateinit var rfidReader: RfidReader

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "tiara_nxt_nconnect")
        channel.setMethodCallHandler(this)
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "tiara_nxt_nconnect/events")
        eventChannel.setStreamHandler(rfidEventStreamHandler)
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
                val success : Boolean = getRfidReader(call.arguments as List<String>)
                if(success) {
                    registerListener()
                }
                result.success(success)
            }
            "getBatteryLevel" -> {
                result.success(getBatteryLevel())
            }
            "startScan" -> {
                result.success(startScan())
            }
            "stopScan" -> {
                result.success(stopScan())
            }
            "setPower" -> {
                result.success(setPower(call.arguments as Double))
            }
            "getPower" -> {
                result.success(getPower())
            }
            "setScanSpeed" -> {
                result.success(setScanSpeed(call.arguments as Int))
            }
            "getScanSpeed" -> {
                result.success(getScanSpeed())
            }
            "writeToTag" -> {
                result.success(writeToTag(call.arguments as String))
            }
            "isScanning" -> {
                result.success(isScanning())
            }
        }
    }

    private val rfidEventStreamHandler = object : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            eventSink = events
        }

        override fun onCancel(arguments: Any?) {
            eventSink = null
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        println("[onDetachedFromActivityForConfigChanges] TODO(\"Not yet implemented\")")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        println("[onReattachedToActivityForConfigChanges] TODO(\"Not yet implemented\")")
    }

    override fun onDetachedFromActivity() {
        println("[onDetachedFromActivity] TODO(\"Not yet implemented\")")
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

    private fun startScan(): Boolean {
        return rfidReader.startScan()
    }

    private fun stopScan(): Boolean {
        return rfidReader.stopScan()
    }

    private fun setPower(power: Double) {
        rfidReader.power = power
    }

    private fun getPower(): Double {
        return rfidReader.power
    }

    private fun setScanSpeed(speed: Int) {
        rfidReader.scanSpeed = speed
    }

    private fun getScanSpeed(): Int {
        return rfidReader.scanSpeed
    }

    private fun writeToTag(data: String): Int {
        return rfidReader.writeToTag(data)
    }

    private fun isScanning(): Boolean {
        return rfidReader.isScanning
    }

    private val rfidEventListener = object : RfidEventListener {
        override fun handleData(tagData: String?, antennaId: Int, scanDistance: Int) {
            println("Read TAG: $tagData\tAntenna ID: $antennaId\tScan Distance: $scanDistance")
            val response = HashMap<String, Any?>()
            response["event"] = "handleData"
            response["readTag"] = tagData
            response["antennaId"] = antennaId
            response["scanDistance"] = scanDistance
            val data = JSONObject(response).toString()
            eventSink?.success(data)
            eventSink?.success("[handleData] Read TAG: $tagData\tAntenna ID: $antennaId\tScan Distance: $scanDistance")
        }

        override fun handleError(errorMessage: String?) {
            println("Error: $errorMessage")
            val response = HashMap<String, Any?>()
            response["event"] = "handleError"
            response["error"] = errorMessage
            val data = JSONObject(response).toString()
            eventSink?.success(data)
            eventSink?.success("[handleError] Error: $errorMessage")
        }

        override fun handleReaderEvent(readerEvent: ReaderEvent?) {
            println("Reader Event: $readerEvent")
            val response = HashMap<String, Any?>()
            response["event"] = "handleReaderEvent"
            response["readerEvent"] = readerEvent.toString()
            val data = JSONObject(response).toString()
            eventSink?.success(data)
            eventSink?.success("[handleReaderEvent] Reader Event: $readerEvent")
        }

        override fun handleReaderEvent(readerEvent: ReaderEvent?, p1: String?) {
            println("[handleReaderEvent] TODO(\"Not yet implemented\")")
        }

        override fun setEnabled(p0: Boolean) {
            println("[setEnabled] TODO(\"Not yet implemented\")")
        }

        override fun isEnabled(): Boolean {
            // return true, as guided by Neha ma'am
            return true
        }
    }

    private fun registerListener() {
        rfidReader.registerListener(rfidEventListener)
    }

}
