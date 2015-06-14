package com.nesl.fatimanwar.packetfloodapp;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import java.io.IOException;


public class MainActivity extends Activity {
    private static final String TAG = "MainActivity";

    private final Handler mHandler = new Handler();
    private Runnable mTimer;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        final TextView info = (TextView) findViewById(R.id.info);

        findViewById(R.id.startping).setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {

                mTimer = new Runnable() {
                    @Override
                    public void run() {//Sending ping of duration ?? every 20sec
                        new SendPing(getBaseContext()).execute();
                        mHandler.postDelayed(this, 20000);
                    }
                };
                mHandler.postDelayed(mTimer, 20000);


            }
        });

        findViewById(R.id.stopping).setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                ActivityManager am = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
                boolean result = false;

                /*for (ActivityManager.RunningAppProcessInfo pid : am.getRunningAppProcesses()) {
                    am.killBackgroundProcesses(pid.processName);
                }*/
                mHandler.removeCallbacks(mTimer);

             /*   if (am != null) {
                    //am.killBackgroundProcesses("com.nesl.fatimanwar.packetfloodapp");
                    //result = !isPackageRunning("com.nesl.fatimanwar.packetfloodapp");
                    am.killBackgroundProcesses(findPIDbyPackageName("com.nesl.fatimanwar.packetfloodapp"));
                    //Log.e(TAG, "killing process: "+result);
                }
                if(!result)
                    info.setText("ping is still running");
                    */

            }
        });

    }

    public String findPIDbyPackageName(String packagename) {
        //int result = -1;
        String result = null;

        ActivityManager am = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);

        if (am != null) {
            for (ActivityManager.RunningAppProcessInfo pi : am.getRunningAppProcesses()){
                if (pi.processName.equalsIgnoreCase(packagename)) {
                    //result = pi.pid;
                    result = pi.processName;
                }
                if (result != null) break;
            }
        } else {
            result = null;
        }
        Log.e(TAG, "pid: "+result);
        return result;
    }
    /*public boolean isPackageRunning(String packagename) {
        return findPIDbyPackageName(packagename) != -1;
    }*/

    @Override
    protected void onDestroy() {
        super.onDestroy();
        mHandler.removeCallbacks(mTimer);
    }
}

class SendPing extends AsyncTask<Void, Void, Void> {

    String TAG = "SendPing";
    private Context context;
    Process  mIpAddrProcess = null;

    public SendPing(Context context) {
        this.context = context;
    }

    @Override
    protected Void doInBackground(Void... params) {
        Runtime runtime = Runtime.getRuntime();
        try
        {
            mIpAddrProcess = runtime.exec("/system/bin/ping -i 0.1 -s 500 -c 100 www.ucla.edu");
            //int mExitValue = mIpAddrProcess.waitFor();
            //Log.d(TAG, " mExitValue " + mExitValue);
        }
                /*catch (InterruptedException ignore)
                {
                    ignore.printStackTrace();
                    Log.d(TAG, " Exception:" + ignore);
                }*/
        catch (IOException e)
        {
            e.printStackTrace();
            Log.d(TAG, " Exception:" + e);
        }
        return null;
    }
}
