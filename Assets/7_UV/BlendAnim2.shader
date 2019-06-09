// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/7_UV/BlendAnim2"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" { }
        _SecondTex ("SecondTex", 2D) = "white" { }
        _Frequency ("Frequency", Range(1, 10)) = 4
    }
    SubShader
    {
        Pass
        {
            ColorMask rb
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
                float4 vertex: SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _SecondTex;
            float _Frequency;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i): SV_Target
            {
                
                fixed4 mainColor = tex2D(_MainTex, i.uv);
                float2 uv = i.uv;
                float offset = 0.05 * sin(uv * _Frequency + _Time.x * 2);
                uv += offset;
                fixed4 secondColor = tex2D(_SecondTex, uv);
               
                mainColor *= secondColor.r;
                mainColor *= 1.5;
               


                // uv = i.uv;
                // uv -= offset;
                // fixed4 secondColor1 = tex2D(_SecondTex, uv);
                // mainColor *= secondColor1.r;
                // mainColor *= 1.5;


                // mainColor += secondColor;
                
                return mainColor;
            }
            ENDCG
            
        }
    }
}
