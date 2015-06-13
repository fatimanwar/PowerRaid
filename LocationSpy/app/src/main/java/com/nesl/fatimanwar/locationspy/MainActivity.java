package com.nesl.fatimanwar.locationspy;

import android.app.Activity;
import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;


public class MainActivity extends Activity {
    private static final String TAG = "MainActivity";

    private static final long MINIMUM_DISTANCE_CHANGE_FOR_UPDATES = 1; // in Meters
    private static final long MINIMUM_TIME_BETWEEN_UPDATES = 1000 * 60; // in Milliseconds - 1 min

    protected LocationManager locationManager;
    protected Button retrieveLocationButton;

    private final Handler mHandler = new Handler();
    private Runnable mTimer;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        retrieveLocationButton = (Button) findViewById(R.id.retrieve_location_button);
        locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);

      /*  Criteria criteria = new Criteria();
        criteria.setAccuracy(Criteria.ACCURACY_COARSE);
        //criteria.setAltitudeRequired(true);

        List<String> providers = locationManager.getProviders(
                criteria, true);

        for (String provider : providers) {*/
            locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, MINIMUM_TIME_BETWEEN_UPDATES,
                    MINIMUM_DISTANCE_CHANGE_FOR_UPDATES, locationListenerGps); //take one minute gap for gps location
        locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 30000,
                MINIMUM_DISTANCE_CHANGE_FOR_UPDATES, locationListenerNetwork); //take half a minute gap for network updates
      //  }


        retrieveLocationButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showCurrentLocation();
            }
        });

    /*    mTimer = new Runnable() {
            @Override
            public void run() {
                retrieveLocationButton.performClick();
                //mCamera.takePicture(null, null, new CameraCallBackProcedure(getApplicationContext()));
                mHandler.postDelayed(this, 10000);
            }
        };
        mHandler.postDelayed(mTimer, 10000);
        */
    }

    protected void showCurrentLocation() {
        Location location = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
        if (location != null) {
            String message = String.format("Current Location \n Longitude: %1$s \n Latitude: %2$s",
                    location.getLongitude(), location.getLatitude());
            Toast.makeText(MainActivity.this, message,Toast.LENGTH_LONG).show();
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        //mHandler.removeCallbacks(mTimer);
        locationManager.removeUpdates(locationListenerNetwork);
        locationManager.removeUpdates(locationListenerGps);
        Log.i(TAG, "onDestroy");
    }

    LocationListener locationListenerNetwork = new LocationListener() {
        public void onLocationChanged(Location location) {
            String message = String.format("New Location from network\n Longitude: %1$s \n Latitude: %2$s",
                    location.getLongitude(), location.getLatitude());
            Toast.makeText(MainActivity.this, message, Toast.LENGTH_LONG).show();
        }
        public void onProviderDisabled(String provider) {
            Toast.makeText(MainActivity.this,"network disabled by the user. GPS turned off",Toast.LENGTH_LONG).show();
        }
        public void onProviderEnabled(String provider) {
            Toast.makeText(MainActivity.this,"network enabled by the user. GPS turned on",Toast.LENGTH_LONG).show();
        }
        public void onStatusChanged(String provider, int status, Bundle extras) {
            Toast.makeText(MainActivity.this, "network status changed",Toast.LENGTH_LONG).show();
        }
    };

    LocationListener locationListenerGps = new LocationListener() {

        public void onLocationChanged(Location location) {
            String message = String.format("New Location from gps\n Longitude: %1$s \n Latitude: %2$s",
                    location.getLongitude(), location.getLatitude());
            Toast.makeText(MainActivity.this, message, Toast.LENGTH_LONG).show();
        }

        public void onStatusChanged(String s, int i, Bundle b) {
            Toast.makeText(MainActivity.this, "gps status changed",Toast.LENGTH_LONG).show();
        }
        public void onProviderDisabled(String s) {
            Toast.makeText(MainActivity.this,"gps disabled by the user. GPS turned off",Toast.LENGTH_LONG).show();
        }

        public void onProviderEnabled(String s) {
            Toast.makeText(MainActivity.this,"gps enabled by the user. GPS turned on",Toast.LENGTH_LONG).show();
        }
    };
}





