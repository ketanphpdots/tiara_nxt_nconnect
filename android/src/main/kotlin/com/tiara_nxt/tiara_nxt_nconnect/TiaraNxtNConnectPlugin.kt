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
import com.neotechid.nconnect.util.DatatypeConvertor

/** TiaraNxtNConnectPlugin */
class TiaraNxtNConnectPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var context: Context
    private lateinit var activity: Activity

    private lateinit var channel: MethodChannel

    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null

    private val rfidFactory: RfidFactory = RfidFactory.getInstance()

    private var stringToRfidReaderMap: HashMap<String, RfidReader> = HashMap()

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "tiara_nxt_nconnect")
        channel.setMethodCallHandler(this)
        eventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, "tiara_nxt_nconnect/events")
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
                val args = call.arguments as Map<String, *>
                val make = args["make"] as String
                val mac = args["mac"] as String
                val success: Boolean = getRfidReader(make, mac)
                result.success(success)
            }
            "getBatteryLevel" -> {
                val args = call.arguments as Map<String, *>
                val mac = args["mac"] as String
                result.success(getBatteryLevel(mac))
            }
            "startScan" -> {
                val args = call.arguments as Map<String, *>
                val mac = args["mac"] as String
                result.success(startScan(mac))
            }
            "stopScan" -> {
                val args = call.arguments as Map<String, *>
                val mac = args["mac"] as String
                result.success(stopScan(mac))
            }
            "setPower" -> {
                val args = call.arguments as Map<String, *>
                val mac = args["mac"] as String
                val power = args["power"] as Double
                result.success(setPower(mac, power))
            }
            "getPower" -> {
                val args = call.arguments as Map<String, *>
                val mac = args["mac"] as String
                result.success(getPower(mac))
            }
            "setScanSpeed" -> {
                val args = call.arguments as Map<String, *>
                val mac = args["mac"] as String
                val speed = args["speed"] as Int
                result.success(setScanSpeed(mac, speed))
            }
            "getScanSpeed" -> {
                val args = call.arguments as Map<String, *>
                val mac = args["mac"] as String
                result.success(getScanSpeed(mac))
            }
            "writeToTag" -> {
                val args = call.arguments as Map<String, *>
                val mac = args["mac"] as String
                val data = args["data"] as String
                result.success(writeToTag(mac, data))
            }
            "isScanning" -> {
                val args = call.arguments as Map<String, *>
                val mac = args["mac"] as String
                result.success(isScanning(mac))
            }
            "disconnect" -> {
                val args = call.arguments as Map<String, *>
                val mac = args["mac"] as String
                result.success(disconnect(mac))
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
            println("[onServiceConnected] $p0, $p1")
        }

        override fun onServiceDisconnected(p0: ComponentName?) {
            println("[onServiceDisconnected] $p0")
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

    private fun getRfidReader(make: String, mac: String): Boolean {
        return try {
            if (!stringToRfidReaderMap.containsKey(mac)) {
                val newRfidReader = rfidFactory.getRfidReader(make, mac, "android")
                newRfidReader.connect()
                newRfidReader.registerListener(getRfidEventListener(mac))
                stringToRfidReaderMap[mac] = newRfidReader
            }
            true
        } catch (e: Exception) {
            println(e.toString())
            false
        }
    }

    private fun getBatteryLevel(mac: String): Int {
        return try {
            if (stringToRfidReaderMap.containsKey(mac)) {
                return stringToRfidReaderMap[mac]!!.batteryLevel
            }
            return -1
        } catch (e: Exception) {
            println(e.toString())
            -1
        }
    }

    private fun startScan(mac: String): Boolean {
        if (stringToRfidReaderMap.containsKey(mac)) {
            return stringToRfidReaderMap[mac]!!.startScan()
        }
        return false
    }

    private fun stopScan(mac: String): Boolean {
        if (stringToRfidReaderMap.containsKey(mac)) {
            return stringToRfidReaderMap[mac]!!.stopScan()
        }
        return false
    }

    private fun setPower(mac: String, power: Double) {
        if (stringToRfidReaderMap.containsKey(mac)) {
            stringToRfidReaderMap[mac]!!.power = power
        }
    }

    private fun getPower(mac: String): Double {
        if (stringToRfidReaderMap.containsKey(mac)) {
            return stringToRfidReaderMap[mac]!!.power
        }
        return -1.0
    }

    private fun setScanSpeed(mac: String, speed: Int) {
        if (stringToRfidReaderMap.containsKey(mac)) {
            stringToRfidReaderMap[mac]!!.scanSpeed = speed
        }
    }

    private fun getScanSpeed(mac: String): Int {
        if (stringToRfidReaderMap.containsKey(mac)) {
            return stringToRfidReaderMap[mac]!!.scanSpeed
        }
        return -1
    }

    private fun writeToTag(mac: String, data: String): Int {
        if (stringToRfidReaderMap.containsKey(mac)) {
            stringToRfidReaderMap[mac]!!.writeToTag(data)
        }
        return -1
    }

    private fun isScanning(mac: String): Boolean {
        if (stringToRfidReaderMap.containsKey(mac)) {
            return stringToRfidReaderMap[mac]!!.isScanning
        }
        return false
    }

    private fun disconnect(mac: String): Boolean {
        if (stringToRfidReaderMap.containsKey(mac)) {
            return stringToRfidReaderMap[mac]!!.disconnect()
        }
        return false
    }

    private fun getRfidEventListener(mac: String): RfidEventListener {
        val rfidEventListener = object : RfidEventListener {
            override fun handleData(tagData: String?, antennaId: Int, scanDistance: Int) {
                println("[handleData] Read TAG: $tagData\tAntenna ID: $antennaId\tScan Distance: $scanDistance")
                val response = HashMap<String, Any?>()
                response["event"] = "handleData"
                response["readerMac"] = mac
                response["readTag"] = DatatypeConvertor.hexToAsciiString(tagData)
                response["antennaId"] = antennaId
                response["scanDistance"] = scanDistance
                val data = JSONObject(response).toString()
                eventSink?.success(data)
            }

            override fun handleError(errorMessage: String?) {
                println("[handleError] Error: $errorMessage")
                val response = HashMap<String, Any?>()
                response["event"] = "handleError"
                response["readerMac"] = mac
                response["error"] = errorMessage
                val data = JSONObject(response).toString()
                eventSink?.success(data)
            }

            override fun handleReaderEvent(readerEvent: ReaderEvent?) {
                println("[handleReaderEvent] Reader Event: $readerEvent")
                val response = HashMap<String, Any?>()
                response["event"] = "handleReaderEvent"
                response["readerMac"] = mac
                response["readerEvent"] = readerEvent.toString()
                val data = JSONObject(response).toString()
                eventSink?.success(data)
            }

            override fun handleReaderEvent(readerEvent: ReaderEvent?, p1: String?) {
                println("[handleReaderEvent] Reader Event: $readerEvent\tP1: $p1")
                val response = HashMap<String, Any?>()
                response["event"] = "handleReaderEvent"
                response["readerEvent"] = readerEvent.toString()
                response["p1"] = p1
                val data = JSONObject(response).toString()
                eventSink?.success(data)
            }

            override fun setEnabled(p0: Boolean) {
                println("[setEnabled] TODO(\"Not yet implemented\")")
            }

            override fun isEnabled(): Boolean {
                // return true, as guided by Neha ma'am
                return true
            }
        }
        return rfidEventListener
    }
}
