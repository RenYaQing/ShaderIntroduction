Shader "Custom/8_Tex2D/UVAnim"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
        _Cycle ("Cycle", Range(1, 30)) = 10//周期
        _Amplitude ("Amplitude", Range(0, 0.06)) = 0.01
        _Radius ("Radius", Range(0, 1)) = 1
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex: POSITION;
                float2 uv: TEXCOORD0;
            };

            struct v2f
            {
                float2 uv: TEXCOORD0;
                float4 vertex: POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Cycle;
            float _Amplitude;
            float _Radius;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            fixed4 frag(v2f i): Color
            {
                fixed4 col;
                // i.uv += _Time.x;

                // i.uv.x += 0.01 * sin(i.uv.x *10+ _Time.y);//x方向
                // i.uv += _Amplitude * sin(i.uv * _Cycle + _Time.y);//xy方向
                float2 uv = i.uv;
                float dis = distance(uv, float2(0.5, 0.5));
                float scale;
                if (dis < _Radius)
                {
                    float edge = 1 - dis / _Radius;
                    scale = _Amplitude * sin(-dis * _Cycle + _Time.y);
                    uv += scale;
                }
                
                col = tex2D(_MainTex, uv); //+ fixed4(1, 1, 1, 1) * scale * 5;
                return col;
            }
            ENDCG
            
        }
    }
}
