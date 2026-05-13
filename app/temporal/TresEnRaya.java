package com.example.miniplay.games.tresenraya;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.widget.ConstraintLayout;

import com.bumptech.glide.Glide;
import com.example.miniplay.R;
import com.example.miniplay.activities.MenuActivity;
import com.example.miniplay.games.ppt.PiedraPapelTijera;
import com.example.miniplay.network.ApiService;
import com.example.miniplay.network.RetrofitClient;

import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Random;

import okhttp3.MediaType;
import okhttp3.RequestBody;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class TresEnRaya extends AppCompatActivity implements View.OnClickListener {

    private Button[] buttons = new Button[9];

    private boolean userTurn = true;
    private int roundCount = 0;

    private TextView tvStatus;
    ConstraintLayout panelVictoria;
    ConstraintLayout panelEmpate;
    ConstraintLayout panelDerrota;

    Button boton;
    Button boton2;
    Button boton3;
    int idUsuario;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_tres_en_raya);

        SharedPreferences prefs = getSharedPreferences("app", MODE_PRIVATE);
        idUsuario = prefs.getInt("id_usuario",-1);

        tvStatus = findViewById(R.id.tvStatus);

        panelVictoria = findViewById(R.id.panelVictoria);
        panelEmpate = findViewById(R.id.panelEmpate);
        panelDerrota = findViewById(R.id.panelDerrota);




        for (int i = 0; i < 9; i++) {
            String bID = "btn_" + i;
            int resID = getResources().getIdentifier(bID, "id", getPackageName());
            buttons[i] = findViewById(resID);
            buttons[i].setOnClickListener(this);
        }

        boton = findViewById(R.id.button);
        boton2 = findViewById(R.id.button2);
        boton3 = findViewById(R.id.button22);
        ImageView imageView7 = findViewById(R.id.imageView7);
        Glide.with(this).asGif().load(R.drawable.palmas).into(imageView7);
        ImageView imageView77 = findViewById(R.id.imageView77);
        Glide.with(this).asGif().load(R.drawable.guantes).into(imageView77);
        ImageView imageView777 = findViewById(R.id.imageView777);
        Glide.with(this).asGif().load(R.drawable._0a2461a_296c_4ea5_a16f_8271f3b7da9b).into(imageView777);
        tvStatus.setText("Tu turno (X)");
    }

    @Override
    public void onClick(View v) {
        if (!userTurn) {
            return;
        }

        Button botonPulsado = (Button) v;

        if (!botonPulsado.getText().toString().equals("")) {
            Toast.makeText(this, "Casilla ocupada", Toast.LENGTH_SHORT).show();
            return;
        }

        botonPulsado.setText("X");
        roundCount++;

        if (checkWin("X")) {
            finalizarJuego("Win");
        } else if (roundCount == 9) {
            finalizarJuego("Empate");
        } else {
            userTurn = false;
            tvStatus.setText("Turno del Bot...");

            new Handler(Looper.getMainLooper()).postDelayed(new Runnable() {
                @Override
                public void run() {
                    turnoBot();
                }
            }, 800);
        }
    }

    private void turnoBot() {
        int chosen = elegirMovimientoBot();

        if (chosen == -1) {
            finalizarJuego("Empate");
            return;
        }

        buttons[chosen].setText("O");
        roundCount++;

        if (checkWin("O")) {
            finalizarJuego("Lose");
        } else if (roundCount == 9) {
            finalizarJuego("Empate");
        } else {
            userTurn = true;
            tvStatus.setText("Tu turno (X)");
        }
    }

    private int elegirMovimientoBot() {
        int movimiento;

        // 1. El bot intenta ganar
        movimiento = buscarMovimientoGanador("O");
        if (movimiento != -1) {
            return movimiento;
        }

        // 2. El bot intenta bloquear al jugador
        movimiento = buscarMovimientoGanador("X");
        if (movimiento != -1) {
            return movimiento;
        }

        // 3. Si el centro está libre, lo coge
        if (buttons[4].getText().toString().equals("")) {
            return 4;
        }

        // 4. Si no, elige una casilla aleatoria libre
        return elegirCasillaAleatoria();
    }

    private int buscarMovimientoGanador(String jugador) {
        int[][] winPos = {
                {0, 1, 2},
                {3, 4, 5},
                {6, 7, 8},
                {0, 3, 6},
                {1, 4, 7},
                {2, 5, 8},
                {0, 4, 8},
                {2, 4, 6}
        };

        for (int[] p : winPos) {
            String b1 = buttons[p[0]].getText().toString();
            String b2 = buttons[p[1]].getText().toString();
            String b3 = buttons[p[2]].getText().toString();

            if (b1.equals(jugador) && b2.equals(jugador) && b3.equals("")) {
                return p[2];
            }

            if (b1.equals(jugador) && b3.equals(jugador) && b2.equals("")) {
                return p[1];
            }

            if (b2.equals(jugador) && b3.equals(jugador) && b1.equals("")) {
                return p[0];
            }
        }

        return -1;
    }

    private int elegirCasillaAleatoria() {
        int[] libres = new int[9];
        int totalLibres = 0;

        for (int i = 0; i < buttons.length; i++) {
            if (buttons[i].getText().toString().equals("")) {
                libres[totalLibres] = i;
                totalLibres++;
            }
        }

        if (totalLibres == 0) {
            return -1;
        }

        Random random = new Random();
        return libres[random.nextInt(totalLibres)];
    }

    private boolean checkWin(String jugador) {
        int[][] winPos = {
                {0, 1, 2},
                {3, 4, 5},
                {6, 7, 8},
                {0, 3, 6},
                {1, 4, 7},
                {2, 5, 8},
                {0, 4, 8},
                {2, 4, 6}
        };

        for (int[] p : winPos) {
            String b1 = buttons[p[0]].getText().toString();
            String b2 = buttons[p[1]].getText().toString();
            String b3 = buttons[p[2]].getText().toString();

            if (b1.equals(jugador) && b2.equals(jugador) && b3.equals(jugador)) {
                return true;
            }
        }

        return false;
    }

    private void finalizarJuego(String resultado) {
        userTurn = false;

        if (resultado.equals("Win")) {
            guardarPartida("Win",100);
            new Handler(Looper.getMainLooper()).postDelayed(() -> {

                panelVictoria.setVisibility(View.VISIBLE);

            }, 2000);
            boton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Intent intent = new Intent(TresEnRaya.this, MenuActivity.class);
                    startActivity(intent);
                }
            });

        } else if (resultado.equals("Lose")) {
            guardarPartida("Lose",0);
            new Handler(Looper.getMainLooper()).postDelayed(() -> {

                panelDerrota.setVisibility(View.VISIBLE);

            }, 2000);

            boton3.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Intent intent = new Intent(TresEnRaya.this, MenuActivity.class);
                    startActivity(intent);
                }
            });

        } else {
            guardarPartida("Empate",30);
            new Handler(Looper.getMainLooper()).postDelayed(() -> {

                panelEmpate.setVisibility(View.VISIBLE);

            }, 2000);
            boton2.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Intent intent = new Intent(TresEnRaya.this, MenuActivity.class);
                    startActivity(intent);
                }
            });
        }
    }

    private void guardarPartida(String resultado, int puntuacion) {
        if (idUsuario == -1) {
            Toast.makeText(this, "No se ha encontrado el usuario", Toast.LENGTH_SHORT).show();
            return;
        }

        try {
            JSONObject json = new JSONObject();

            json.put("id_usuario", idUsuario);
            json.put("id_juego", 2);
            json.put("fecha_partida", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new Date()));
            json.put("puntuacion", puntuacion);
            json.put("resultado", resultado);

            RequestBody body = RequestBody.create(
                    MediaType.parse("application/json; charset=utf-8"),
                    json.toString()
            );

            ApiService api = RetrofitClient.getClient().create(ApiService.class);

            api.guardarPartida(body).enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    // Partida guardada correctamente o respuesta recibida
                }

                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    Toast.makeText(TresEnRaya.this, "Error al guardar partida", Toast.LENGTH_SHORT).show();
                }
            });

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


}