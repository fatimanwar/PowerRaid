package com.nesl.fatimanwar.cameraspy;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.hardware.Camera;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.widget.Button;


public class MainActivity extends Activity {
    public static final String DEBUG_TAG = "MainActivity";
    private Camera mCamera = null;
    CameraPreview mPreview;
    private CameraCallBackProcedure mPicture;

    private final Handler mHandler = new Handler();
    private Runnable mTimer;
    Button captureButton;



    /** Check if this device has a camera */
    private boolean checkCameraHardware(Context context) {
        if (context.getPackageManager().hasSystemFeature(PackageManager.FEATURE_CAMERA)){
            // this device has a camera
            return true;
        } else {
            // no camera on this device
            return false;
        }
    }

    /** A safe way to get an instance of the Camera object. */
    public static Camera getCameraInstance(){
        Camera c = null;
        try {
            c = Camera.open(); // attempt to get a Camera instance
        }
        catch (Exception e){
            // Camera is not available (in use or does not exist)
        }
        return c; // returns null if camera is unavailable
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        // Create an instance of Camera
        mCamera = getCameraInstance();

        // Create our Preview view and set it as the content of our activity.
        //mPreview = new CameraPreview(this, mCamera);
        //FrameLayout preview = (FrameLayout) findViewById(R.id.camera_preview);
        //preview.addView(mPreview);

       /* try {
            releaseCameraAndPreview();
            camera = Camera.open();
        } catch (Exception e) {
            Log.e(getString(R.string.app_name), "failed to open Camera");
            e.printStackTrace();
        }

        if(mCamera != null) {
            mTimer = new Runnable() {
                @Override
                public void run() {
                    captureButton.performClick();
                    //mCamera.takePicture(null, null, new CameraCallBackProcedure(getApplicationContext()));
                    mHandler.postDelayed(this, 5000);
                }
            };
            mHandler.postDelayed(mTimer, 5000);
        }
*/
        mPicture = new CameraCallBackProcedure(getApplicationContext());
        captureButton = (Button) findViewById(R.id.button_capture);
        captureButton.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        // get an image from the camera
                        mCamera.takePicture(null, null, mPicture);

                    }
                }
        );


    }

    private void releaseCameraAndPreview() {
        if (mCamera != null) {
            mCamera.release();
            mCamera = null;
        }
    }

    @Override
    public void onDestroy() {
        releaseCameraAndPreview();
        //mHandler.removeCallbacks(mTimer);
        Log.e(MainActivity.DEBUG_TAG, "onDestroy");
        super.onDestroy();
    }
}

