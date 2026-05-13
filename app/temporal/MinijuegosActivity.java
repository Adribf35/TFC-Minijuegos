package com.example.miniplay.activities;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;

import com.example.miniplay.R;
import com.example.miniplay.games.ppt.PiedraPapelTijera;
import com.example.miniplay.games.tresenraya.TresEnRaya;

public class MinijuegosActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_minijuegos);
        var PPT = findViewById(R.id.imageView5);
        var PPT2 = findViewById(R.id.textView11);

        PPT.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MinijuegosActivity.this, PiedraPapelTijera.class);
                startActivity(intent);
            }
        });

        PPT2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MinijuegosActivity.this, PiedraPapelTijera.class);
                startActivity(intent);
            }
        });

        View btnTER = findViewById(R.id.imageView10);
        btnTER.setOnClickListener(v -> {
            Intent intent = new Intent(MinijuegosActivity.this, TresEnRaya.class);
            startActivity(intent);
        });
    }
}