// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/7_UV/Blur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
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
                float4 vertex: SV_POSITION;
                float z: TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.z = mul(unity_ObjectToWorld, v.vertex).z;
                return o;
            }

            fixed4 frag(v2f i): SV_Target
            {
                
                /*
                fixed4 col = tex2D(_MainTex, i.uv);
                i.uv.x += 0.01;
                col += tex2D(_MainTex, i.uv);
                i.uv.y += 0.01;
                col += tex2D(_MainTex, i.uv);
                col /= 3;
                */

                /*
                float dx = ddx(i.uv.x)*5;
                float2 dsdx = float2(dx, dx);
                float dy = ddy(i.uv.y)*5;
                float2 dsdy = float2(dy, dy);
                fixed4 col = tex2D(_MainTex, i.uv, dsdx, dsdy);
                */

                //正面清晰，侧面模糊
                float dx = ddx(i.z) * 10;
                float2 dsdx = float2(dx, dx);
                float dy = ddy(i.z)*10;
                float2 dsdy = float2(dy, dy);
                fixed4 col = tex2D(_MainTex, i.uv, dsdx, dsdy);
                return col;
            }
            ENDCG
            
        }
    }
}
