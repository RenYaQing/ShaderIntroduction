using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaveTexture : MonoBehaviour
{
    private float[,] waveA;
    private float[,] waveB;
    private Texture2D texture2D;
    private int waveWidth = 128;
    private int waveHeight = 128;
    void Start()
    {
        waveA = new float[waveWidth, waveHeight];
        waveB = new float[waveWidth, waveHeight];
        texture2D = new Texture2D(waveWidth, waveHeight);

        GetComponent<Renderer>().material.SetTexture("_WaveTex", texture2D);
        Putpop();
    }

    // Update is called once per frame
    void Update()
    {
        Wave();
    }
    void Putpop()
    {
        int w = waveWidth / 2;
        int h = waveHeight / 2;
        waveA[w, h] = 1;
        waveA[w + 1, h] = 1;
        waveA[w, h - 1] = 1;
        waveA[w - 1, h] = 1;
        waveA[w, h + 1] = 1;
        waveA[w + 1, h + 1] = 1;
        waveA[w + 1, h - 1] = 1;
        waveA[w - 1, h - 1] = 1;
        waveA[w - 1, h + 1] = 1;
    }
    void Wave()
    {
        for (int w = 1; w < waveWidth - 1; w++)
        {
            for (int h = 1; h < waveHeight - 1; h++)
            {
                waveB[w, h] = (waveA[w, h + 1] +
                waveA[w + 1, h + 1] +
                waveA[w + 1, h] +
                waveA[w + 1, h - 1] +
                waveA[w, h - 1] +
                waveA[w - 1, h - 1] +
                waveA[w - 1, h] +
                waveA[w - 1, h + 1]) / 4 - waveB[w, h];

                waveB[w, h] = Mathf.Clamp(waveB[w, h], -1, 1);
                float offset_u = (waveB[w - 1, h] - waveB[w + 1, h]) / 2;
                float offset_v = (waveB[w, h - 1] - waveB[w, h + 1]) / 2;

                float r = offset_u * 0.5f + 0.5f;
                float g = offset_v * 0.5f + 0.5f;
                
                texture2D.SetPixel(w, h, new Color(r, g, 0));

                waveB[w, h] -= waveB[w, h] * 0.01f;
            }
        }
        texture2D.Apply();
        float[,] temp = waveA;
        waveA = waveB;
        waveB = temp;
    }
}
