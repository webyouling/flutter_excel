package com.zx.flutter_excel;

import android.app.Activity;
import android.content.Context;
import android.os.Environment;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.zx.flutter_excel.Bean.DemoBean;
import com.zx.flutter_excel.Utils.ExcelUtil;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterExcelPlugin
 */
public class FlutterExcelPlugin implements MethodCallHandler {

    private Activity mActivity;
    private Gson gson;

    FlutterExcelPlugin(Registrar registrar) {
        mActivity = registrar.activity();
        gson = new Gson();
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_excel");
        channel.setMethodCallHandler(new FlutterExcelPlugin(registrar));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("exportData")) {
            Map arg = call.arguments();
            final String infoData = arg.get("infodata").toString();
            exportExcel(infoData, result);
        } else {
            result.notImplemented();
        }
    }

    private void exportExcel(String infoData, Result result) {
        if (!infoData.isEmpty()) {
            if (gson == null) gson = new Gson();
            List<DemoBean> demoBeanList = gson.fromJson(infoData, new TypeToken<List<DemoBean>>() {
            }.getType());
            String fliePath = Environment.getExternalStorageDirectory().getPath() + File.separator + "QRExcel"+ File.separator;
            File file = new File(fliePath);
            if (!file.exists()) {
                file.mkdirs();
            }
            String excelFileName = System.currentTimeMillis() + ".xls";
            String[] title = {"类型", "内容", "时间"};
            String sheetName = "infoData";
            fliePath = fliePath + excelFileName;

            boolean isInit = ExcelUtil.initExcel(fliePath, sheetName, title);
            if (isInit) {
                boolean isWrite = ExcelUtil.writeObjListToExcel(demoBeanList, fliePath, mActivity);
                if (isWrite) {
                    result.success(fliePath);
                } else {
                    result.success(null);
                }
            } else {
                result.success(null);
            }
        } else {
            result.success(null);
        }
    }
}