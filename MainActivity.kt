package com.example.helloworld

import android.graphics.Color
import android.os.Bundle
import android.view.ViewGroup
import android.widget.GridLayout
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.setMargins

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val gridLayout = findViewById<GridLayout>(R.id.gridLayout)

        val squareSize = 50 // Adjust this size as needed

        for (i in 0 until 16) {
            for (j in 0 until 16) {
                val square = GridLayout.LayoutParams()
                square.width = squareSize
                square.height = squareSize
                square.setMargins(2)

                val squareView = android.view.View(this)
                squareView.layoutParams = square
                squareView.setBackgroundColor(Color.BLACK)

                gridLayout.addView(squareView)
            }
        }
    }
}
